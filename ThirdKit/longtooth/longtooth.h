//
//  longtooth_oc.h
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EVENT_LONGTOOTH_STOPPED             0x20000
#define EVENT_LONGTOOTH_STARTED             0x20001
#define EVENT_LONGTOOTH_ACTIVATED           0x20002
#define EVENT_LONGTOOTH_KEEPALIVE           0x20004
#define EVENT_LONGTOOTH_KEEPALIVE_ACK       0x20005
#define EVENT_LONGTOOTH_KEEPALIVE_FAILED    0x20006

#define EVENT_LONGTOOTH_INVALID             0x28001
#define EVENT_LONGTOOTH_TIMEOUT             0x28002
#define EVENT_LONGTOOTH_UNREACHABLE         0x28003
#define EVENT_LONGTOOTH_OFFLINE             0x28004
#define EVENT_LONGTOOTH_BROADCAST           0x28005
#define EVENT_LONGTOOTH_REQUEST_RETRY       0x28006
#define EVENT_LONGTOOTH_RESPONSE_RETRY      0x28007

#define EVENT_SERVICE_NOT_EXIST             0x40001
#define EVENT_SERVICE_INVALID               0x40002
#define EVENT_SERVICE_EXCEPTION             0x40003
#define EVENT_SERVICE_TIMEOUT               0x40004

#define LT_ARGUMENTS	0
#define LT_STREAM		1
#define LT_DATAGRAM		2

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
#define PT_Log(format,...) HandleCustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)

/**
 *  log执行方法，使用时通过宏定义 PT_Log
 *  @param func         方法名
 *  @param lineNumber   行号
 *  @param format       Log内容
 *  @param ...          个数可变的Log参数
 */
void HandleCustomLog(const char * _Nullable func, int lineNumber, NSString * _Nullable format, ...);


@protocol LongToothTunnel

@required
//-(void) saveTempToFile:(NSString* _Nonnull) file;

@required
-(NSInteger) receive:(NSMutableData* _Nullable) data;
@required
-(NSInteger) send:(NSData* _Nullable) data;
@end

@protocol LongToothAttachment
@required
-(NSObject* _Nullable) handle:(NSObject* _Nullable) arg;
@end

@protocol LongToothEventHandler

@required
-(void) handle:(NSInteger) event withLongToothId:(NSString* _Nonnull) ltid withServiceName:(NSString* _Nullable) service withMessage:(NSData* _Nullable) msg withAttachment:(id<LongToothAttachment> _Nullable) attachment;

@end

@protocol LongToothServiceRequestHandler

@required
-(void) handle:(id<LongToothTunnel> _Nonnull) ltt withLongToothId:(NSString* _Nonnull) ltid withServiceName:(NSString* _Nonnull) service dataTypeIs:(NSInteger) dataType withArguments:(NSData* _Nullable) args;
@end


@protocol LongToothServiceResponseHandler

@required
-(void) handle:(id<LongToothTunnel> _Nonnull) ltt withLongToothId:(NSString* _Nonnull) ltid withServiceName:(NSString* _Nonnull) service dataTypeIs:(NSInteger) dataType withArguments:(NSData* _Nullable) args attach:(id<LongToothAttachment> _Nullable) attachment;


@end


@interface LongTooth: NSObject


+(void) setRegisterHost:(NSString* _Nullable) host andPort:(NSUInteger) port;

+(NSString* _Nonnull) getId;

+(void) addService:(NSString* _Nonnull) service handleServiceRequestBy:(id<LongToothServiceRequestHandler> _Nonnull) handler;

+(NSInteger) start:(long long) devId withAppId:(int) appId withAppKey:(NSString* _Nonnull) appKey handleEventBy:(id<LongToothEventHandler> _Nonnull) handler;

+(id<LongToothTunnel> _Nullable) request:(NSString* _Nonnull) ltid forService:(NSString* _Nonnull) service setDataType:(NSInteger) dataType withArguments:(NSData* _Nullable) args attach:(id<LongToothAttachment> _Nullable) attachment handleServiceResponseBy:(id<LongToothServiceResponseHandler> _Nonnull) handler;
+(NSInteger) respond:(id<LongToothTunnel> _Nonnull)ltt setDataType:(NSInteger) dataType withArguments:(NSData* _Nullable) args attach:(id<LongToothAttachment> _Nullable) attachment;
+(NSInteger) broadcast:(NSString* _Nonnull) keyword withMessage:(NSData* _Nonnull) msg;


/**
 *  log是否可用
 *  @return 可用状态
 */
+ (BOOL)logEnable;

/**
 *  设置log是否可用，默认可用
 *  @param flag 是否开启
 */
+ (void)configLogEnable:(BOOL)flag;

@end
