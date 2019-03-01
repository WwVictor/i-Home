//
//  GetDeviceNetworkIP.h
//  OmniBox
//
//  Created by Frank on 2018/3/8.
//  Copyright © 2018年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDeviceNetworkIP : NSObject
//单例
+(GetDeviceNetworkIP *)shareManager;
//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取WIFI名字的方法
- (NSString *)getWifiName;
//获取WIFIIP的方法
- (NSString *)getIPAddress;
- (NSDictionary *)getIPAddresses;
- (BOOL)isValidatIP:(NSString *)ipAddress;
- (NSString *)ssid;
- (NSString *)bssid;
@end
