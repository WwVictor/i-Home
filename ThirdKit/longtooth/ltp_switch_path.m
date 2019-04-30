
//  ltp_switch_path.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/24.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"

#define STATE_SWITCH_REGISGER       0
#define STATE_SWITCH_KEEPALIVE      1
#define STATE_SWITCH_KEEPALIVE_ACK  2

static NSMutableDictionary* SWITCH_MAP;
static NSLock* SWITCH_MAP_LOCK;
void ltp_switch_path_init(){
    SWITCH_MAP = [[NSMutableDictionary alloc]init];
    SWITCH_MAP_LOCK = [[NSLock alloc]init];
}
ltp_switch_path* _Nullable ltp_switch_path_create(int id,NSData* addr){
    @autoreleasepool {
    ltp_switch_path* sw = nil;
    [SWITCH_MAP_LOCK lock];
    sw = [SWITCH_MAP objectForKey:addr];
    if(sw==nil){
        sw = [[ltp_switch_path alloc]init];
        sw.id = id;
        sw.addr = addr;
        sw.state = 0;
        sw.state_count = 0;
        sw.state_timestamp = 0;
        [SWITCH_MAP setObject:sw forKey:addr];
    }
    [SWITCH_MAP_LOCK unlock];
//    ltp_log(@"%s %@ %@",__FUNCTION__,addr,sw);
    return sw;
    }
}

ltp_switch_path* _Nullable ltp_switch_path_get(NSData* _Nonnull addr){
    
    ltp_switch_path* sw = nil;
    [SWITCH_MAP_LOCK lock];
    sw = [SWITCH_MAP objectForKey:addr];
    [SWITCH_MAP_LOCK unlock];
//    ltp_log(@"%s %@ %@",__FUNCTION__,addr,sw);
    return sw;
}
@implementation ltp_switch_path
-(void) keepalive{
    size_t len = 20+32;
    char data[len];
    ltp_encode_bytes(data,len, ltp_local_ltaddr(),0, 0,T_SWITCH,A_SWITCH_KEEPALIVE);
    _state = STATE_SWITCH_KEEPALIVE;
    _state_timestamp = ltp_sys_uptime();
    @autoreleasepool {
      //  NSLog(@"%s %lld",__FUNCTION__,_state_timestamp);
    ltp_udp_sock_send(_addr, [NSData dataWithBytes:data length:len]);
    }
}
-(void) keepalive_ack{
    _state = STATE_SWITCH_KEEPALIVE_ACK;
    _state_timestamp = ltp_sys_uptime();
}
-(void) swregister:(int64_t) timestamp{
    size_t data_len = 20+32;
    char data[data_len];
    ltp_encode_bytes(data,data_len,ltp_local_ltaddr(),0, 0,T_SWITCH,A_SWITCH_SYN);
    char input[8+16];
    memset(input, 0, 24);
    ltp_int64_bytes(timestamp, input);

    memcpy(&data[8], input, 8);
    
    ltp_sha256(input,24, &data[20]);
    @autoreleasepool {
        PT_Log(@"%s %lld",__FUNCTION__,_state_timestamp);
    ltp_udp_sock_send(_addr, [NSData dataWithBytes:data length:data_len]);
    }
    
    _state=STATE_SWITCH_REGISGER;
    _state_timestamp = ltp_sys_uptime();
    
}
-(void) register_ack{
    [self keepalive_ack];
}
-(void) maintain{
    if(_addr!=nil){
        int64_t now = ltp_sys_uptime();
        int64_t interval = now-_state_timestamp;
//        printf("...%p %s %lld %d %d %d\r\n",path,__FUNCTION__,path->state_timestamp,path->state,path->ipaddr.in_addr,path->ipaddr.in_port);
        if (_state==STATE_SWITCH_REGISGER&&interval>2000) {
            [self swregister:now];
//            ltp_log(@"%s %lld %d %@ %p\r\n",__FUNCTION__,_state_timestamp,_state,_addr,self);
        }else if(_state==STATE_SWITCH_KEEPALIVE&&interval>3000){
            if(_state_count<5){
                _state_count++;
                
                [self keepalive];

            }else{
                _state_count = 0;
                [self swregister:now];
            }
        }else if(_state==STATE_SWITCH_KEEPALIVE_ACK&&interval>15000){
            [self keepalive];
        }
    }
}
@end
