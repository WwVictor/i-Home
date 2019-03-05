//
//  ltp_udp_sock.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp_udp_sock.h"

static LTPUdpSock* SOCK;
void ltp_udp_sock_init(){
    SOCK = [[LTPUdpSock alloc]init];
    [SOCK start];
}

// modify at 20170831 to reslove udp restart

void ltp_udp_sock_close(){
    
    [SOCK close];
}
void ltp_udp_sock_restart(){

    [SOCK start];
}

void ltp_udp_sock_send(NSData* _Nullable addr ,NSData* _Nonnull data){
    NSString* ipaddr = [[NSString alloc]init];
    uint16_t ipport;
    
    [LTGCDAsyncUdpSocket getHost:&ipaddr port:&ipport fromAddress:addr];
   
    const char*ca = [data bytes];
    NSLog(@"%s %@ %d %lu (%d,%d)",__FUNCTION__,ipaddr,ipport,data.length,ca[18],ca[19]);
    
    [SOCK send:data to:addr];
}


@implementation LTPUdpSock
-(id) init{
    if(self=[super init]){
        sock = nil;
    }
    return (self);
}
-(void) close{
    if(sock!=nil){
        [sock close];
        sock = nil;
    }
}

-(void) start{
    
//    NSLog(@"%s    %@",__FUNCTION__,sock);
    if (sock == nil)
    {
        sock = [[LTGCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error = nil;
        [sock enableBroadcast:true error:&error];
        if (error) {
            ltp_log(@"failed.:%@",[error description]);
        }

        [sock beginReceiving:&error];
        if (error) {
            ltp_log(@"failed.:%@",[error description]);
        }
    }
   else {
        NSError *error = nil;
        [sock enableBroadcast:true error:&error];
        if (error) {
            ltp_log(@"failed.:%@",[error description]);
        }
        [sock beginReceiving:&error];
//       NSLog(@"sock 已执行");
        if (error) {
            ltp_log(@"failed.:%@",[error description]);
        }
    }
}

- (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSUInteger rev_len = data.length;
    const char* revbuf=[data bytes];
//    PT_Log(@"%s %d %d %d %d",__FUNCTION__,rev_len,revbuf[18],revbuf[19],revbuf[20]);
    NSString* ipaddr = [[NSString alloc]init];
    uint16_t ipport;
    
    [LTGCDAsyncUdpSocket getHost:&ipaddr port:&ipport fromAddress:address];
    PT_Log(@"Reciv Data len:%lu from %@，data[18] %d,data[19] %d,ipaddr%@,ipport %d",[data length],address,revbuf[18],revbuf[19],ipaddr,ipport);
    if(rev_len > 19&&rev_len<1473&&(ltp_bytes_int32(revbuf) & 0xffff)==(rev_len-2)) {
        PT_Log(@"%s %d %d %d %d",__FUNCTION__,rev_len,revbuf[18],revbuf[19],revbuf[20]);
        ltp_main_decode(ltp_udp_sock_send, address, revbuf, rev_len);
        //NSLog(@"%s %d %d %d %d end",__FUNCTION__,rev_len,revbuf[18],revbuf[19],revbuf[20]);
    }
}

- (void)udpSocketDidClose:(LTGCDAsyncUdpSocket *)socket withError:(NSError *)error;{
    
    if(error!=nil){
//    NSLog(@"%s %@",__FUNCTION__,[error description]);
    [lock lock];
    [sock close];
    sock = nil;
    [self start];
    [lock unlock];
    }
}


- (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    PT_Log(@"Socket:DidConnectToHost: %@", address);
    
    //[socket beginReceiving:&error];
}

- (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error;{
    
    PT_Log(@"%s   %@",__FUNCTION__,error);
    
}

// - (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
//{
//    PT_Log(@"发送信息成功");
//}
//
//
//- (void)udpSocket:(LTGCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
//{
//    PT_Log(@"发送信息失败");
//}

-(void)send:(NSData *)data to:(NSData *)addr{
    
    [lock lock];
    [sock sendData:data toAddress: addr withTimeout:-1 tag:200];
    [lock unlock];
    
    const char *temp = data.bytes;
    char type = temp[18];
    char action = temp[19];
    if (type == 103 && action >= 1 && action <=8 ) {
        PT_Log(@" %s type=%d,action=%d \r\n",__FUNCTION__, type,action);
    }
    
//    const char* bytes = data.bytes;
//    if(data.length==21||data.length==22){
//        NSLog(@"bytes[18] %d bytes[19] %d",bytes[18],bytes[19]);
//    }
    
    
}
@end
