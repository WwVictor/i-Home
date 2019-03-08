//
//  LTHandelDelegate.h
//  OmniBox
//
//  Created by Frank on 2018/3/26.
//  Copyright © 2018年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LTHandleDelegate <NSObject>

@end
@protocol HandleBrocastDelegate <NSObject>
- (void)handleBrocastNotification:(id)objc andServiceName:(NSString *)serviceName;
@end
@protocol HandleWifiDelegate <NSObject>
- (void)handleWifiNotification:(id)objc andServiceName:(NSString *)serviceName;
@end
@protocol HandleSendDelegate <NSObject>
- (void)handleSendNotification:(id)objc andServiceName:(NSString *)serviceName;
@end
@protocol HandleEventDelegate <NSObject>
- (void)handleEventNotification:(id)objc andServiceName:(NSString *)serviceName;
@end
@protocol HandleGetDeviceStatusDelegate <NSObject>
- (void)handleGetDeviceStatusNotification:(id)objc andServiceName:(NSString *)serviceName;
@end
