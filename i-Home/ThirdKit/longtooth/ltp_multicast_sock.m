//
//  ltp_multicast_sock.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp_multicast_sock.h"
#import "LTGCDAsyncSocket.h"
#define MCAST_PORT 30531
#define MCAST_HOST "224.0.0.251"     /*一个局部连接多播地址，路由器不进行转发*/

static NSData* MCAST_ADDR =nil;
static LTPMulticastSock* SOCK;
void ltp_multicast_sock_init(){
    MCAST_ADDR = ltp_proper_ipaddr(@MCAST_HOST, MCAST_PORT);
    SOCK = [[LTPMulticastSock alloc]init];
    [SOCK start];
}
NSData* ltp_multicast_addr(){
    return MCAST_ADDR;
}
void ltp_multicast_sock_send(NSData* addr,NSData* data){
    [SOCK send:data to:addr];
}


@implementation LTPMulticastSock
-(id) init{
    if(self=[super init]){
        sock = nil;
    }
    return (self);
}
- (void)start{
    sock = [[LTGCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    [sock enableReusePort:TRUE error:&error];
    if (error) {
        ltp_log(@"failed.:%@",[error description]);
    }

    [sock bindToPort:30531 error:&error];
    if (error) {
        ltp_log(@"failed.:%@",[error description]);
    }
    [sock enableBroadcast:YES error:&error];
    if (nil != error) {
        ltp_log(@"failed.:%@",[error description]);
    }
    
    //组播224.0.0.2地址，如果地址大于224的话，就要设置GCDAsyncUdpSocket的TTL （默认TTL为1）
    
    [sock joinMulticastGroup:@MCAST_HOST error:&error];
    if (error) {
        ltp_log(@"failed.:%@",[error description]);
    }
    
    [sock beginReceiving:&error];
    if (error) {
        ltp_log(@"failed.:%@",[error description]);
    }
}


- (void)dealloc{
    if (sock) {
        [sock close];
    }
}

#pragma mark -GCDAsyncUdpsocket Delegate

- (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    PT_Log(@"Reciv Data len:%lu from %@",[data length],address);
    NSUInteger rev_len = data.length;
    const char* revbuf=[data bytes];
    if(rev_len > 19&&rev_len<1473&&(ltp_bytes_int32(revbuf) & 0xffff)==(rev_len-2)) {
        ltp_main_decode(ltp_multicast_sock_send, address, revbuf, rev_len);
    }
    NSString* ipaddr = [[NSString alloc]init];
    uint16_t ipport;
    
    [LTGCDAsyncUdpSocket getHost:&ipaddr port:&ipport fromAddress:address];
    PT_Log(@"Reciv Data len:%lu from %@，data[18] %d,data[19] %d,ipaddr%@,ipport %d",[data length],address,revbuf[18],revbuf[19],ipaddr,ipport);
}


- (void)udpSocketDidClose:(LTGCDAsyncUdpSocket *)sock withError:(NSError *)error

{
    
    PT_Log(@"udpSocketDidClose Error:%@",[error description]);
    
}

-(void) send:(NSData *)data to:(NSData *)addr{
  
}
@end










