//
//  ltp_tunnel_outputsteam.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/26.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"
ltp_tunnel_outputstream* _Nullable ltp_tunnel_outputstream_create(ltp_peer* _Nonnull peer,const char* _Nonnull sessionid){
    @autoreleasepool {
        return [[ltp_tunnel_outputstream alloc]initWith:peer sessionId:sessionid];
    }
}

ltp_tunnel_outputstream_packet* ltp_tunnel_outputstream_packet_create(const char* _Nonnull data,size_t len,int64_t pidx){
    @autoreleasepool {
        ltp_tunnel_outputstream_packet* packet = [[ltp_tunnel_outputstream_packet alloc]init];
        packet.data = [NSData dataWithBytes:data length:len];
        packet.count = 0;
        packet.send_timestamp = 0;
        packet.pidx = pidx;////20170911 by victor  int64_t pidx
        return packet;
    }
}
@implementation ltp_tunnel_outputstream_packet
@end

@implementation ltp_tunnel_outputstream
-(id) initWith:(ltp_peer*) peer sessionId:(const char*) sessionid{
    if(self=[super init]){
        memcpy(_sessionid,sessionid,4);
        memset(_packets,0,sizeof(_packets));
        _limit = 0;
        _head = 0;
        _length = 0;
        _cur = 0;
        _rtt = 0;
        _send_timeout = 0;
        _send_timestamp = 0;
        _ack_timestamp = 0;
        _opened = 1;
        _peer = peer;
        _pidx = 0;
        _cond = [[NSCondition alloc]init];
    }
    return (self);
}


-(void) limit:(int) limit{
    [_cond lock];
    PT_Log(@"output limit %p %d",_sessionid,limit);
    _limit = limit;
    [_cond signal];
    [_cond unlock];
}

-(void) kill{
    [_cond lock];
    _opened = 0;
    [_cond signal];
    [_cond unlock];
}


-(void) keepalive:(int64_t) now{
    [_cond lock];
    if(_send_timestamp-_ack_timestamp>3000){
        _rtt = 1000;
    }
    if(now-_send_timestamp>_rtt){// modify by robin at 2017/09/06
        int cur = _head;
        while(1){
            if(cur==_cur){
                break;
            }
            ltp_tunnel_outputstream_packet* dp = _packets[cur];
            if(dp!=NULL&&_peer.send!=nil){// victor
                // 20170911 by victor
                char data[24];
                ltp_int32_bytes(22, data);
                memcpy(&data[2], &dp.data.bytes[2], 22);
                if(_peer.ltaddr!=nil){// victor
               //     NSLog(@"%s %d %p %@",__FUNCTION__,ltp_bytes_int32(_peer.ltaddr.bytes),_peer,_peer.ltaddr);
                    ltp_ltaddr_bytes(_peer.ltaddr.bytes, &data[2]);// victor
                }
              //  NSLog(@"%s %d",__FUNCTION__,ltp_bytes_int32(&data[2]));
                data[19] = A_TUNNEL_STREAM_KEEPALIVE;
                @autoreleasepool {
                    [_peer send:[NSData dataWithBytes:data length:24]];// 20170911 by victor
                }
                
            }
            cur++;
            cur&=0xff;
        }
        _send_timestamp = now;
    }
    [_cond unlock];
}


-(int64_t) idle:(int64_t) now{
    return now-_ack_timestamp;
}


-(void) ack:(int) pidx{
    [_cond lock];
    @autoreleasepool {
        int idx = pidx&0xff;// 20170911 by victor
    ltp_tunnel_outputstream_packet* dp = _packets[idx];
    if(dp!=NULL&&dp.pidx == pidx){//20170911 by victor
        _ack_timestamp = ltp_sys_uptime();
        int64_t t = _ack_timestamp-dp.send_timestamp;
        _rtt = t>10?(int)t:10;
        _packets[idx]=NULL;
        if(idx==_head){
            while(_packets[_head]==NULL&&_length>0){
                _head++;
                _head&=0xff;
                _length--;
            }
            [_cond signal];
//            ltp_log(@"output signal");
        }
    }
    }
    [_cond unlock];
}

-(void) retransmit:(int) pidx state:(int) state{
    if (state == 0) {
        [_cond lock];
        int idx = pidx&0xff;// 20170911 by victor
        int off = idx-_head;
        if((off<_limit&&off>=0)||(off>=-255&&off<(-255+_limit))){
            ltp_tunnel_outputstream_packet* dp = _packets[idx];
            if(dp!=NULL&&dp.pidx == pidx){ //20170911 by victor
                _send_timestamp = ltp_sys_uptime();
                dp.count++;
                char bytes[dp.data.length];// victor
                memcpy(bytes, dp.data.bytes, dp.data.length);// victor
                if(_peer.ltaddr!=nil){
                ltp_ltaddr_bytes(_peer.ltaddr.bytes, &bytes[2]);// victor
                }
                @autoreleasepool {
                    [_peer send:[NSData dataWithBytes:bytes length:dp.data.length]];// victor
                }
                _send_timestamp = dp.send_timestamp;
                _ack_timestamp = dp.send_timestamp;
            }
        }
        [_cond unlock];
    } else if (state > 0) {
        [self ack:pidx];//20170911 by victor
    } else {
        [self kill];
    }
}


-(BOOL) isClosed{
    return !_opened&&!_length;// victor
}


-(void) close{
    [_cond lock];
    if(_opened){
    _opened=0;
    if(_length==_limit){
        [_cond wait];
    }
    if(_length<_limit){
        char temp[24];
        ltp_encode_bytes(temp,24, _peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_STREAM);
        memcpy(&temp[14],_sessionid,4);
        int idx = (_head+_length)&0xff;
        ltp_int32_bytes((int32_t)_pidx, &temp[20]); // 20170911 by  victor
        ltp_tunnel_outputstream_packet* dp = ltp_tunnel_outputstream_packet_create(temp, 24,(int32_t)_pidx);// 20170911 by  victor
        _packets[idx]=dp;
        _length++;
        _send_timestamp = ltp_sys_uptime();
        dp.send_timestamp = _send_timestamp;
        dp.count++;
        _cur++;
        _cur&=0xff;
        _pidx++;// 20170911 by  victor
        [_peer send:dp.data];
    }
    PT_Log(@"tunnel %d closed total send %lld",ltp_bytes_int32(_sessionid),_total_send);
    }
    [_cond unlock];
}


-(int) write:(NSData*) buf{
    if(!_opened){
        return -1;
    }
    const char* data = buf.bytes;
    NSUInteger len=buf.length;
    char temp[LT_DATAPACKET_SIZE];
    NSUInteger off=0,l=0,templen=0;
    @autoreleasepool {
    while(len&&_opened){
        if(templen==0){
            if(len>LT_DATAPACKET_PAYLOAD){
                l = LT_DATAPACKET_PAYLOAD;
            }else{
                l = len;
            }
            templen = l+24; // 20170911 by victor
            ltp_encode_bytes(temp,templen, _peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_TUNNEL, A_TUNNEL_STREAM);
             memcpy(&temp[24], &data[off], l); // 20170911 by victor
            off+=l;
            len-=l;
        }
        [_cond lock];
        if(_length>=_limit){
//            ltp_log(@"output wait %p",_sessionid);
            [_cond wait];
//            ltp_log(@"output wakeup");
        }
        if(_opened){
            if(_length<_limit){
                
                    int idx = (_head+_length)&0xff;
                    memcpy(&temp[14],_sessionid,4);
                    ltp_int32_bytes((int32_t)_pidx, &temp[20]);
                    ltp_tunnel_outputstream_packet* dp = ltp_tunnel_outputstream_packet_create(temp, templen,_pidx);// 20170911 by victor
                    _packets[idx]=dp;
                    _length++;
                    templen=0;
                    _send_timestamp = ltp_sys_uptime();
                    dp.send_timestamp = _send_timestamp;
                    dp.count++;
                    _cur++;
                    _cur&=0xff;
                    _pidx ++;// 20170911 by victor
                    _total_send+=l;
                    [_peer send:dp.data];
                
   //                            printf("%s before %lld\r\n",__FUNCTION__,out->send_timestamp);
            }
        }else{
            len=0;
            off=-1;
        }
        [_cond unlock];
        
    }
    }
    return (int)off;
}

@end
