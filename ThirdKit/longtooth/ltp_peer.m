//
//  ltp_peer.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/26.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"
#import "LTGCDAsyncSocket.h"
#define STATE_LAN_KEEPALIVE 0
#define STATE_LAN_KEEPALIVE_ACK 1

#define STATE_SWITCH_DISCONNECT 0
#define STATE_SWITCH_KEEPALIVE 1
#define STATE_SWITCH_KEEPALIVE_ACK 2

static BOOL LAN_DISABLED = FALSE;
static NSMutableDictionary* LTP_PEER_MAP;
static NSLock* LTP_PEER_LOCK;
void ltp_peer_init(){
    LTP_PEER_LOCK = [[NSLock alloc]init];
    LTP_PEER_MAP = [[NSMutableDictionary alloc]init];
}
void lt_lan_mode_set(bool enable){
    LAN_DISABLED = !enable;
}
bool ltp_peer_lan_disabled(){
    return LAN_DISABLED;
}
ltp_peer* _Nullable ltp_peer_create(const char* _Nonnull ltid,ltp_sock_send sock_send){
    @autoreleasepool {
    ltp_peer* peer = nil;
    NSData* ltidkey = [NSData dataWithBytes:ltid length:12];
    [LTP_PEER_LOCK lock];
    peer = [LTP_PEER_MAP objectForKey:ltidkey];
    if(peer==nil){
        peer = [[ltp_peer alloc]init];
        peer.cond = [[NSCondition alloc]init];
        
        peer.ltid = ltidkey;
        
        peer.ltaddr = nil;
        peer.ltaddr_find_timestamp = 0;
        
        peer.sock_addr = nil;
        peer.send = sock_send;
        
        peer.switch_path = nil;
        
        peer.lan_addr = nil;
        peer.lan_state = 0;
        peer.lan_state_timestamp = 0;
        peer.lan_state_count = 0;
        
        peer.p2p_addr = nil;
        peer.p2p_state = 0;
        peer.p2p_state_timestamp = 0;
        peer.p2p_state_count = 0;
        [LTP_PEER_MAP setObject:peer forKey:ltidkey];
        
    }
    [LTP_PEER_LOCK unlock];
    return peer;
    }
}
ltp_peer* _Nullable ltp_peer_get(const char* _Nonnull ltid){
    ltp_peer* peer = nil;
    NSData* ltidkey = [NSData dataWithBytes:ltid length:12];
    [LTP_PEER_LOCK lock];
    peer = [LTP_PEER_MAP objectForKey:ltidkey];
    [LTP_PEER_LOCK unlock];
    return peer;
}

@implementation ltp_peer

-(void) lan_keepalive{
    if(LAN_DISABLED){
        return;
    }
    size_t len = 20+12+12+4;
    char data[len];
    NSData* addr;
    if(self.lan_addr!=NULL){
        
        ltp_encode_bytes(data,len, 0, 0, 0, T_LAN, A_LAN_KEEPALIVE);
        ltp_ltid_bytes(self.ltid.bytes, &data[20]);
        ltp_ltid_bytes(ltp_local_ltid(), &data[20+12]);
        addr = self.lan_addr;
    }else{

        ltp_encode_bytes(data,len, 0, 0, 0, T_LAN, A_LAN_WHOIS);
        ltp_ltid_bytes(self.ltid.bytes, &data[20]);
        ltp_ltid_bytes(ltp_local_ltid(), &data[20+12]);
        addr = ltp_multicast_addr();
    }
    @autoreleasepool {
    ltp_udp_sock_send(addr, [NSData dataWithBytes:data length:len]);
    }
    self.lan_state = STATE_LAN_KEEPALIVE;
    self.lan_state_timestamp = ltp_sys_uptime();
    
}
-(void) lan_keepalive_ack:(NSData*) addr{
    if(LAN_DISABLED){
        return;
    }
    self.lan_addr = addr;
    self.lan_state = STATE_LAN_KEEPALIVE_ACK;
    self.lan_state_timestamp = ltp_sys_uptime();
    
}
-(void) p2p_maintain{
    
}
-(void) lan_maintain{
    int64_t now = ltp_sys_uptime();
    int64_t interval = now - self.lan_state_timestamp;
//    NSLog(@"%s,%d,%lld,%d",__FUNCTION__,self.lan_state,interval,self.lan_state_count);
    if(self.lan_addr==nil){
//        NSLog(@"%s......",__FUNCTION__);
        if(interval>3000){
            [self lan_keepalive];
            self.lan_state_count++;
        }
    }else if(self.lan_state == STATE_LAN_KEEPALIVE&&interval>100){
        
        if(self.lan_state_count<5){
            [self lan_keepalive];
            self.lan_state_count++;
        }else{
            self.lan_addr = nil;
        }
    }else if(self.lan_state == STATE_LAN_KEEPALIVE_ACK&&interval>3000){
        [self lan_keepalive];
    }
}

// victor
-(void) switch_keepalive{
    size_t len = 20+12;
    char data[20+12];
    ltp_encode_bytes(data,len, _ltaddr.bytes, ltp_local_ltaddr(), 0, T_PEER, A_PEER_KEEPALIVE);
    ltp_ltid_bytes(ltp_local_ltid(), &data[20]);
    ltp_udp_sock_send(_switch_path.addr, [NSData dataWithBytes:data length:len]);
    _switch_state = STATE_SWITCH_KEEPALIVE;
    _switch_state_timestamp = ltp_sys_uptime();
//    NSLog(@"peer_switch_keepalive %@",_ltaddr);
}

// victor
-(void) switch_keepalive_ack{
    _switch_state = STATE_SWITCH_KEEPALIVE_ACK;
    _switch_state_timestamp = ltp_sys_uptime();
    _switch_state_count = 0;
}
// victor

-(void) switch_maintain{
    int64_t now = ltp_sys_uptime();
    int64_t interval = now - _switch_state_timestamp;
    if(_switch_state == STATE_SWITCH_DISCONNECT&&interval>1000){
        [self switch_keepalive];
        _switch_state = STATE_SWITCH_DISCONNECT;
    }else if(_switch_state == STATE_SWITCH_KEEPALIVE&&interval>1000){
        if(_switch_state_count<5){
            [self switch_keepalive];
            _switch_state_count++;
        }else{
            _switch_state = STATE_SWITCH_DISCONNECT;
            _switch_state_count = 0;
        }
    }else if(_switch_state == STATE_SWITCH_KEEPALIVE_ACK&&interval>3000){
        [self switch_keepalive];
    }
}

-(void) maintain{
    if(self.switch_path!=NULL){
        [self.switch_path maintain];
        if(_switch_path.state){
            [self switch_maintain];//victor
        }else{//#bug201706201008 fixed
            _switch_state = STATE_SWITCH_DISCONNECT;
            _switch_state_count = 0;
            _switch_state_timestamp = 0;
        }
    }
    [ltp_local_switch_path() maintain];
    [self lan_maintain];
    [self p2p_maintain];
    [self.cond lock];
//    NSLog(@"%s....%@...%@...%d...%d...",__FUNCTION__,self.lan_addr,self.p2p_addr,_switch_state,ltp_router_registered());
    if(self.lan_addr!=nil){
        self.send = ltp_udp_sock_send;
        self.sock_addr = self.lan_addr;
    }else if(self.p2p_addr!=nil){
        self.send = ltp_udp_sock_send;
        self.sock_addr = self.p2p_addr;
    }else if(_switch_state){ // victor
        self.send = ltp_udp_sock_send;
        self.sock_addr = self.switch_path.addr;
    }else if(ltp_router_registered()){
        self.send = ltp_tcp_sock_send;
        self.sock_addr = 0;
    }else{
        
        self.send = NULL;
    }     if(self.send!=NULL){
        [self.cond broadcast];
    }
    [self.cond unlock];
}


-(void) send:(NSData*) data{
    if(self.send!=NULL){
        self.send(self.sock_addr,data);
    }
}

-(NSInteger) respond:(NSData *)lttkey dataType:(char)data_type arguments:(NSData *)resp_args waitable:(BOOL)wait{
    NSInteger resp_args_len = resp_args.length;
    size_t data_len = 20+1+2+resp_args_len;
    char data[LT_DATAPACKET_SIZE];
    ltp_encode_bytes(data,data_len, self.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_RESPONSE_SYN);
    memcpy(&data[14],&lttkey.bytes[6],4);
    data[20]=data_type;
    ltp_int16_bytes((int32_t)resp_args_len, &data[20+1]);
    if(resp_args_len>0){
        memcpy(&data[20+1+2], resp_args.bytes, resp_args_len);
    }
    NSInteger r = -1;
    [self.cond lock];
//    [self lan_keepalive];
    if(self.send==NULL){
        if(wait){
        [self.cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:15]];
        }
    }
    
    NSLog(@"-------------------%x",self.send);
    if(self.send!=NULL){
         @autoreleasepool {
        self.send(self.sock_addr,[NSData dataWithBytes:data length:data_len]);
             NSLog(@"%s..........",__FUNCTION__);
             for (int i = 0; i < data_len; i++) {
                 printf("%d ",data[i]);
             }
             printf("\n");
        }
        r = 1;
    }
    [self.cond unlock];
    return r;
}


-(int) lookup{
    int timeout = 4;
    if(ltp_router_registered()){
        char data[32];
        ltp_encode_bytes(data,32, NULL,NULL, 0, T_ROUTER, A_ROUTER_LOOKUP);
        ltp_ltid_bytes(_ltid.bytes,&data[2]);
        ltp_ltid_bytes(ltp_local_ltid(),&data[20]);
        @autoreleasepool {
        ltp_tcp_sock_send(nil,[NSData dataWithBytes:data length:32]);
//            NSLog(@"ltpeer.lookup %@",ltp_ltid_nsstring(_ltid));
        }
        timeout = 10;
    }
    return timeout;
}

- (int)dataToInt:(NSData *)data {
    Byte byte[6] = {};
    [data getBytes:byte length:6];
    char value ;
    if((value = (char)(byte[0] & 0xFF)) ==  -1 )
        if((value = (char)(byte[1] & 0xFF)) == -1)
            if((value = (char)(byte[2] & 0xFF)) == -1)
                if((value = (char)(byte[3] & 0xFF)) == -1)
                    if((value = (char)(byte[4] & 0xFF)) == -1)
                        if((value = (char)(byte[5] & 0xFF)) == -1)
                            return -1;
    return 0;
}

-(NSInteger) request:(const char *)sessionid serviceName:(NSString *)srv_name dataType:(char)data_type arguments:(NSData *)req_args waitable:(BOOL) wait{
    
    [self maintain];
    [_cond lock];
    int timeout = 10;
    
    int ipport = [self dataToInt:_ltaddr];
    //  if(_ltaddr==nil&&ltp_sys_uptime()-_ltaddr_find_timestamp>10000){
    
    if(_ltaddr==nil || ipport == -1){
        timeout = [self lookup];
    }
//    [self lookup];
    
    if(_send==NULL){
        ltp_log(@"request wait");
        if(wait){
        [_cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeout]];
        }
        ltp_log(@"request wakeup");
        if(_send==NULL){
            [_cond unlock];
            return -1;
        }
    }
    
    [_cond unlock];
    size_t sl = srv_name.length;
    size_t al = req_args.length;
    size_t data_len = 20+45+sl+al;
    char data[LT_DATAPACKET_SIZE];

    ltp_encode_bytes(data,data_len, _ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_REQUEST_SYN);
    if(_ltaddr==nil){
        memset(&data[2],-1,6);
    }
    memcpy(&data[14],sessionid,4);
    data[20]=data_type;
    ltp_ltid_bytes(_ltid.bytes, &data[28]);
    ltp_ltid_bytes(ltp_local_ltid(), &data[40]);

    ltp_switch_path* sw = ltp_local_switch_path();
    if(sw.addr){
        const char* addrbytes = sw.addr.bytes;
        memcpy(&data[52],&addrbytes[4],4);
        int in_port = ltp_bytes_int16(&addrbytes[2]);
       // ltp_log(@"sw port %d",in_port);
        ltp_int16_bytes(ntohs(in_port),&data[56]);
        NSData* p2pipaddr = ltp_p2p_ip_addr();
        if (p2pipaddr) {
      
        }
    }

    data[64]=(char)sl;
    memcpy(&data[65], [srv_name cStringUsingEncoding:NSUTF8StringEncoding],sl);
    
    memcpy(&data[65+sl], req_args.bytes,al);
    printf("===> send data:\r\n");
    for(int i = 0; i < 80; i++)
    {
        printf("%d ", data[i]);
    }
    printf("\r\n");
    NSLog(@"_lan_addr  %@,%@",_lan_addr,_ltaddr);
    @autoreleasepool {
    if(_lan_addr){
        ltp_udp_sock_send(_lan_addr, [NSData dataWithBytes:data length:data_len]);
    }else if(_ltaddr!=nil&&ltp_router_registered()){
        ltp_tcp_sock_send(_lan_addr, [NSData dataWithBytes:data length:data_len]);
    }
    }

    return 0;
}
@end
