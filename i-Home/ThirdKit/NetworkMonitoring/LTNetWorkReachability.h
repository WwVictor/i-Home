//
//  LTNetWorkReachability.h
//  NetworkMonitoring
//
//  Created by Frank on 2017/4/13.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTNetWorkStatus) {
    LTNetWorkStatusNotReachable = 0,
    LTNetWorkStatusUnknown = 1,
    LTNetWorkStatusWWAN2G = 2,
    LTNetWorkStatusWWAN3G = 3,
    LTNetWorkStatusWWAN4G = 4,
    
    LTNetWorkStatusWiFi = 9,
};

extern NSString *LTNetWorkReachabilityChangedNotification;

@interface LTNetWorkReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (LTNetWorkStatus)currentReachabilityStatus;

@end

