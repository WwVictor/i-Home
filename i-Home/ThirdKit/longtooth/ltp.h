//
//  ltp.h
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//
#import "longtooth.h"
#ifndef ltp_h
#define ltp_h

#define T_PASSPORT                      100
#define A_PASSPORT_LOCATE               1
#define A_PASSPORT_LOCATE_ACK           2
#define A_PASSPORT_REGISTER             3
#define A_PASSPORT_REGISTER_ACK         4

#define T_ROUTER                        101
#define A_ROUTER_REGISTER_SYN           1
#define A_ROUTER_REGISTER_SYN_ACK       2
#define A_ROUTER_KEEPALIVE              3
#define A_ROUTER_KEEPALIVE_ACK          4
#define A_ROUTER_LOOKUP                 5
#define A_ROUTER_LOOKUP_ACK             6
#define A_ROUTER_RELAY                  7
#define A_ROUTER_RELAY_ACK              8

#define T_SWITCH                        102
#define A_SWITCH_SYN                    1
#define A_SWITCH_SYN_ACK                2
#define A_SWITCH_KEEPALIVE              3
#define A_SWITCH_KEEPALIVE_ACK          4

#define T_TUNNEL                        103
#define A_TUNNEL_KEEPALIVE              1
#define A_TUNNEL_KEEPALIVE_ACK          2
#define A_TUNNEL_REQUEST_SYN            3
#define A_TUNNEL_REQUEST_SYN_ACK        4
#define A_TUNNEL_RESPONSE_SYN           5
#define A_TUNNEL_RESPONSE_SYN_ACK       6
#define A_TUNNEL_FIN                    7
#define A_TUNNEL_FIN_ACK                8
#define A_TUNNEL_STREAM                 9
#define A_TUNNEL_STREAM_ACK             10
#define A_TUNNEL_STREAM_KEEPALIVE       11
#define A_TUNNEL_STREAM_KEEPALIVE_ACK   12
#define A_TUNNEL_DATAGRAM               13

#define T_LAN                           104
#define A_LAN_MESSAGE                   1
#define A_LAN_WHOIS                     2
#define A_LAN_IAM                       3
#define A_LAN_KEEPALIVE                 4
#define A_LAN_KEEPALIVE_ACK             5

#define T_P2P                           105
#define A_P2P_KEEPALIVE                 1
#define A_P2P_KEEPALIVE_ACK             2

#define T_PEER                          106
#define A_PEER_KEEPALIVE                1
#define A_PEER_KEEPALIVE_ACK            2

#define  LT_DATAPACKET_SIZE             1400
#define  LT_DATAPACKET_PAYLOAD          LT_DATAPACKET_SIZE-24
#define  SOCKET_BYTE_BUF_SIZE           LT_DATAPACKET_SIZE*2
#define  SOCKET_RECV_BUF_SIZE           SOCKET_BYTE_BUF_SIZE+LT_DATAPACKET_SIZE
#define  SOCKET_SEND_BUF_SIZE           SOCKET_BYTE_BUF_SIZE*16



@protocol LTPSock

@required
-(void) send:(NSData* _Nonnull) data to:(NSData* _Nullable)addr;
@end

typedef void(*ltp_sock_send)(NSData* _Nullable addr ,NSData* _Nonnull data);
typedef void(*ltp_decode)(ltp_sock_send _Nonnull sock_send,NSData* _Nullable addr,const char* _Nonnull data,ssize_t len);

/*
 *ltp_sha256
 */
void ltp_sha256(const char* _Nonnull src,size_t len,char* _Nonnull dest);

/*
 *ltp_switch_path.c
 */
@interface ltp_switch_path: NSObject
@property (nonatomic) NSData* _Nullable addr;
@property (nonatomic) int id;
@property (nonatomic) int state;
@property (nonatomic) int state_count;
@property (nonatomic) int64_t state_timestamp;
-(void) maintain;
-(void) swregister:(int64_t) timestamp;
-(void) register_ack;
-(void) keepalive;
-(void) keepalive_ack;
@end
void ltp_switch_path_init(void);

ltp_switch_path* _Nullable ltp_switch_path_create(int id,NSData* _Nonnull addr);
void ltp_switch_path_save(ltp_switch_path* _Nonnull path);
ltp_switch_path* _Nullable ltp_switch_path_get(NSData* _Nonnull addr);

@interface ltp_peer: NSObject

@property (nonatomic) NSCondition* _Nonnull cond;

@property (nonatomic) NSData* _Nonnull ltid;
@property (nonatomic) NSData* _Nullable ltaddr;
@property (nonatomic) int64_t ltaddr_find_timestamp;

@property (nonatomic) NSData* _Nullable sock_addr;
@property (nonatomic) ltp_sock_send _Nullable send;

@property (nonatomic) ltp_switch_path* _Nullable switch_path;
@property (nonatomic) int switch_state;
@property (nonatomic) int64_t switch_state_timestamp;
@property (nonatomic) int switch_state_count;

@property (nonatomic) NSData* _Nullable lan_addr;
@property (nonatomic) int lan_state;
@property (nonatomic) int64_t lan_state_timestamp;
@property (nonatomic) int lan_state_count;

@property (nonatomic) NSData* _Nullable p2p_addr;
@property (nonatomic) int p2p_state;
@property (nonatomic) int64_t p2p_state_timestamp;
@property (nonatomic) int p2p_state_count;

-(int) lookup;
-(void) send:(NSData* _Nonnull) data;
-(void) maintain;
-(void) lan_maintain;
-(void) p2p_maintain;
-(void) lan_keepalive_ack:(NSData* _Nonnull) addr;
-(void) switch_keepalive_ack;
-(NSInteger) respond:(NSData* _Nonnull) lttkey dataType:(char) data_type arguments:(NSData* _Nullable) resp_args waitable:(BOOL) wait;
-(NSInteger) request:(const char* _Nonnull) sessionid serviceName:(NSString* _Nonnull) srv_name dataType:(char) data_type arguments:(NSData* _Nullable) req_args waitable:(BOOL) wait;
@end

void lt_lan_mode_set(bool enable);
void ltp_peer_init(void);
ltp_peer* _Nullable ltp_peer_create(const char* _Nonnull ltid,ltp_sock_send _Nullable sock_send);
ltp_peer* _Nullable ltp_peer_get(const char* _Nonnull ltid);

bool ltp_peer_lan_disabled(void);
@interface ltp_tunnel_inputdatagram:NSObject{
    NSData* buf[256];
    NSCondition* cond;
    int h,t,l;
    BOOL closed;
    int64_t recv_timestamp;
}
-(void) input:(const char* _Nonnull) data length:(size_t) len;
-(NSInteger) read:(NSMutableData* _Nullable) buffer;
-(void) close;
-(int64_t) idle:(int64_t) now;
@end

ltp_tunnel_inputdatagram* _Nullable ltp_tunnel_inputdatagram_create(void);

@interface ltp_tunnel_inputstream: NSObject
{
    NSData* buffer[256];
    int head;
    int size;
    char sessionid[4];
    int64_t recv_timestamp;
    int recv_timeout;
    int64_t readed;
    int64_t inputed;
    BOOL closed;
    NSCondition* cond;
    int64_t _pidx ;//20170911 by victor
}
-(id _Nullable) initWithSessionId:(const char* _Nonnull) sid;
-(int) input:(const char* _Nonnull) data length:(size_t) len;
-(int) keepalive:(int) idx;
-(int) read:(NSMutableData* _Nullable) buffer;
-(int64_t) idle:(int64_t) now;
-(void) close;
-(int64_t) countReaded;
-(int64_t) countInputed;
@end

ltp_tunnel_inputstream* _Nullable ltp_tunnel_inputstream_create(const char* _Nonnull sessionid);

@interface ltp_tunnel_outputstream_packet : NSObject
@property (nonatomic) NSData* _Nullable data;
@property (nonatomic) int count;
@property (nonatomic) int64_t send_timestamp;
@property (nonatomic) int64_t pidx; // 20170911 by victor
@end
@interface ltp_tunnel_outputstream : NSObject
{
    char _sessionid[4];
    ltp_tunnel_outputstream_packet* _packets[256];
    int _limit;
    int _head;
    int _length;
    int _cur;
    int _rtt;
    int _send_timeout;
    int64_t _send_timestamp;
    int64_t _ack_timestamp;
    int _opened;
    ltp_peer* _peer;
    NSCondition* _cond;
    int64_t _pidx ;// by 20170911 victor
    int64_t _total_send;
}
-(id _Nullable) initWith:(ltp_peer* _Nonnull) peer sessionId:(const char* _Nonnull) sessionid;
-(void) ack:(int) idx;
-(int64_t) idle:(int64_t) now;
-(void) keepalive:(int64_t) timestamp;
-(void) retransmit:(int) idx state:(int) state;
-(void) close;
-(void) kill;
-(void) limit:(int) limit;
-(int) write:(NSData* _Nullable) buffer;
-(BOOL) isClosed;
@end

ltp_tunnel_outputstream* _Nullable ltp_tunnel_outputstream_create(ltp_peer* _Nonnull peer,const char* _Nonnull sessionid);
@interface ltp_tunnel:NSObject<LongToothTunnel>
@property (nonatomic) NSData* _Nonnull key;
@property (nonatomic) ltp_peer* _Nonnull peer;
@property (nonatomic) NSString* _Nonnull  srv_name;
@property (nonatomic) ltp_tunnel_inputstream* _Nullable input;
@property (nonatomic) int in_closed;
@property (nonatomic) ltp_tunnel_outputstream* _Nullable output;
@property (nonatomic) int out_closed;

@property (nonatomic) ltp_tunnel_inputdatagram* _Nullable inputd;
@property (nonatomic) int ind_closed;
@property (nonatomic) int outd_closed;
@property (nonatomic) int64_t outd_timestamp;
@property (nonatomic) NSLock* _Nonnull lock;
@property (nonatomic) NSData* _Nullable req_args;
@property (nonatomic) char req_data_type;
@property (nonatomic) id<LongToothServiceRequestHandler> _Nullable req_handler;
@property (nonatomic) NSData* _Nullable resp_args;
@property (nonatomic) char resp_data_type;
@property (nonatomic) id<LongToothServiceResponseHandler> _Nullable resp_handler;
@property (nonatomic) int sync;
@property (nonatomic) int64_t req_count;
@property (nonatomic) int64_t resp_count;
@property (nonatomic) int64_t sync_count;
@property (nonatomic) int64_t sync_timestamp;
@property (nonatomic) int64_t sync_ack_timestamp;
@property (nonatomic) char type;

@property (nonatomic) id<LongToothAttachment> _Nullable attachment;

@property (nonatomic) int fined;
@property (nonatomic) int64_t fin_timestamp;
@property (nonatomic) int fin_count;

@property (nonatomic) int fin_acked;
@property (nonatomic) int64_t fin_ack_timestamp;
@property (nonatomic) int64_t keep_ack_timestamp;
@property (nonatomic) int64_t keep_timestamp;
@property (nonatomic) int64_t create_timestamp;
@property (nonatomic) int64_t wait_timestamp;
@property (nonatomic) int keep_count;


-(void) request_sync:(BOOL) wait;
-(void) request_sync_ack;
-(void) fin;
-(void) fin_ack;
-(void) close;
-(int) response_sync:(BOOL) wait;
-(void) response_sync_ack;
-(void) keepalive_ack;
-(void) maintain;
-(void) request_thread;
-(void) response_thread;
@end
void ltp_tunnel_init(void);
void ltp_tunnels_maintain(void);
ltp_tunnel* _Nullable ltp_tunnel_get(const char* _Nonnull key);
ltp_tunnel* _Nullable ltp_tunnel_create(
                                        ltp_peer* _Nonnull peer,
                                        char type,
                                        NSData* _Nonnull lttkey,
                                        NSString* _Nonnull srv_name,
                                        NSData*  _Nonnull req_args,
                                        char req_data_type,
                                        id<LongToothServiceRequestHandler>  _Nullable req_handler,
                                        id<LongToothServiceResponseHandler> _Nullable resp_handler,
                                        id<LongToothAttachment> _Nullable attachment);
id<LongToothTunnel> _Nullable lt_request(NSString* _Nonnull ltid_str,
                               NSString* _Nonnull service_str,
                               int lt_data_type,
                               NSData* _Nullable args,
                               id<LongToothAttachment> _Nullable attachment,
                               id<LongToothServiceResponseHandler> _Nonnull resp_handler);

int lt_respond(id<LongToothTunnel> _Nonnull ltt,
               int lt_data_type,
               NSData* _Nullable args,
               id<LongToothAttachment> _Nullable attachment);
void ltp_multicast_sock_init(void);
NSData* _Nullable ltp_multicast_addr(void);
int lt_broadcast(NSString* _Nullable keyword,NSData* _Nonnull msg);
void ltp_udp_sock_init(void);
void ltp_udp_sock_send(NSData* _Nullable addr,NSData* _Nonnull data);
void ltp_udp_sock_close(void);
void ltp_udp_sock_restart(void);
/*
 *ltp_tcp_sock.c
 */

void lt_register_host_set(NSString* _Nullable host, int port);
void ltp_tcp_sock_init(void);
void ltp_tcp_sock_maintain(void);
void ltp_tcp_sock_send(NSData* _Nullable addr,NSData* _Nonnull data);
ltp_switch_path* _Nonnull ltp_local_switch_path(void);
int ltp_local_switch_path_state(void);
const char* _Nonnull ltp_local_ltaddr(void);

int ltp_local_ltaddr_rtid(void);
int ltp_local_ltaddr_rtport(void);

void ltp_router_register_ack(int64_t key);
bool ltp_router_registered(void);
void ltp_router_keepalive(void);
void ltp_router_keepalive_ack(void);
NSData* _Nullable ltp_p2p_ip_addr(void);

/*
 *ltp_event.c
 */
void ltp_event_init(id<LongToothEventHandler> _Nonnull handler);
void ltp_event_maintain(void);
void ltp_event_fire(int event, NSString* _Nonnull ltid, NSString* _Nullable srv_str,NSData* _Nullable msg,id<LongToothAttachment> _Nullable attachment);

/*
 *ltp.m
 */
@interface ltp_lan_message_handler : NSObject<LongToothAttachment>
{
    NSData* message;
    
}
-(id _Nullable) initWithMessage:(NSData* _Nonnull) msg hash:(int32_t)hash;
@end

void ltp_init(void);
void lt_service_add(NSString* _Nonnull srv_name,id<LongToothServiceRequestHandler> _Nonnull srv);
id<LongToothServiceRequestHandler> _Nullable ltp_service_get(NSString* _Nonnull srv_name);
const char* _Nonnull ltp_local_ltid(void);
// modify by victor at 20171146
int lt_hash(const void* _Nullable key, ssize_t keySize);
size_t ltp_app_key_len(void);
const char* _Nonnull ltp_app_key(void);

void ltp_encode_bytes(char* _Nonnull bytes,size_t len, const char* _Nullable to, const char* _Nullable from, int sessionid, char type, char action);

void ltp_main_decode(ltp_sock_send _Nonnull sock_send,NSData* _Nullable addr,const char* _Nonnull data,ssize_t len);

NSString* _Nonnull lt_id(void);
int lt_start(int64_t devid,int appid,NSString* _Nonnull appkey,id<LongToothEventHandler> _Nonnull handler);


/*
 *ltp_util.c
 */
NSString* _Nullable ltp_hardware_uuid(void);
void ltp_log(NSString* _Nonnull format,...);

NSString* _Nullable ltp_ltid_nsstring(NSData* _Nonnull ltid);
void ltp_str_ltid(NSString* _Nonnull str, char* _Nonnull ltid);
void ltp_ltid_str(const char* _Nonnull ltid,char* _Nonnull dest);

void ltp_ltaddr_bytes(const char* _Nonnull ltaddr,char* _Nonnull dest);
void ltp_bytes_ltaddr(const char* _Nonnull data,char* _Nonnull ltaddr);

void ltp_ltid_create(int64_t appid,int64_t id,char* _Nonnull ltid);
void ltp_ltid_bytes(const char* _Nonnull ltid,char* _Nonnull dest);
void ltp_bytes_ltid(const char* _Nonnull src,char* _Nonnull ltid);

size_t ltp_hexstr_bytes(const char* _Nonnull hex, char* _Nonnull out);
int16_t ltp_bytes_int16(const char* _Nonnull buf);
void ltp_int16_bytes(int32_t i, char* _Nonnull buf);
int32_t ltp_bytes_int32(const char* _Nonnull buf);
void ltp_int32_bytes(int32_t i, char* _Nonnull buf);
void ltp_int64_bytes(int64_t l, char* _Nonnull buf);
int64_t ltp_bytes_int64(const char* _Nonnull buf) ;
int64_t ltp_sys_uptime(void);
int64_t ltp_sys_clock(void);
NSData* _Nullable ltp_proper_ipaddr(NSString* _Nonnull ipAddr, uint16_t ipPort);
BOOL ltp_bytes_equals(const char* _Nonnull bytes1,const char* _Nonnull bytes2,size_t len);
#endif /* ltp_h */
