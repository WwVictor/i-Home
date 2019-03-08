//
//  ltp_tcp_sock.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//
#include "ltp.h"
#include <netinet/tcp.h>
#include <netinet/in.h>

#import "ltp_tcp_sock.h"

#define STATE_ROUTER_KEEPALIVE_FAILURE -4
#define STATE_ROUTER_FAILURE -3
#define STATE_PASSPORT_FAILURE -2
#define STATE_LOCATE_FAILURE -1
#define STATE_LOCATE_INIT 0
#define STATE_LOCATE_CONNECT 1
#define STATE_LOCATE 2
#define STATE_PASSPORT_INIT 3
#define STATE_PASSPORT_CONNECT 4
#define STATE_PASSPORT 5
#define STATE_PASSPORT_WAIT 6
#define STATE_ROUTER_INIT 7
#define STATE_ROUTER_CONNECT 8
#define STATE_ROUTER_REGISTER 9
#define STATE_ROUTER_KEEPALIVE 10
#define STATE_ROUTER_KEEPALIVE_ACK 11

#define RDBUF_LIMIT LT_DATAPACKET_SIZE*8
#define DATABUF_LIMIT 1472

static char RDBUF[RDBUF_LIMIT];
static ssize_t RDBUF_LEN = 0;
static char DATABUF[DATABUF_LIMIT];

static NSString* LOCATER_HOST = @"passport.longtooth.io";
static int LOCATER_PORT = 0;
static NSString* PASSPORT_HOST = nil;
static int PASSPORT_PORT = 0;
static NSString* ROUTER_HOST = nil;
static int ROUTER_PORT = 0;
static int ROUTER_UDP_PORT = 0;
static NSData* P2P_IP_ADDR = nil;
static ltp_switch_path* SWITCH;
static int NET_ID = 0;
static LTPTcpSock* SOCK = nil;
static int STATE = 0;
static int STATE_COUNT = 0;
static int64_t STATE_TIMESTAMP = 0;

static int readCount = 0;
static int sendCount = 0;
static int decodeCount = 0;
static ltp_decode LTP_DECODE = nil;
static char LTPADDR[6];

void lt_register_host_set(NSString* _Nullable host, int port) {
    LOCATER_HOST = (host==nil||host.length==0)?@"passport.longtooth.io":host;
    LOCATER_PORT = port;
}
ltp_switch_path* ltp_local_switch_path(){
    return SWITCH;
}
const char* _Nonnull ltp_local_ltaddr(){
    return LTPADDR;
}

NSData* ltp_p2p_ip_addr(){
    return P2P_IP_ADDR;
}

void ltp_tcp_sock_init(){
    memset(LTPADDR,-1,6);
    SOCK = [[LTPTcpSock alloc]init];
    SWITCH = [[ltp_switch_path alloc]init];
}
void ltp_tcp_sock_state_set(int state){
  //  NSLog(@"%s %d",__FUNCTION__,state);
    STATE = state;
    STATE_TIMESTAMP = ltp_sys_uptime();
}
void ltp_tcp_sock_connect(NSString* host, NSInteger port){
    [SOCK connect:host port:port];
}
void ltp_tcp_sock_send(NSData* addr,NSData* data){
    
   // NSLog(@"%s %lu",__FUNCTION__,data.length);
    const char*ca = [data bytes];
    
    PT_Log(@"%s %lu (%d,%d)",__FUNCTION__,data.length,ca[18],ca[19]);
    [SOCK send:data to:addr];
}
void ltp_router_register(int64_t key) {
    ltp_tcp_sock_state_set(STATE_ROUTER_REGISTER);
    int len = 20 + 32;
    char data[len];
    ltp_encode_bytes(data,
                     len, LTPADDR,
                     NULL, 0,
                     T_ROUTER,
                     A_ROUTER_REGISTER_SYN);
    
    int input_len = 12 + 8 + 16;
    char input[input_len];
    memset(input, 0, input_len);
    ltp_ltid_bytes(ltp_local_ltid(), input);
    ltp_int64_bytes(key, &input[12]);
    
    
    memcpy(&data[8], &input[12], 8);
    ltp_sha256(input, input_len, &data[20]);
    @autoreleasepool {
    [SOCK send:[NSData dataWithBytes:data length:len] to:nil];
    }
}
bool ltp_router_registered(){
    return STATE>STATE_ROUTER_REGISTER;
}
void ltp_router_keepalive() {
    
    if(ltp_router_registered()){  // victor duan wang chong lian
//    NSLog(@"%s %lld\r\n",__FUNCTION__,ltp_sys_uptime());
    size_t len = 20+32;
    char data[len];
    char input[24];
    ltp_encode_bytes(data,len, LTPADDR,
                     NULL, 0,
                     T_ROUTER,
                     A_ROUTER_KEEPALIVE);
    memset(input,0,24);
    memcpy(&data[8], input,8);
    ltp_sha256(input,24, &data[20]);
    ltp_tcp_sock_state_set(STATE_ROUTER_KEEPALIVE);
    STATE_COUNT++;
    @autoreleasepool {
    [SOCK send:[NSData dataWithBytes:data length:len] to:nil];
    }
    }
}

void ltp_router_keepalive_ack() {
   
    STATE_COUNT=0;
    ltp_tcp_sock_state_set(STATE_ROUTER_KEEPALIVE_ACK);
    
//    NSLog(@"%s %lld\r\n",__FUNCTION__,ltp_sys_uptime());
  
}

void ltp_router_register_ack(int64_t r) {
    if (r > 0) {
        ltp_router_register(r);
        
    } else if (r < 0) {
        
    } else {
        ltp_router_keepalive_ack();
    }
    ltp_event_fire(EVENT_LONGTOOTH_ACTIVATED, lt_id(), NULL, NULL,NULL);
//    ltp_log(@"A_ROUTER_REGISTER_SYN_ACK %lld\r\n", r);
    
}
void ltp_locater_decode(ltp_sock_send sock_send,NSData* addr,const char* _Nonnull data,ssize_t length){
    
    char type = data[18];
    char action = data[19];
    int sessionid = ltp_bytes_int32(&data[14]);
    if (type == T_PASSPORT && action == A_PASSPORT_LOCATE_ACK) {
        NET_ID = ltp_bytes_int32(&data[10]);
        PASSPORT_PORT = sessionid;
        if (PASSPORT_PORT > 0) {
            size_t hostlen = length - 20;
            char host[hostlen+1];
            memset(host, 0, hostlen+1);
            memcpy(host,&data[20],hostlen);
            PASSPORT_HOST = [NSString stringWithCString:host encoding:NSUTF8StringEncoding];

            ltp_tcp_sock_state_set(STATE_PASSPORT_INIT);
//            ltp_log(@"A_PASSPORT_LOCATE_ACK passport ip address %@:%d,netid %d\r\n", PASSPORT_HOST, PASSPORT_PORT, NET_ID);
        } else {
            ltp_tcp_sock_state_set(STATE_PASSPORT_INIT);//#bug201706211008,replace STATE_PASSPORT_INIT by STATE_LOCATE_FAILURE
            STATE_TIMESTAMP = 0;
            ltp_event_fire(EVENT_LONGTOOTH_INVALID, lt_id(), NULL, NULL,NULL);
        }
    } else if (type == 0 && action == 0 && STATE == STATE_LOCATE_CONNECT) {
        int len = 20 + 32;
        char out_data[len];
        ltp_encode_bytes(out_data,len, NULL, NULL, 0, T_PASSPORT, A_PASSPORT_LOCATE);
        ltp_ltid_bytes(ltp_local_ltid(), &out_data[2]);
        memcpy(&out_data[14], &data[14], 4);
        @autoreleasepool {
        [SOCK send:[NSData dataWithBytes:&out_data length:len] to:nil];
        }
        ltp_tcp_sock_state_set(STATE_LOCATE);
    }
    

}

void ltp_passport_decode(ltp_sock_send sock_send,NSData* addr,const char* data,ssize_t len){
    char type = data[18];
    char action = data[19];
    int sessionid = ltp_bytes_int32(&data[14]);
    NSString* switch_host;
    int switch_port = 0;
    
    if (type == T_PASSPORT && action == A_PASSPORT_REGISTER_ACK) {
        if (sessionid > 0) {
            int rtport = ltp_bytes_int16(&data[6]);
            if (rtport != 0) {
               // int rtid = ltp_bytes_int32(&data[2]);
                ltp_bytes_ltaddr(&data[2], LTPADDR);
                ROUTER_PORT = ltp_bytes_int32(&data[20])&0xFFFF;
                ROUTER_UDP_PORT = ltp_bytes_int32(&data[24])&0xFFFF;
                int swid = ltp_bytes_int32(&data[28]);
                switch_port = ltp_bytes_int32(&data[32])&0xFFFF;
                
                int len = data[36]&0xFF;
                char host[16];
                memset(host, 0, 16);
                memcpy(host,&data[38],len);
                ROUTER_HOST = [NSString stringWithCString:host encoding:NSUTF8StringEncoding];
                
                memset(host, 0, 16);
                memcpy(host,&data[38+len],data[37]&0xFF);
                switch_host = [NSString stringWithCString:host encoding:NSUTF8StringEncoding];
                NSData* swaddr = ltp_proper_ipaddr(switch_host, switch_port);
                SWITCH = ltp_switch_path_create(swid, swaddr);
                ltp_tcp_sock_state_set(STATE_ROUTER_INIT);
                STATE_TIMESTAMP = 0;
//                ltp_event_fire(EVENT_LONGTOOTH_ACTIVATED, lt_id(), NULL, NULL,NULL);
            } else {
                STATE = STATE_PASSPORT_INIT;
            }
        } else if (sessionid == 0) {
//            ltp_log(@"STATE_PASSPORT_WAIT\r\n");
            ltp_tcp_sock_state_set(STATE_PASSPORT_WAIT);
        } else {
            ltp_tcp_sock_state_set(STATE_PASSPORT_FAILURE);
            ltp_event_fire(EVENT_LONGTOOTH_INVALID, lt_id(), NULL, NULL,NULL);
        }
    } else if (type == 0 && action == 0 && STATE == STATE_PASSPORT_CONNECT) {
        int len = 20 + 32 + 4 + 4;
        char out_data[len];
        ltp_encode_bytes(out_data,len, NULL, NULL, 0, T_PASSPORT, A_PASSPORT_REGISTER);
        ltp_ltid_bytes(ltp_local_ltid(), &out_data[2]);
        memcpy(&out_data[14], &data[14], 4);
        size_t shabuf_len = ltp_app_key_len() + 20;

        char sha256buf[1024+20];
        memcpy(sha256buf, out_data, 20);
        memcpy(&sha256buf[20], ltp_app_key(), ltp_app_key_len());
        ltp_sha256(sha256buf, shabuf_len, &out_data[20]);
        ltp_int32_bytes(NET_ID, &out_data[20 + 32]);
        @autoreleasepool {
        [SOCK send:[NSData dataWithBytes:out_data length:len] to:nil];
        }
        ltp_tcp_sock_state_set(STATE_PASSPORT);
    }
}
int flag = 0;
int64_t temp  = 0;
void ltp_tcp_sock_maintain(){
    
    while(true){ // victor
    int64_t now = ltp_sys_uptime();
        if (now - temp>60000) {
            temp=now;
            PT_Log(@"60 s 打印一次  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
                  __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
        }
    if(flag++ < 1){
      //  NSLog(@"%s state=%d timestamp=%lld",__FUNCTION__,STATE,STATE_TIMESTAMP);
    }
    switch (STATE) {
        case STATE_ROUTER_KEEPALIVE_FAILURE:
            break;
        case STATE_ROUTER_FAILURE:
            break;
        case STATE_PASSPORT_FAILURE:
            break;
        case STATE_LOCATE_FAILURE:
            break;
        case STATE_LOCATE_INIT:
            if(now-STATE_TIMESTAMP>1000){
//                NSLog(@"connect to longtooth locater\r\n");
                ltp_tcp_sock_connect(LOCATER_HOST,LOCATER_PORT);
                ltp_tcp_sock_state_set(STATE_LOCATE_CONNECT);
            }
            break;
        case STATE_LOCATE_CONNECT:
            if(now-STATE_TIMESTAMP>15000){
                [SOCK close];
//                PT_Log(@"STATE_LOCATE_CONNECT  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                      __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
            }
            break;
        case STATE_LOCATE://#bug201706211008 fail checkpoint
            break;
        case STATE_PASSPORT_INIT:
            if(now-STATE_TIMESTAMP>1000){
//                PT_Log(@"connect to longtooth passport\r\n");
                ltp_tcp_sock_connect(PASSPORT_HOST,PASSPORT_PORT);
                ltp_tcp_sock_state_set(STATE_PASSPORT_CONNECT);
            }
            break;
        case STATE_PASSPORT_CONNECT:
            if(now-STATE_TIMESTAMP>15000){
                [SOCK close];
//                PT_Log(@"STATE_PASSPORT_CONNECT  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                      __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
            }
            break;
        case STATE_PASSPORT:
            break;
        case STATE_PASSPORT_WAIT:
            //modify by victor at 20171123
            if (now-STATE_TIMESTAMP>10000) {
                [SOCK close];
//                PT_Log(@"STATE_PASSPORT_WAIT  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                       __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
            }
            break;
        case STATE_ROUTER_INIT:
            if(now-STATE_TIMESTAMP>1000){
//                PT_Log(@"connect to longtooth router\r\n");
                ltp_tcp_sock_connect(ROUTER_HOST,ROUTER_PORT);
                ltp_tcp_sock_state_set(STATE_ROUTER_CONNECT);
            }
            break;
        case STATE_ROUTER_CONNECT:
            if(now-STATE_TIMESTAMP>15000){
                
                [SOCK close];
//                PT_Log(@"STATE_ROUTER_CONNECT  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                      __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
                ltp_tcp_sock_state_set(STATE_ROUTER_INIT);
            }
            break;
        case STATE_ROUTER_REGISTER:
            // modify at 20170831 to reslove reconnect 
            if(now-STATE_TIMESTAMP>15000){
                
                [SOCK close];
//                PT_Log(@"STATE_ROUTER_REGISTER  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                      __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
                ltp_tcp_sock_state_set(STATE_ROUTER_INIT);
            }
            break;
        case STATE_ROUTER_KEEPALIVE:
            if (now-STATE_TIMESTAMP > 3000) {
                if (STATE_COUNT < 4) {
                    ltp_router_keepalive();
                } else {
                    [SOCK close];
//                    PT_Log(@"STATE_ROUTER_KEEPALIVE  %s  state=%d  timestamp=%lld,state count =  %d %d %d %d",
//                          __FUNCTION__,STATE,STATE_TIMESTAMP,STATE_COUNT,sendCount,readCount,decodeCount);
                }
            }
            break;
        case STATE_ROUTER_KEEPALIVE_ACK:
            if (now-STATE_TIMESTAMP>180000) {
                
                ltp_router_keepalive();
                
            }
            break;
    }
        [NSThread sleepForTimeInterval:0.1];
    }
}
@implementation LTPTcpSock
-(id) init{
    if(self=[super init]){
        lock = [[NSLock alloc]init];
    }
    return (self);
}
-(void) connect:(NSString *)host port:(NSUInteger)port{
    NSData* addr = nil;
    while(true){
        addr = ltp_proper_ipaddr(host,port);
//        ltp_log(@"Attempting connection to %@:%d", host,port);
        sock = [[LTGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [sock performBlock:^{
            int fd = [sock socketFD];
            int on = 1;
            if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (char*)&on, sizeof(on)) == -1) {
                /* handle error */
                PT_Log(@"setsockopt errno=%d",errno);
                
            }
        }];
        NSError *err = nil;
        [sock connectToHost:host onPort:port withTimeout:10 error:&err];
//        ltp_log(@"failed.:%@",[err description]);
        if(err){
            PT_Log(@"failed.:%@",[err description]);
            [NSThread sleepForTimeInterval:3];
        }else{
            break;
        }
    
    }
}
-(void) close{
    //TODO
    [sock disconnect];
}
#pragma mark -LTGCDAsyncSocket Delegate
- (void)socket:(LTGCDAsyncSocket *)socket didConnectToHost:(NSString *)ahost port:(UInt16)aport
{
    PT_Log(@"--------%s,%d",__FUNCTION__,STATE);
    switch (STATE) {
        case STATE_LOCATE_CONNECT:
            LTP_DECODE = ltp_locater_decode;
            break;
        case STATE_PASSPORT_CONNECT:
            LTP_DECODE = ltp_passport_decode;
            break;
        case STATE_ROUTER_CONNECT:
            LTP_DECODE = ltp_main_decode;
            ltp_router_register(ltp_sys_uptime());
            break;
    }
    [socket readDataWithTimeout:-1 tag:200];
    
}

- (void)socket:(LTGCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;{
    
//    PT_Log(@"--------%s,消息发送成功。。。",__FUNCTION__);
}



- (void)socketDidDisconnect:(LTGCDAsyncSocket *)sock withError:(NSError *)err
{
     PT_Log(@"-------%s,%d",__FUNCTION__,STATE);
    switch (STATE) {
        case STATE_LOCATE_CONNECT:
            ltp_tcp_sock_state_set(STATE_LOCATE_INIT);
            break;//state_locate fail checkpoint
        case STATE_PASSPORT_CONNECT:
            ltp_tcp_sock_state_set(STATE_PASSPORT_INIT);
            break;
        case STATE_ROUTER_CONNECT:
        case STATE_PASSPORT_WAIT:
            ltp_tcp_sock_state_set(STATE_PASSPORT_INIT);//modify by victor at 20171123
        case STATE_ROUTER_KEEPALIVE:
        case STATE_ROUTER_KEEPALIVE_ACK:
            
            ltp_tcp_sock_state_set(STATE_ROUTER_INIT);
            
            // modify at 20170831 to reslove udp restart
            ltp_udp_sock_close();
            ltp_udp_sock_restart();
     
            break;
            
    }
}

- (void)socket:(LTGCDAsyncSocket*)socket didReadData:(NSData*)data withTag:(long)tag{
    
    readCount += data.length;
    NSUInteger rev_len = data.length;
    const char* revbuf=[data bytes];
    PT_Log(@"%s %d %d %d",__FUNCTION__,rev_len,revbuf[18],revbuf[19]);
    int rev_off = 0;
    while (rev_len > 0) {
        size_t len = RDBUF_LIMIT - RDBUF_LEN;
        if(rev_len<len){
            len = rev_len;
        }
        
        memcpy(&RDBUF[RDBUF_LEN],&revbuf[rev_off],len);
        rev_off+=len;
        rev_len-=len;
        RDBUF_LEN+=len;

        int offset = 0;
        while (RDBUF_LEN > 19) {
            len = (ltp_bytes_int32(&RDBUF[offset]) & 0xffff) + 2;
            if (len < 1473) {
                if(RDBUF_LEN>=len){
                    memcpy(DATABUF, &RDBUF[offset], len);
                    offset += len;
                    RDBUF_LEN-=len;
                    //NSLog(@"%s %d %d %d",__FUNCTION__,len,DATABUF[18],DATABUF[19]);
                    decodeCount += len;
                    LTP_DECODE(ltp_tcp_sock_send, nil, DATABUF, len);
                   //NSLog(@"%s %d %d %d end",__FUNCTION__,len,DATABUF[18],DATABUF[19]);
                    if(RDBUF_LEN<20){
                        memmove(RDBUF, &RDBUF[offset], RDBUF_LEN);
                        break;
                    }
                } else {
                    memmove(RDBUF, &RDBUF[offset], RDBUF_LEN);
                    break;
                }
            } else {
                RDBUF_LEN = 0;
            }
        }
    }
    [socket readDataWithTimeout:-1 tag:200];
}


-(void) send:(NSData *)data to:(NSData *)addr{
    
  
    const char *temp = data.bytes;
    char type = temp[18];
    char action = temp[19];
    if (type == 103 && action >= 1 && action <=8 ) {
        PT_Log(@" %s type=%d,action=%d \r\n",__FUNCTION__, type,action);
    }
    sendCount+=data.length;
    [lock lock];
    [sock writeData:data withTimeout:-1 tag:200];
    [lock unlock];
}


@end
