//
//  longtooth_oc.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//


#import "ltp.h"
static LongTooth* LTP;
static BOOL PTLog_Enable = YES;
@implementation LongTooth
-(void) event_maintain_thread{
    NSLog(@"LongTooth EM Thread started.");
    NSThread *thread=[NSThread currentThread];
    [thread setName:@"LT_EM_THREAD"];
        ltp_event_maintain();
}

-(void) tunnels_maintain_thread{
    NSLog(@"LongTooth TM Thread started.");
    NSThread *thread=[NSThread currentThread];
    [thread setName:@"LT_TM_THREAD"];
        ltp_tunnels_maintain();
}

-(void) tcp_sock_maintain_thread{
    NSLog(@"LongTooth XM Thread started.");
    NSThread *thread=[NSThread currentThread];
    [thread setName:@"LT_SM_THREAD"];
        ltp_tcp_sock_maintain();
}

+ (void)initialize {
    LTP = [[LongTooth alloc]init];
    ltp_init();
}

+(void) setRegisterHost:(NSString*) host andPort:(NSUInteger) port{
    lt_register_host_set(host, (int)port&0xFFFF);
}

+(NSString*) getId{
    return lt_id();
}

+(void) addService:(NSString*) service handleServiceRequestBy:(id<LongToothServiceRequestHandler>) handler{
    lt_service_add(service, handler);
}

+(NSInteger) start:(long long) devId withAppId:(int) appId withAppKey:(NSString* _Nonnull) appKey handleEventBy:(id<LongToothEventHandler> _Nonnull) handler{
    NSLog(@"LongTooth 5  starting build at %s %s\r\n",__DATE__,__TIME__);
    int r =  lt_start(devId, appId, appKey, handler);
    if(r==1){
        [NSThread detachNewThreadSelector:@selector(tunnels_maintain_thread)toTarget:LTP withObject:nil];
        [NSThread detachNewThreadSelector:@selector(tcp_sock_maintain_thread)toTarget:LTP withObject:nil];
        [NSThread detachNewThreadSelector:@selector(event_maintain_thread)toTarget:LTP withObject:nil];
    }
    return r;
}

+(id<LongToothTunnel>) request:(NSString*) ltid forService:(NSString*) service setDataType:(NSInteger) dataType withArguments:(NSData*) args attach:(id<LongToothAttachment>) attachment handleServiceResponseBy:(id<LongToothServiceResponseHandler>) handler{
    NSLog(@"longtooth.request %@",ltid);
    return lt_request(ltid, service, (int)dataType, args, attachment, handler);
}

+(NSInteger) respond:(id<LongToothTunnel>)ltt setDataType:(NSInteger) dataType withArguments:(NSData*) args attach:(id<LongToothAttachment>) attachment{
    return (NSInteger)lt_respond(ltt, (int)dataType, args, attachment);
}

+(NSInteger) broadcast:(NSString*) keyword withMessage:(NSData*) msg{
    
  return lt_broadcast(keyword, msg);;
}

void HandleCustomLog(const char *func, int lineNumber, NSString *format, ...)
{
    if ([LongTooth logEnable]) {
        va_list args;
        va_start(args, format);
        NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *strFormat = [NSString stringWithFormat:@"%s, Line:%i, Log:%@",func,lineNumber,string];
        NSLogv(strFormat, args);
        va_end(args);
    }
}

+ (BOOL)logEnable {
    return PTLog_Enable;
}

+ (void)configLogEnable:(BOOL)flag {
    PTLog_Enable = flag;
}

@end
