//
//  DeviceTypeManager.h
//  iThing
//
//  Created by Frank on 2018/10/10.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceTypeManager : NSObject
+ (DeviceTypeManager *)shareManager;
- (NSString *)getDeviceIcon:(int)deviceType andSerialType:(int)serialType;
- (NSString *)getDeviceName:(int)deviceType andSerialType:(int)serialType;
- (NSString *)getDeviceType:(int)deviceType andSerialType:(int)serialType;
- (NSString *)setDeviceName:(int)deviceType andSerialType:(int)serialType;
- (NSString *)toBinarySystemWithDecimalSystem:(int)decimal;
- (NSString *)getWeekTimeWithDecimalSystem:(NSString *)decimal;
- (NSString *)getWeekStringWithDecimal:(NSString *)decimal;
- (NSString *)getDeviceTypeName:(int)deviceType andSerialType:(int)serialType;
- (NSString *)getDeviceTableName:(DeviceInformationModel *)model;
#pragma mark 二进制转十进制
- (int)convertDecimalSystemFromBinarySystem:(NSString *)binary;

- (NSString *)get8Userid;
- (NSString *)get10Homeid;
- (NSString *)get14Roomid;
- (NSString *)get12Sceneid;
- (NSString *)get16Deviceid;



@end

NS_ASSUME_NONNULL_END
