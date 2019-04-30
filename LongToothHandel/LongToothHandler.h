//
//  LongToothHandler.h
//  OmniBox
//
//  Created by Frank on 2018/3/26.
//  Copyright © 2018年 Victor. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "LTHandelDelegate.h"
#import "longtooth.h"
#import "MyFileHeader.h"

typedef void(^SendDeviceMessageBlock)(NSDictionary *returnStr,NSString *serviceName);//发送指令后的Block
typedef void(^SendBraodcastBlock)(NSDictionary *returnStr,NSString *serviceName);//发送指令后的Block
typedef void(^SendInsBlock)(NSDictionary *returnStr,NSString *serviceName);//发送指令后的Block
typedef void(^ReceiveInsBlock)(NSDictionary *receiveStr,NSString *serviceName);//收到指令的Block
typedef void(^EventBlock)(NSInteger event); //长牙事件Block通知
@interface LongToothHandler : NSObject

@property (nonatomic, copy) SendDeviceMessageBlock sendDeviceMessageBlock;
@property (nonatomic, copy) SendBraodcastBlock sendBraodcastBlock;
@property (nonatomic, copy) SendInsBlock sendInsBlock;
@property (nonatomic, copy) ReceiveInsBlock receiveBlock;
@property (weak, nonatomic) id<HandleBrocastDelegate>delegate;
@property (weak, nonatomic) id<HandleWifiDelegate>delegateWifi;
@property (weak, nonatomic)id<HandleSendDelegate>delegateSend;
@property (weak, nonatomic)id<HandleEventDelegate>delegateEvent;
@property (weak, nonatomic)id<HandleGetDeviceStatusDelegate>delegateStatus;
//注册启动长牙
- (void)registeredLongToothHost:(NSString *)host port:(NSInteger)port devid:(int)devId appid:(int)appId appkey:(NSString *)appKey block:(EventBlock)block;
+(instancetype)sharedInstance;

- (void)configHandleSendDelegate:(id)delegate;
//接收设备发送的广播后的请求状态
- (void)listeningSend:(id)obj andServiceName:(NSString *)serviceName;

- (void)configHandleBrocastDelegate:(id)delegate;
//接收设备发送的广播后的请求状态
- (void)listeningBrocast:(id)obj andServiceName:(NSString *)serviceName;


- (void)configHandleWifiDelegate:(id)delegateWifi;
//接收wifi
- (void)listeningWifi:(id)obj andServiceName:(NSString *)serviceName;


- (void)configHandleEventDelegate:(id)delegateEvent;
//监听event状态
- (void)listeningEvent:(id)obj andServiceName:(NSString *)serviceName;


- (void)configHandleGetDeviceStatusDelegate:(id)delegateStatus;
//监听event状态
- (void)listeningStatus:(id)obj andServiceName:(NSString *)serviceName;


//发送广播指令
- (void)sendInsWithRemoteLtid:(NSString *)ltid BroadcastKey:(NSString *)key ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(SendDeviceMessageBlock)block;
- (void)sendBroadInsWithLtid:(NSString *)ltid BroadcastKey:(NSString *)key ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(SendDeviceMessageBlock)block;
//发送wifi请求
- (void)sendRequestWithRemoteLtid:(NSString *)ltid ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(ReceiveInsBlock)block;
@end

#pragma mark 长牙相关处理
/*长牙事件处理*/
typedef void(^EventBlock)(NSInteger event);
@interface LongToothEventHandlerImpl:NSObject<LongToothEventHandler>
@property (nonatomic,copy) EventBlock eventBlock;
@end

/*长牙响应回调处理*/
typedef void(^ReturnBlock)(NSDictionary *returnBlock,NSString *serviceName);
@interface LongToothServiceResponseHandlerImpl:NSObject<LongToothServiceResponseHandler>
@property (nonatomic,copy) ReturnBlock returnBlock;
@end

/*长牙请求回调处理*/
typedef void(^ReceiveBlock)(NSDictionary *receiveBlock,NSString *serviceName);
@interface LongToothServiceRequestHandlerImpl:NSObject<LongToothServiceRequestHandler>
@property (nonatomic,copy) ReceiveBlock receiveBlock;
@end

/*发送长牙广播请求回调处理*/
//typedef void(^ReceiveBrocastBlock)(NSString *receiveBlock);
@interface LongToothBrocastRequestHandlerImpl:NSObject<LongToothServiceRequestHandler>
//@property (nonatomic,strong)ReceiveBrocastBlock receiveBrocastBlock;
@end

