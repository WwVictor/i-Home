//
//  ltp_tunnel.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/26.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"

#define TUNNELS_MAX 1000
#define LT_STREAM_WIN_SIZE 32

#define LT_TUNNEL_RESYNC_INTERVAL 1500//3000 to tuyyo app modify
//#define LT_TUNNEL_RESYNC_TIMEOUT 30
#define LT_TUNNEL_RESYNC_TIMEOUT 5000 //10000

#define DATAGRAM_PAYLOAD (LT_DATAPACKET_SIZE-20)
static NSMutableDictionary* TUNNEL_MAP;
static NSLock* TUNNEL_MAP_LOCK;
static NSMutableData* TUNNEL_KEY;
static NSRange TUNNEL_KEY_RANGE = {0,10};
static ltp_tunnel* TUNNELS[TUNNELS_MAX]={nil};
static size_t TUNNELS_SIZE = 0;
static NSCondition* TUNNELS_COND;
static NSLock* TUNNELS_LOCK;
static NSLock* TUNNEL_CREATE_LOCK;
static int32_t BASE_SESSIONID=0;

void ltp_tunnel_init(){
    TUNNEL_MAP = [[NSMutableDictionary alloc]init];
    TUNNEL_MAP_LOCK = [[NSLock alloc]init];
    TUNNELS_COND = [[NSCondition alloc]init];
    TUNNELS_LOCK = [[NSLock alloc]init];
    TUNNEL_CREATE_LOCK = [[NSLock alloc]init];
    char bytes[10];
    TUNNEL_KEY = [[NSMutableData alloc]initWithBytes:bytes length:10];
}

void ltp_tunnel_remove(NSData* _Nonnull key){
    [TUNNEL_MAP_LOCK lock];
//    const char *key1 = key.bytes;
//    printf("%s",__FUNCTION__);
//    printf("\n");
//    for (int i = 0 ; i < 10; i++) {
//        PT_Log(@"%d：", key1[i]);
//    }
//    printf("\n");
    [TUNNEL_MAP removeObjectForKey:key];
    [TUNNEL_MAP_LOCK unlock];
}

static int flag=0;
void ltp_tunnels_maintain(){
    while(true){
        
    if(flag++ < 1){// victor 供测试所用
        NSLog(@"%s tunnels=%zu",__FUNCTION__,TUNNELS_SIZE);
    }
    int i=0;
    int c=0;
    [TUNNELS_COND lock];
    if(TUNNELS_SIZE==0){
        [TUNNELS_COND wait];
    }
    for(;i<TUNNELS_MAX;i++){
        @autoreleasepool {

        ltp_tunnel* tunnel = TUNNELS[i];
        
        if(tunnel!=NULL){
            if (ltp_sys_uptime() - tunnel.create_timestamp > tunnel.wait_timestamp) {
                ltp_tunnel_remove(tunnel.key);
            }
            
            if(tunnel.fin_acked){
                if(tunnel.fin_acked==1){
                    ltp_tunnel_remove(tunnel.key);
                    tunnel.fin_acked = 2;
                    tunnel.fin_ack_timestamp = ltp_sys_uptime();
                    if(tunnel.input!=NULL){
                        [tunnel.input close];
                    }
                    if(tunnel.output!=NULL){
                        [tunnel.output kill];
                    }
                    tunnel.outd_closed = true;
                    tunnel.ind_closed  =true;
                    if(tunnel.inputd!=NULL){
                        [tunnel.inputd close];
                    }
                    
                }else if(tunnel.fin_acked==2&&ltp_sys_uptime()-tunnel.fin_ack_timestamp>1000){
                    TUNNELS[i] = NULL;
                    TUNNELS_SIZE--;
                    NSLog(@"tunnel removed %d %@ %@ %d",tunnel.outd_closed,tunnel.key,tunnel.srv_name,tunnel.keep_count);
                }
            }else{
                [tunnel maintain];
                [tunnel.peer maintain];
            }
            c++;
            if(c==TUNNELS_SIZE){
                i=TUNNELS_MAX;
            }
        }
        }
    }
            [TUNNELS_COND unlock];
        if(TUNNELS_SIZE>0){
            [NSThread sleepForTimeInterval:0.005];// victor 
        }
//    [TUNNELS_COND unlock];
    }
}

ltp_tunnel* _Nullable ltp_tunnel_get(const char* _Nonnull key){
    ltp_tunnel* tunnel = nil;
    [TUNNEL_MAP_LOCK lock];
    [TUNNEL_KEY replaceBytesInRange:TUNNEL_KEY_RANGE withBytes:key];
    tunnel = [TUNNEL_MAP objectForKey:TUNNEL_KEY];
    [TUNNEL_MAP_LOCK unlock];
    return tunnel;
}

ltp_tunnel* _Nullable ltp_tunnel_create(ltp_peer* peer,
                                        char type,
                                        NSData* lttkey,
                                        NSString* srv_name,
                                        NSData* req_args,
                                        char req_data_type,
                                        id<LongToothServiceRequestHandler> req_handler,
                                        id<LongToothServiceResponseHandler> resp_handler,
                                        id<LongToothAttachment> attachment)
{
    @autoreleasepool {
    ltp_tunnel* tunnel = nil;
    [TUNNEL_CREATE_LOCK lock];
    tunnel = [[ltp_tunnel alloc]init];
    tunnel.key = lttkey;
    tunnel.peer = peer;
    tunnel.srv_name = srv_name;
    tunnel.input = nil;
    tunnel.in_closed=0;
    tunnel.output = nil;
    tunnel.out_closed = 0;
    tunnel.inputd = nil;
    tunnel.ind_closed = 0;
    tunnel.outd_closed = 0;
    tunnel.lock = [[NSLock alloc]init];
    tunnel.req_args = req_args;
    tunnel.req_data_type = req_data_type;
    tunnel.req_handler = req_handler;
    tunnel.resp_args = nil;
    tunnel.resp_data_type = -1;
    tunnel.resp_handler = resp_handler;
    tunnel.sync = 0;
    tunnel.sync_timestamp = 0;
    tunnel.sync_ack_timestamp = 0;
    tunnel.type = type;
    tunnel.attachment = attachment;
    tunnel.fined = 0;
    tunnel.fin_timestamp = 0;
    tunnel.fin_acked = 0;
    tunnel.fin_ack_timestamp = 0;
    tunnel.keep_ack_timestamp = 0;
    tunnel.keep_timestamp = 0;
    tunnel.keep_count=0;
    tunnel.create_timestamp = ltp_sys_uptime();
    tunnel.wait_timestamp = 10000;
    [TUNNELS_COND lock];
    for(int i=0;i<TUNNELS_MAX;i++){
        if(TUNNELS[i]==NULL){
            TUNNELS[i] = tunnel;
            TUNNELS_SIZE++;
            [TUNNELS_COND signal];
            break;
        }
    }
    [TUNNELS_COND unlock];
    [TUNNEL_MAP_LOCK lock];
        
//        const char*key = lttkey.bytes;
//        NSLog(@"ltp_tunnel_create.....");
//        for (int i = 0; i<10; i++) {
//            NSLog(@"%d :",key[i]);
//        }
//        NSLog(@"\n");
//
//
//        const char*key1 = tunnel.key.bytes;
//        NSLog(@"ltp_tunnel_create  Map key .....");
//        for (int i = 0; i<10; i++) {
//            NSLog(@"%d :",key1[i]);
//        }
//        NSLog(@"\n");
        
    [TUNNEL_MAP setObject:tunnel forKey:lttkey];
    [TUNNEL_MAP_LOCK unlock];
    [TUNNEL_CREATE_LOCK unlock];
    return tunnel;
    }
}

id<LongToothTunnel> lt_request(NSString* ltid_str,
               NSString* service_str,
               int lt_data_type,
               NSData* args,
               id<LongToothAttachment> attachment,
               id<LongToothServiceResponseHandler> resp_handler){

    if(lt_data_type<LT_ARGUMENTS||lt_data_type>LT_DATAGRAM||resp_handler==NULL){
        return nil;
    }
    [TUNNELS_LOCK lock];
    if(BASE_SESSIONID==0){
        BASE_SESSIONID = (int32_t)ltp_sys_uptime();
    }
    BASE_SESSIONID++;
    [TUNNELS_LOCK unlock];
    char ltt[10];
    memset(ltt, -1, 10);
    ltp_int32_bytes(BASE_SESSIONID, &ltt[6]);
    char ltid[12];
    ltp_str_ltid(ltid_str, ltid);
    
    ltp_peer* peer = ltp_peer_create(ltid,nil);
    if(peer.ltaddr!=nil){
        ltp_ltaddr_bytes(peer.ltaddr.bytes, ltt);
    }
    NSData* lttkey = [NSData dataWithBytes:ltt length:10];
    ltp_tunnel* tunnel=ltp_tunnel_create(peer, A_TUNNEL_REQUEST_SYN, lttkey, service_str, args,lt_data_type,nil,resp_handler,attachment);
    NSLog(@"%s     %@",__FUNCTION__,peer.ltaddr);
//    NSLog(@"lt_request.....");
//    for (int i = 0; i<10; i++) {
//        NSLog(@"%d :",ltt[i]);
//    }
//    NSLog(@"\n");
//
    
    if(lt_data_type==LT_STREAM){
        tunnel.output = ltp_tunnel_outputstream_create(peer,&ltt[6]);
        tunnel.outd_closed = 1;
    }else if(lt_data_type == LT_DATAGRAM){
        tunnel.out_closed = 1;
    }else{
        tunnel.out_closed = 1;
        tunnel.outd_closed = 1;
    }
    [tunnel request_sync:TRUE];
    return tunnel;
}

int lt_respond(id<LongToothTunnel> ltt,
               int lt_data_type,
               NSData* args,
               id<LongToothAttachment> attachment){
    int r = -1;
    if(lt_data_type<LT_ARGUMENTS||lt_data_type>LT_DATAGRAM){
        return -2;
    }
    ltp_tunnel* tunnel = (ltp_tunnel*)ltt;
    if(tunnel.resp_data_type<LT_ARGUMENTS&&tunnel.type==A_TUNNEL_RESPONSE_SYN){
        tunnel.resp_args=args;
        tunnel.attachment = attachment;
        tunnel.resp_data_type=lt_data_type;
        if(lt_data_type==LT_STREAM){
            tunnel.output = ltp_tunnel_outputstream_create(tunnel.peer,&tunnel.key.bytes[6]);
            tunnel.outd_closed = 1;
        }else if(lt_data_type == LT_DATAGRAM){
            tunnel.out_closed = 1;
        }else{
            tunnel.out_closed = 1;
            tunnel.outd_closed = 1;
        }
        r = [tunnel response_sync:TRUE];
    }
    return r;
}


@implementation ltp_tunnel

-(void) request_sync:(BOOL) wait{
    if(_sync_count<LT_TUNNEL_RESYNC_TIMEOUT){
        int64_t now = ltp_sys_uptime();
        if(_sync_timestamp>0){
        _sync_count+=(now-_sync_timestamp);// Victor Internet timeout  
        }
        _sync_timestamp = now;
        ltp_router_keepalive();
        [_peer request:&_key.bytes[6] serviceName:_srv_name dataType:_req_data_type arguments:_req_args waitable:wait];
        _req_count ++;        
        NSData *data = [[NSString stringWithFormat:@"%lld",_req_count] dataUsingEncoding:NSUTF8StringEncoding];
        PT_Log(@"+++++++++%s,EVENT_LONGTOOTH_REQUEST_RETRY，。。。。。_sync_count%lld",__func__,_sync_count);
        ltp_event_fire(EVENT_LONGTOOTH_REQUEST_RETRY, ltp_ltid_nsstring(_peer.ltid), _srv_name, data,_attachment);
        
    }else{
        [_lock lock];
        _fined = true;
        _fin_acked=true;
        if(_output!=NULL){
            [_output kill];
        }
        _outd_closed = true;
        [_lock unlock];
        PT_Log(@">>>>>>>>%s,request timeout",__func__);
        ltp_event_fire(EVENT_LONGTOOTH_TIMEOUT, ltp_ltid_nsstring(_peer.ltid), _srv_name, NULL,_attachment);
    }
}
-(void) request_sync_ack{
    if(!_sync){
        _sync=true;
        _sync_count = 0;
        if(_req_data_type==LT_ARGUMENTS){
            _out_closed = true;
        }else if(_req_data_type==LT_STREAM){
            [_output limit:LT_STREAM_WIN_SIZE];
        }
    }
}
-(void) fin{
    if(_fin_count<10){
        char data[20];
        _fined = true;
        ltp_encode_bytes(data,20, _peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL,A_TUNNEL_FIN);
        memcpy(&data[14],&_key.bytes[6],4);
        @autoreleasepool {
            [_peer send:[NSData dataWithBytes:data length:20]];
        }
        _fin_count++;
    }else{
        _fin_acked = true;
    }
    _fin_timestamp = ltp_sys_uptime();
}
-(void) fin_ack{
    self.fin_acked = true;
    self.fin_ack_timestamp = ltp_sys_uptime();
    NSLog(@"fin_ack%@ %@",self.key,self.srv_name);

}
-(int) response_sync:(BOOL) wait{

    if(_sync_count<LT_TUNNEL_RESYNC_TIMEOUT){
                int64_t now = ltp_sys_uptime();// Victor Internet timeout
        if(_sync_timestamp>0){
            _sync_count+=(now-_sync_timestamp);
        }
        _sync_timestamp = now;
        _resp_count ++;
        NSData *data = [[NSString stringWithFormat:@"%lld",_resp_count] dataUsingEncoding:NSUTF8StringEncoding];
         PT_Log(@"======%s,EVENT_LONGTOOTH_RESPONSE_RETRY",__func__);
        ltp_event_fire(EVENT_LONGTOOTH_RESPONSE_RETRY, ltp_ltid_nsstring(_peer.ltid), _srv_name, data,_attachment);
       NSInteger res = [_peer respond:_key dataType:_resp_data_type arguments:_resp_args waitable:wait];
        NSLog(@"%s----------%@ %p,response_sync_count = %lld,%d,_sync_count%lld",__FUNCTION__,_srv_name,self,_resp_count,res,_sync_count
              );
        ltp_router_keepalive();
        return 0;
    }else{
        [_lock lock];
        _fined = true;
        _fin_acked=true;
        PT_Log(@"fin_ack response_sync%@ %@",self.key,self.srv_name);
        if(_output!=NULL){
            [_output kill];
        }
        if(_input!=NULL){
            [_input close];
        }
        _outd_closed = true;
        if(_inputd!=NULL){
            _ind_closed = true;
            [_inputd close];
        }
        [_lock unlock];
        PT_Log(@">>>>>>>>%s,response timeout",__func__);
        ltp_event_fire(EVENT_LONGTOOTH_TIMEOUT, ltp_ltid_nsstring(_peer.ltid), _srv_name, NULL,_attachment);

        return -1;
    }
}
-(void) response_sync_ack{
    if(!_sync){
        _sync=true;
        _sync_count = 0;
        if(_resp_data_type==LT_ARGUMENTS){
            _out_closed = true;
        }else if(_resp_data_type==LT_STREAM){
            [_output limit:LT_STREAM_WIN_SIZE];
        }
    }
}

-(void) close{
    [_lock lock];
    if(!_fined){
        [self fin];
    }
    [_lock unlock];
}
-(void) keepalive:(int64_t) now{
    if(now - _keep_timestamp>3000){
    //    NSLog(@"%s %lld %lld",__FUNCTION__,now,_keep_timestamp);
        if(_keep_count<10){
            _keep_timestamp = now;
//            PT_Log(@"%s %lld %lld",__FUNCTION__,now,_keep_timestamp);
            _keep_count++;
            char data[20];
            ltp_encode_bytes(data,20, _peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_KEEPALIVE);
            memcpy(&data[14],&_key.bytes[6],4);
            @autoreleasepool {
            [_peer send:[NSData dataWithBytes:data length:20]];

            }

        }else{
            [_lock lock];
            _fined = true;
            _fin_acked=true;
//            NSLog(@"fin_ack keepalive: %@ %@",self.key,self.srv_name);
            if(_output!=NULL){
                [_output kill];
            }
            if(_input!=NULL){
                [_input close];
            }
            _outd_closed = true;
            if(_inputd!=NULL){
                [_inputd close];
                _ind_closed = true;
            }
            [_lock unlock];
            ltp_event_fire(EVENT_SERVICE_TIMEOUT, ltp_ltid_nsstring(_peer.ltid), _srv_name, NULL,_attachment);
        }
    }
}

-(void) keepalive_ack{
    _keep_ack_timestamp = ltp_sys_uptime();
    _keep_count = 0;
}

-(void) maintain{
    int64_t now = ltp_sys_uptime();
    if(_fined){
        if(!_fin_acked&&now-_fin_timestamp>1000){
            [self fin];
        }
    }else{
        
        if(!_sync&&_sync_timestamp!=0&&now-_sync_timestamp>LT_TUNNEL_RESYNC_INTERVAL){
            if(_type==A_TUNNEL_REQUEST_SYN){
                [self request_sync:FALSE];
            }else if(_type==A_TUNNEL_RESPONSE_SYN){
                [self response_sync:FALSE];
            }
        }else if(_output!=NULL&&_sync&&!_out_closed){
            if([_output isClosed]){// victor
                _out_closed = true;
            }else{
            [_output keepalive:now];
            if([_output idle:now]>3000){
                [self keepalive:now];
            }else{
                [self keepalive_ack];
            }
            }
        }else if(_input!=NULL&&!_in_closed){
            if([_input idle:now]>3000){
                [self keepalive:now];
            }else{
                [self keepalive_ack];
            }
        }else if(!_outd_closed&&(_type==A_TUNNEL_REQUEST_SYN||_type==A_TUNNEL_RESPONSE_SYN)){
            if(_outd_timestamp==0){
                _outd_timestamp = now;
            }
            if(now-_outd_timestamp>3000){
                [self keepalive:now];
                PT_Log(@"outd keepalive %@ %@ %lld %lld",self.key,self.srv_name,now,_outd_timestamp);
                _outd_timestamp = now;
                
            }
        }else if(_inputd!=NULL&&!_ind_closed){
            if([_inputd idle:now]>3000){
                [self keepalive:now];
            }else{
                [self keepalive_ack];
            }
        }
        else if((_in_closed||_input==NULL)&&_out_closed&&
                (_ind_closed||_inputd==NULL)&&
                (_outd_closed||_output==NULL)&&
                _sync&&_resp_data_type!=-1){
            [self fin];
        }
        
        
    }
}
-(NSInteger) send:(NSData *)data{
   
    NSInteger c = -1;
    if(self.output!=nil){
        if(data==nil){
            [_output close];
        }else{
            
//            NSLog(@"send ......... ");
            c = [self.output write:data];
        }
    }else if((self.type==A_TUNNEL_REQUEST_SYN&&self.req_data_type==LT_DATAGRAM)||
             (self.type==A_TUNNEL_RESPONSE_SYN&&self.resp_data_type==LT_DATAGRAM)){
        if(!_outd_closed){
        if(data == nil){
            _outd_closed = 1;
            c = -1;
        }else if(data.length>DATAGRAM_PAYLOAD){
            c = 0;
        }else{
            c = data.length;
            NSInteger templen = c+20;
            char temp[templen];
            ltp_encode_bytes(temp,templen, _peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_DATAGRAM);
            const char* bytes = self.key.bytes;
            memcpy(&temp[14],&bytes[6],4);
            memcpy(&temp[20],data.bytes,c);
            NSData* buf = nil;
            @autoreleasepool {
                buf = [NSData dataWithBytes:temp length:templen];
            }
            [self.peer send:buf];
            
        }
        }
        
    }
    return c;
}

-(NSInteger) receive:(NSMutableData *)data{
    NSInteger c = -1;
    if(self.input!=nil){
        if(data==nil){// victor
            _in_closed = true;
            [_input close];
        }else{
            c = [self.input read:data];
            if(c==-1){
//                PT_Log(@"readed ----%lld,inputed ----- %lld,%@,%@",[self.input countReaded],[self.input countInputed],self.srv_name,TUNNELS);
            }
        }
    }else if(_inputd!=nil&&!_ind_closed){
        if(data==nil){
            _ind_closed = true;
            [_inputd close];
        }else{
            c = [self.inputd read:data];
        }
    }
//    NSLog(@"%s %d",__FUNCTION__,c);
    return c;
}

-(void) request_thread{
    
    NSThread *thread=[NSThread currentThread];
    [thread setName:@"Request_thread"];
    @autoreleasepool {
    [_req_handler handle:self withLongToothId:ltp_ltid_nsstring(_peer.ltid) withServiceName:_srv_name dataTypeIs:_req_data_type withArguments:_req_args];
    lt_respond(self, LT_ARGUMENTS, nil, nil);
    }
    
}
-(void) response_thread{
    NSThread *thread=[NSThread currentThread];
    [thread setName:@"response_thread"];
    @autoreleasepool {
        [_resp_handler handle:self withLongToothId:ltp_ltid_nsstring(_peer.ltid) withServiceName:_srv_name dataTypeIs:_resp_data_type withArguments:_resp_args attach:_attachment];
    }
}
@end
