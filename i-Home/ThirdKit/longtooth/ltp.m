//
//  ltp.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/25.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "ltp.h"
#import "LTGCDAsyncSocket.h"

static char LTID[12];
NSString* LTID_STR = @"0.0.0.0.0.0";
static char APPKEY[129];
static size_t APPKEY_LEN = 0;
static NSLock* LOCK;
static BOOL LT_STARTED = false;
static NSMutableDictionary* SRV_MAP;
const char* ltp_local_ltid(){
    return LTID;
}


NSString* lt_id(){
    return LTID_STR;
}

size_t ltp_app_key_len(){
    return APPKEY_LEN;
}
const char* ltp_app_key(){
    return APPKEY;
}

void ltp_encode_bytes(char* bytes,size_t len, const char* to, const char* from, int sessionid, char type, char action) {
    ltp_int32_bytes((int)len - 2, bytes);
    if (to != NULL) {
        memcpy(&bytes[2],to,6);
    }
    if (from != NULL) {
        memcpy(&bytes[8],from,6);
    }
    ltp_int32_bytes(sessionid, &bytes[14]);
    bytes[18] = type;
    bytes[19] = action;
}

void ltp_init(){
    
    LOCK = [[NSLock alloc]init];
    SRV_MAP = [[NSMutableDictionary alloc]init];
}
void lt_service_add(NSString* srv_name,id<LongToothServiceRequestHandler> srv){
    [LOCK lock];
    [SRV_MAP setObject:srv forKey:srv_name];
    [LOCK unlock];
}

id<LongToothServiceRequestHandler> ltp_service_get(NSString* key){
    id<LongToothServiceRequestHandler> handler = nil;
    [LOCK lock];
    handler = SRV_MAP[key];
    [LOCK unlock];
    return handler;
}

int lt_start(int64_t devid,int appid,NSString* _Nonnull appkey,id<LongToothEventHandler> _Nonnull handler){
    int r = 1;
    [LOCK lock];
    if(!LT_STARTED){
        NSString* uuid = ltp_hardware_uuid();
        if(uuid!=nil){
            const char* buf = [uuid cStringUsingEncoding:NSUTF8StringEncoding];
            char bytes[CC_MD5_DIGEST_LENGTH];
            CC_MD5( buf, (unsigned int)uuid.length,(unsigned char*)bytes );
            ltp_ltid_create(((appid&0xFFFLL)<<36)|(devid&0xFFFFFFFFFLL), ltp_bytes_int64(bytes) & 0xFFFFFFFFFFFFLL, LTID);
            char ltid_str[48];
            memset(ltid_str, 0, 48);
            ltp_ltid_str(LTID, ltid_str);
            LTID_STR = [NSString stringWithCString:ltid_str encoding:NSUTF8StringEncoding];
//            NSLog(@"...........ltid ----- %s",ltid_str);
            const char* appkeybuf = [appkey cStringUsingEncoding:NSUTF8StringEncoding];
            APPKEY_LEN = ltp_hexstr_bytes(appkeybuf,APPKEY);
            ltp_log(@"%@ %@",uuid,LTID_STR);
            ltp_event_init(handler);
            ltp_switch_path_init();
            ltp_peer_init();
            ltp_tunnel_init();
            ltp_multicast_sock_init();
            ltp_udp_sock_init();
            ltp_tcp_sock_init();

            LT_STARTED = true;
            ltp_event_fire(EVENT_LONGTOOTH_STARTED, LTID_STR, nil, nil, nil);
        }else{
            r = -2;
        }
    }else{
        r = -1;
    }
    [LOCK unlock];
    return r;
}


@implementation ltp_lan_message_handler
int32_t _hash;
-(id) initWithMessage:(NSData *)msg hash:(int32_t) hash{
    if(self=[super init]){
        message = msg;
        _hash = hash;
    }
    return (self);
}
-(NSObject*) handle:(NSObject *)arg{
    
    NSData* key = (NSData *)arg;
    
    //  NSData－> Byte数组
    Byte *testByte = (Byte *)[key bytes];
    int hash = lt_hash(testByte,[key length]);
    if(key!=nil&&hash==_hash){
        return message;
    }
    return nil;
}

@end

static char type;
static char action;

static int idx = 0;
static char out_data[LT_DATAPACKET_SIZE];
static size_t out_data_len;
static ltp_tunnel* tunnel;
static char data_type = 0;
static char lttkey[10];
static char r_ltaddr[6];
static char l_ltid[12];
static char r_ltid[12];


static ltp_peer* peer;
static ltp_switch_path* sw;
static char srv_name[256];
static size_t srv_name_len=0;
static int64_t timestamp;
void ltp_main_decode(ltp_sock_send sock_send, NSData* addr, const char* rktemp, ssize_t length) {
    
    type = rktemp[18];
    action = rktemp[19];
    NSString* ipaddr = [[NSString alloc]init];
    uint16_t ipport;
    [LTGCDAsyncSocket getHost:&ipaddr port:&ipport fromAddress:addr];
    if (type == 103 && action >= 1 && action <=8 ) {
    PT_Log(@"%s,receive data, type=%d,action=%d,length=%zd addr=%@ port=%d\r\n",__FUNCTION__, rktemp[18],rktemp[19],length,ipaddr,ipport);
    }
    
//    if ( ipaddr.length != 0) {
//        if ([[ipaddr substringToIndex:3] isEqualToString:@"192."] || [[ipaddr substringToIndex:2] isEqualToString:@"10."]) {
//            peer.lan_addr = addr;
//        }
//    }

    
    @autoreleasepool {
    switch (type) {
        case T_TUNNEL:
            memcpy(lttkey, &rktemp[8], 10);
            ltp_bytes_ltaddr(lttkey, r_ltaddr);
            tunnel = ltp_tunnel_get(lttkey);
            
            NSLog(@" tunnel  之前  %s,%p,%s-------type=%d---action=%d--",__FUNCTION__,tunnel,lttkey,rktemp[18],rktemp[19]);
            for (int i = 0 ; i < 10; i++) {
                NSLog(@"%d：",lttkey[i]);
            }
            NSLog(@"\n");

            if (tunnel == NULL) {
                int rtid = ltp_bytes_int32(r_ltaddr);
                int rtport = ltp_bytes_int16(&r_ltaddr[4]);
                if(rtid != -1 && rtport != 65535){
                    memset(r_ltaddr,-1,6);//modify by victor 18/1102,-1 change to 0
                    ltp_ltaddr_bytes(r_ltaddr, lttkey);
                    tunnel = ltp_tunnel_get(lttkey);
                    
                    NSLog(@" tunnel  之后  %s,%p,%s-------type=%d---action=%d--",__FUNCTION__,tunnel,lttkey,rktemp[18],rktemp[19]);
                    for (int i = 0 ; i < 10; i++) {
                        NSLog(@"%d：",lttkey[i]);
                    }
                    NSLog(@"\n");
                }
            }else{
   
            }
            
            /**修改于20181120by Victor */
            if (tunnel == NULL) {
                int rtid = ltp_bytes_int32(r_ltaddr);
                int rtport = ltp_bytes_int16(&r_ltaddr[4]);
                if (rtid == -1 && rtport == 65535) {
                    memset(r_ltaddr,0,6);
                    ltp_ltaddr_bytes(r_ltaddr, lttkey);
                    tunnel = ltp_tunnel_get(lttkey);
                }
            }
            
            PT_Log(@"tunnel.key ----%@,tunnel.service %@",tunnel.key,tunnel.srv_name);
            
            switch (action) {
                case A_TUNNEL_STREAM:
                    PT_Log(@"A_TUNNEL_STREAM idx length %zd\r\n",rktemp[20]);
                    if (tunnel != NULL && tunnel.input != NULL) {
                        idx = [tunnel.input input:rktemp length:length];
                        if(idx>-1){
//                            ltp_log(@"A_TUNNEL_STREAM idx %d\r\n",idx);
                            out_data_len = 24;
                            ltp_int32_bytes(22, out_data);
                            memcpy(&out_data[2], &rktemp[8], 6);
                            memcpy(&out_data[8], &rktemp[2], 6);
                            memcpy(&out_data[14], &rktemp[14],4);
                            out_data[18]=T_TUNNEL;
                            out_data[19]=A_TUNNEL_STREAM_ACK;
                            ltp_int32_bytes(idx, &out_data[20]);
                            sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
                        }
                        
                    } else {
                        out_data_len = 25;//20170911 by victor  out_data_len = 22;
                        ltp_int32_bytes(23, out_data); //20170911 by victor
                        memcpy(&out_data[2], &rktemp[8], 6);
                        memcpy(&out_data[8], &rktemp[2], 6);
                        memcpy(&out_data[14], &rktemp[14], 4);
                        out_data[18] = T_TUNNEL;
                        out_data[19] = A_TUNNEL_STREAM_KEEPALIVE_ACK;
                        memcpy(&out_data[20], &rktemp[20], 4);//20170911 by victor
                        out_data[24] = -1;
                        sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
                    }
                    break;
                case A_TUNNEL_STREAM_ACK:
                    if (tunnel != NULL && tunnel.output != NULL) {
                        idx = ltp_bytes_int32(&rktemp[20]);//20170911 by victor
                        [tunnel.output ack:idx];
                    }
                    break;
                case A_TUNNEL_STREAM_KEEPALIVE:
                    if (tunnel != NULL && tunnel.input != NULL) {
                        ltp_int32_bytes(23, out_data); // 20170911 by victor
                        memcpy(&out_data[2], &rktemp[8], 6);
                        memcpy(&out_data[8], &rktemp[2], 6);
                        memcpy(&out_data[14], &rktemp[14], 4);
                        out_data[18] = T_TUNNEL;
                        out_data[19] = A_TUNNEL_STREAM_KEEPALIVE_ACK;
//                        20170911 by victor
                        memcpy(&out_data[20], &rktemp[20], 4);
                        out_data[24] = 0;
                        idx = ltp_bytes_int32(&rktemp[20]);

                        if([tunnel.input keepalive:idx]){
                                    out_data[24] = 1;
                            }
                        sock_send(addr,[NSData dataWithBytes:out_data length:25]);
                    }
                    break;
                case A_TUNNEL_STREAM_KEEPALIVE_ACK:
                    if (tunnel != NULL && tunnel.output != NULL) {
                         [tunnel.output retransmit:ltp_bytes_int32(&rktemp[20]) state:rktemp[24]];// 20170911 by victor
                    }
                    break;
                case A_TUNNEL_DATAGRAM:
                    if(tunnel !=NULL&&tunnel.inputd!=NULL){
                        [tunnel.inputd input:rktemp length:length];
                    }
                    break;
                case A_TUNNEL_REQUEST_SYN:
                    ltp_log(@"A_TUNNEL_REQUEST_SYN\r\n");
                    out_data_len =20 + 1 + 4 + 4 + 16 + 4 + 4;
                    memset(out_data,0,out_data_len);
                    ltp_int32_bytes((int32_t)out_data_len - 2, out_data);
                    memcpy(&out_data[2], &rktemp[8], 6);
                    memcpy(&out_data[8], &rktemp[2], 6);
                    memcpy(&out_data[14], &rktemp[14], 4);
                    out_data[18] = T_TUNNEL;
                    out_data[19] = A_TUNNEL_REQUEST_SYN_ACK;
                    ltp_bytes_ltid(&rktemp[28], l_ltid);
                    if (ltp_bytes_equals(LTID, l_ltid, 12)) {
                        data_type = rktemp[20];
                        ltp_bytes_ltid(&rktemp[40],r_ltid);
                        srv_name_len = rktemp[64] & 0xff;
                        srv_name[srv_name_len] = 0;
                        memcpy(srv_name, &rktemp[65], srv_name_len);
                        NSString* srv_key = [NSString stringWithUTF8String:srv_name];
                        id<LongToothServiceRequestHandler> handler = ltp_service_get(srv_key);
                        if (handler != NULL) {
                            if (tunnel==NULL) {
                                sw = ltp_local_switch_path();
                                if(sw.addr){
//                                    ltp_log(@"A_ROUTER_RELAY sw %d %@\r\n",sw.state,sw.addr);
                                    char router_relay[52];
                                    memset(router_relay, 0, 52);
                                    ltp_int32_bytes(50, router_relay);
                                    memcpy(&router_relay[2], &rktemp[2], 50);
                                    ltp_int32_bytes(ltp_local_switch_path().id, &router_relay[14]);
                                    router_relay[18] = T_ROUTER;
                                    router_relay[19] = A_ROUTER_RELAY;
                                        NSData* d_router_relay = [NSData dataWithBytes:router_relay length:52];
                                        ltp_tcp_sock_send(nil, d_router_relay);
                                }
                                
                                sw = NULL;
                                peer = ltp_peer_create(r_ltid,sock_send);
                                ltp_bytes_ltaddr(&rktemp[8],r_ltaddr);
                                peer.ltaddr = [NSData dataWithBytes:r_ltaddr length:6];
                                NSLog(@"A_TUNNEL_REQUEST_SYN  %s ",r_ltaddr);
                                
                                tunnel = ltp_tunnel_create(peer,
                                                           A_TUNNEL_RESPONSE_SYN,
                                                           [NSData dataWithBytes:lttkey length:10],
                                                           srv_key,
                                                           [NSData dataWithBytes:&rktemp[65+srv_name_len] length:length - srv_name_len - 65],
                                                           data_type,
                                                           handler,
                                                           nil,
                                                           nil);
                                
                                int sw_port = ltp_bytes_int32(&rktemp[56])&0xFFFF;
                                if (sw_port) {
                                    int sw_addr = ltp_bytes_int32(&rktemp[52]);
                                    int d = (sw_addr>>24)&0xff;
                                    int c = (sw_addr>>16)&0xff;
                                    int b = (sw_addr>>8)&0xff;
                                    int a = sw_addr&0xff;
                                    NSString* sw_host = [NSString stringWithFormat: @"%d.%d.%d.%d", a,b,c,d];
                                    sw = ltp_switch_path_create(0, ltp_proper_ipaddr(sw_host, sw_port));
                                    [sw swregister:ltp_sys_clock()]; // Victor
                                    peer.switch_path = sw;
                                }
                                tunnel.in_closed = false;
                                if (data_type == LT_STREAM) {
                                    tunnel.input = ltp_tunnel_inputstream_create(&rktemp[14]);
                                    tunnel.ind_closed = true;
                                } else if (data_type == LT_DATAGRAM) {
                                    tunnel.inputd = ltp_tunnel_inputdatagram_create();
                                    tunnel.ind_closed = false;
                                    tunnel.in_closed = true;
                                } else {
                                    tunnel.ind_closed = true;
                                    tunnel.in_closed = true;
                                }
                                out_data[20] = 1;
                                PT_Log(@"A_TUNNEL_REQUEST_SYN %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);

                                [NSThread detachNewThreadSelector:@selector(request_thread) toTarget:tunnel withObject:nil];
                                if (sw != NULL) {
                                    sw = ltp_local_switch_path();
                                     if(sw!=NULL&&sw.addr!=nil){ // victor
                                    const char* addrbytes = sw.addr.bytes;
                                    memcpy(&out_data[21],&addrbytes[4],4);
                                    int in_port = ltp_bytes_int16(&addrbytes[2]);
                                 //   ltp_log(@"sw port %d",in_port);
//                                    ltp_int16_bytes((addrbytes[2]<<8&0xffff)|(addrbytes[3]&0xffff),&out_data[25]);
                                    ltp_int16_bytes(ntohs(in_port),&out_data[25]);
                                    NSData* p2pipaddr = ltp_p2p_ip_addr();
                                    if (p2pipaddr) {
                                        addrbytes = p2pipaddr.bytes;
                                        memcpy(&out_data[21 + 4 + 4 + 16],&addrbytes[4],4);
                                        ltp_int32_bytes((addrbytes[2]<<8&0xffff)|(addrbytes[3]&0xffff),&out_data[21 + 4 + 4 + 16 + 4]);
                                    }
                                    }
                                }
                                [peer lan_maintain];
                            }else{
                                out_data[20]=0;
                            }
                        } else {
                            out_data[20] = -1;
                        }
                        
                    } else {
                        out_data[20] = -2;
                    }
                    sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
                    PT_Log(@"sock_send A_TUNNEL_REQUEST_SYN_ACK,,,,,,,\r\n");
                    
                    for (int i = 0; i < out_data_len; i++) {
                        printf("%d ",out_data[i]);
                    }
                    printf("\n");
                    break;
                case A_TUNNEL_REQUEST_SYN_ACK:
                    PT_Log(@"sock_receive A_TUNNEL_REQUEST_SYN_ACK\r\n");
                    if (tunnel != NULL) {
                        peer = tunnel.peer;
                        switch (rktemp[20]) {
                            case 1:
                                sw = ltp_local_switch_path();
                                memset(out_data,0,52);
                                out_data_len = 52;
                                ltp_encode_bytes(out_data,out_data_len, ltp_local_ltaddr(), peer.ltaddr.bytes, sw.id, T_ROUTER, A_ROUTER_RELAY);
                                ltp_ltid_bytes(ltp_local_ltid(), &out_data[28]);
                                ltp_ltid_bytes(peer.ltid.bytes, &out_data[40]);
                                ltp_tcp_sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
//                                ltp_log(@"A_ROUTER_RELAY sw %d %@\r\n",sw.state,sw.addr);
                                int sw_port = ltp_bytes_int32(&rktemp[21 + 4])&0xFFFF;
                                if (sw_port) {
                                    int sw_addr = ltp_bytes_int32(&rktemp[21]);
                                    int d = (sw_addr>>24)&0xff;
                                    int c = (sw_addr>>16)&0xff;
                                    int b = (sw_addr>>8)&0xff;
                                    int a = sw_addr&0xff;
                                    NSString* sw_host = [NSString stringWithFormat: @"%d.%d.%d.%d", a,b,c,d];
                                    sw = ltp_switch_path_create(0, ltp_proper_ipaddr(sw_host, sw_port));
                                    peer.switch_path = sw;
                                }
                                PT_Log(@"A_TUNNEL_REQUEST_SYN_ACK %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);

                                [tunnel request_sync_ack];
                                break;
                            case -1:
                                ltp_event_fire(EVENT_SERVICE_NOT_EXIST, ltp_ltid_nsstring(tunnel.peer.ltid), tunnel.srv_name, NULL,tunnel.attachment);
                                tunnel.fined = 1;
                                tunnel.fin_timestamp = ltp_sys_uptime();
                                [tunnel fin_ack];
                                
                                break;
                            case -2:
                                //TODO wrong target ltid, need lookup ltid ltaddr again
                                [peer lookup];// victor
                                break;
                                
                        }
                    }
                    break;
                case A_TUNNEL_RESPONSE_SYN:
                    data_type = rktemp[20];
                    out_data_len = 20 + 1 + 4 + 4;
                    ltp_int32_bytes((int32_t)out_data_len - 2, out_data);
                    memcpy(&out_data[2], &rktemp[8], 6);
                    memcpy(&out_data[8], &rktemp[2], 6);
                    memcpy(&out_data[14], &rktemp[14], 4);
                    out_data[18] = T_TUNNEL;
                    out_data[19] = A_TUNNEL_RESPONSE_SYN_ACK;
                    
                     PT_Log(@"A_TUNNEL_RESPONSE_SYN %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);
                    
//                    NSLog(@" tunnel  .........  %s,%p,%s-------type=%d---action=%d--",__FUNCTION__,tunnel,lttkey,rktemp[18],rktemp[19]);
//                    for (int i = 0 ; i < 10; i++) {
//                        NSLog(@"%d：",lttkey[i]);
//                    }
//                    NSLog(@"\n");
    
                    if (tunnel != NULL && tunnel.resp_data_type < LT_ARGUMENTS) { // victor
                        tunnel.resp_data_type = data_type;
                        tunnel.resp_args = [NSData dataWithBytes:&rktemp[20 + 1 + 2] length:ltp_bytes_int16(&rktemp[20 + 1]) & 0xffff];

                        if (data_type == LT_STREAM) {
                            tunnel.input = ltp_tunnel_inputstream_create(&rktemp[14]);
                            tunnel.ind_closed = 1;
                        } else if (data_type == LT_DATAGRAM) {
                            tunnel.inputd = ltp_tunnel_inputdatagram_create();
                            tunnel.in_closed = 1;
                        } else {
                            tunnel.ind_closed = 1;
                            tunnel.in_closed = 1;
                        }
                        PT_Log(@"A_TUNNEL_RESPONSE_SYN %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);
                        [NSThread detachNewThreadSelector:@selector(response_thread) toTarget:tunnel withObject:nil];
//                        PT_Log(@"A_TUNNEL_RESPONSE_SYN %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);
                    }
                    sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
//                    NSLog(@"A_TUNNEL_RESPONSE_SYN_ACK %d",ltp_bytes_int32(&rktemp[14]));
                    break;
                case A_TUNNEL_RESPONSE_SYN_ACK:
                    PT_Log(@"A_TUNNEL_RESPONSE_SYN_ACK %@,%p,%p,%d,%d",tunnel.srv_name,tunnel,tunnel.attachment,tunnel.resp_data_type,data_type);

                    if (tunnel != NULL) {
                        [tunnel response_sync_ack];
                    }
                 //   ltp_log(@"A_TUNNEL_RESPONSE_SYN_ACK\r\n");
                    break;
                case A_TUNNEL_KEEPALIVE:
                    out_data_len = 20;
                    ltp_int32_bytes((int32_t)out_data_len - 2, out_data);
                    memcpy(&out_data[2], &rktemp[8], 6);
                    memcpy(&out_data[8], &rktemp[2], 6);
                    memcpy(&out_data[14], &rktemp[14], 4);
                    out_data[18] = T_TUNNEL;
                    if (tunnel != NULL) {
                        [tunnel keepalive_ack];
                        out_data_len = 20;
                        out_data[19] = A_TUNNEL_KEEPALIVE_ACK;
                  //      ltp_log(@"A_TUNNEL_KEEPALIVE\r\n");
                    } else {
                        out_data[19] = A_TUNNEL_FIN_ACK;
                    }
                    sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
                    break;
                case A_TUNNEL_KEEPALIVE_ACK:
                    if (tunnel != NULL) {
                        [tunnel keepalive_ack];
                    //    ltp_log(@"A_TUNNEL_KEEPALIVE_ACK\r\n");
                    }
                    break;
                case A_TUNNEL_FIN:
                    if (tunnel != NULL) {
                        tunnel.fined = 1;
                        tunnel.fin_acked = 1;
//                        NSLog(@"fin_ack A_TUNNEL_FIN %@ %@",tunnel.key,tunnel.srv_name);
                    }
                    out_data_len = 20;
                    ltp_int32_bytes((int32_t)out_data_len - 2, out_data);
                    memcpy(&out_data[2], &rktemp[8], 6);
                    memcpy(&out_data[8], &rktemp[2], 6);
                    memcpy(&out_data[14], &rktemp[14], 4);
                    out_data[18] = T_TUNNEL;
                    out_data[19] = A_TUNNEL_FIN_ACK;
                    sock_send(addr,[NSData dataWithBytes:out_data length:out_data_len]);
//                    ltp_log(@"A_TUNNEL_FIN\r\n");
                    break;
                case A_TUNNEL_FIN_ACK:
                    if (tunnel != NULL) {
//                        ltp_tunnel_fin_ack(tunnel);
//                        NSLog(@"A_TUNNEL_FIN_ACK %@",tunnel.key);
                        [tunnel fin_ack];
                    }
                //    ltp_log(@"A_TUNNEL_FIN_ACK\r\n");
                    break;
                default:
                    break;
            }
            break;
        case T_ROUTER:
            switch (action) {
                case A_ROUTER_REGISTER_SYN_ACK:
                    ltp_router_register_ack(ltp_bytes_int64(&rktemp[8]));
                    break;
                case A_ROUTER_KEEPALIVE_ACK:
                    ltp_router_keepalive_ack();
                 //printf("A_ROUTER_KEEPALIVE_ACK %lld\r\n",ltp_sys_uptime());
                    break;
                case A_ROUTER_LOOKUP_ACK:
                    
                    ltp_bytes_ltid(&rktemp[2],r_ltid);
                    peer = ltp_peer_get(r_ltid);
                    char ltid_str[48];
                    memset(ltid_str,0,48);
                    ltp_ltid_str(r_ltid, ltid_str);
//                    printf("A_ROUTER_LOOKUP_ACK %s\r\n",ltid_str);
                    
                    if (peer != NULL) {
                        ltp_bytes_ltaddr(&rktemp[20],r_ltaddr);
                        [peer.cond lock];
                        peer.ltaddr = [NSData dataWithBytes:r_ltaddr length:6];
                        peer.ltaddr_find_timestamp = ltp_sys_uptime();
                        [peer.cond signal];
                        [peer.cond unlock];
                        
//                        printf("A_ROUTER_LOOKUP_ACK %s %d:%d\r\n",ltid_str,peer.ltaddr.rtid,peer.ltaddr.rtport);
                    //    ltp_log(@"A_ROUTER_LOOKUP_ACK %s %p %@\r\n",ltid_str,peer,peer.ltaddr);
                    }
                    
                    break;
            }
            break;
        case T_SWITCH:
            sw = ltp_switch_path_get(addr);
            if (sw != NULL) {
                switch (action) {
                    case A_SWITCH_SYN_ACK:
                        timestamp =ltp_bytes_int64(&rktemp[8]);
                        if (timestamp > 0) {
                            [sw swregister:timestamp+1];// victor
                        } else if (timestamp < 0) {
                            
                        } else {
                            [sw register_ack];
                        }
//                        NSLog(@"A_SWITCH_SYN_ACK %p %lld",sw,timestamp);
                        break;
                    case A_SWITCH_KEEPALIVE_ACK:
                        [sw keepalive_ack];
//                        NSLog(@"A_SWITCH_KEEPALIVE_ACK %p",sw);
                        break;
                }
            }
            break;
        case T_LAN:
//            PT_Log(@"T_LAN");
            if (action == A_LAN_MESSAGE) {
                ltp_bytes_ltid(&rktemp[2], r_ltid);
                if (!ltp_bytes_equals(LTID, r_ltid, 12)) {
                    out_data_len = length-20;
                    memcpy(out_data, &rktemp[20], out_data_len);
                    @autoreleasepool {
                    
                        
                        /**新加广播之后拿不到ID的问题*/
                        peer = ltp_peer_get(r_ltid);
                        if (peer == NULL) {
                            peer = ltp_peer_create(r_ltid,sock_send);
                        }
                        [peer lan_keepalive_ack:addr];
                        
                        
                        int32_t hash = ltp_bytes_int32(&rktemp[14]);
                        NSString* ltid = [NSString stringWithCString:r_ltid encoding:NSUTF8StringEncoding];
                        NSData* msg = [NSData dataWithBytes:out_data length:out_data_len];
                        ltp_lan_message_handler* att = [[ltp_lan_message_handler alloc]initWithMessage:msg hash:hash];
                        ltp_event_fire(EVENT_LONGTOOTH_BROADCAST,ltid, NULL,NULL, att);
                    }
                }
                break;
            }
            if(ltp_peer_lan_disabled()){
                break;
            }
            ltp_bytes_ltid(&rktemp[20],l_ltid);
            if (ltp_bytes_equals(LTID, l_ltid, 12)) {
                ltp_bytes_ltid(&rktemp[20 + 12],r_ltid);
                NSLog(@"local %@ remote %@",ltp_ltid_nsstring([NSData dataWithBytes:LTID length:12]),ltp_ltid_nsstring([NSData dataWithBytes:r_ltid length:12]));

                switch (action) {
                    case A_LAN_WHOIS:
                        out_data_len = 20+12+12;
                        ltp_encode_bytes(out_data, out_data_len, NULL, NULL, 0, T_LAN, A_LAN_KEEPALIVE);
                        memcpy(&out_data[20], &rktemp[20 + 12], 12);
                        memcpy(&out_data[20 + 12], &rktemp[20], 12);
                        ltp_udp_sock_send(addr, [NSData dataWithBytes:out_data length:out_data_len]);
                        NSLog(@"A_LAN_WHOIS\r\n");
                        break;
                    case A_LAN_KEEPALIVE:
                        peer = ltp_peer_get(r_ltid);
                        if (peer == NULL) {
                            peer = ltp_peer_create(r_ltid,sock_send);
                        }
                        [peer lan_keepalive_ack:addr];
                        out_data_len = 20+12+12;
                        ltp_encode_bytes(out_data, out_data_len, NULL, NULL, 0, T_LAN, A_LAN_KEEPALIVE_ACK);
                        memcpy(&out_data[20], &rktemp[20 + 12], 12);
                        memcpy(&out_data[20 + 12], &rktemp[20], 12);
                        ltp_udp_sock_send(addr, [NSData dataWithBytes:out_data length:out_data_len]);
                        NSLog(@"A_LAN_KEEPALIVE\r\n");
                        break;
                    case A_LAN_KEEPALIVE_ACK:
                        peer = ltp_peer_get(r_ltid);
                        if (peer == NULL) {
                            peer = ltp_peer_create(r_ltid,sock_send);
                        }
                        [peer lan_keepalive_ack:addr];
                        NSLog(@"A_LAN_KEEPALIVE_ACK\r\n");
                        break;
                }
            }
            break;
        case T_PEER:
           NSLog(@"T_PEER\r\n");// victor  *intranet
            ltp_bytes_ltid(&rktemp[20], r_ltid);
            peer = ltp_peer_get(r_ltid);
            if(peer!=nil&&peer.switch_path!=nil){
                switch (action) {
                    case A_PEER_KEEPALIVE:
                        out_data_len = 20+12;
                        ltp_encode_bytes(out_data, out_data_len, peer.ltaddr.bytes, ltp_local_ltaddr(), 0, T_PEER, A_PEER_KEEPALIVE_ACK);
                        ltp_ltid_bytes(ltp_local_ltid(), &out_data[20]);
                        ltp_udp_sock_send(peer.switch_path.addr, [NSData dataWithBytes:out_data length:out_data_len]);
                                                NSLog(@"A_PEER_KEEPALIVE\r\n");
                        break;
                    case A_PEER_KEEPALIVE_ACK:
                        [peer switch_keepalive_ack];
                        NSLog(@"A_PEER_KEEPALIVE_ACK\r\n");
                        break;
                }
            }
            break;
        default:
//            ltp_log(@"unknown data, type=%d,action=%d,length=%zd addr=%@\r\n",rktemp[18],rktemp[19],length,addr);
            break;
    }
    }
}

static int64_t _LT_BROADCAST_LAST = 0;
int lt_broadcast(NSString* keyword,NSData* msg){
    
    NSData *key = [keyword dataUsingEncoding:NSUTF8StringEncoding];
    NSData* addr;
    Byte *testByte = (Byte *)[key bytes];
    if(keyword!=nil){
        size_t l = keyword.length;
        size_t msg_len;
        msg_len = msg==NULL?0:msg.length;
        int64_t now = ltp_sys_uptime();
        if(LT_STARTED&&l>0&&msg_len<1400&&now-_LT_BROADCAST_LAST>1000){
            _LT_BROADCAST_LAST = now;
            
            int hash = lt_hash(testByte,[key length]);
            char *sendbuf = (char *)malloc(20 + msg_len +1);
            memset(sendbuf,0,20 + msg_len +1);
            size_t sendbuf_len = 20 + msg_len +1;
            
            ltp_encode_bytes(sendbuf,sendbuf_len, 0,0,hash, T_LAN, A_LAN_MESSAGE);
//            NSLog(@"keyboard ........%d",hash);
            ltp_ltid_bytes(ltp_local_ltid(), &sendbuf[2]);
            memcpy(&sendbuf[20],[msg bytes],msg_len);
            addr = ltp_multicast_addr();
            @autoreleasepool {
                ltp_udp_sock_send(addr, [NSData dataWithBytes:sendbuf length:sendbuf_len]);
            }
            return 0;
        }
    }
    return -1;
}


