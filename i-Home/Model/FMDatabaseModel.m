//
//  FMDatabaseModel.m
//  iThing
//
//  Created by Frank on 2018/8/9.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "FMDatabaseModel.h"
#import "MyFileHeader.h"
@implementation FMDatabaseModel
MJCodingImplementation
@end

@implementation UserMessageModel
MJCodingImplementation
@end

@implementation RoomMessageModel
MJCodingImplementation
@end

@implementation HomeInformationModel
MJCodingImplementation
@end

@implementation DeviceInformationModel
MJCodingImplementation
@end

@implementation RoomInformationModel
MJCodingImplementation
@end

@implementation SceneInformationModel
MJCodingImplementation
@end

@implementation DeviceStatusModel
MJCodingImplementation
@end

@implementation DimmerStatusModel
MJCodingImplementation
@end

@implementation LedStatusModel
MJCodingImplementation
@end

@implementation StaturationStatusModel
MJCodingImplementation
@end

@implementation RgbStatusModel
MJCodingImplementation
@end

@implementation SocketStatusModel
MJCodingImplementation
@end

@implementation SwitchStatusModel
MJCodingImplementation
@end

@implementation CurtainStatusModel
MJCodingImplementation
@end

@implementation AirConditionerStatusModel
MJCodingImplementation
@end
@implementation DeviceMessageModel
MJCodingImplementation
@end
@implementation SceneDeviceStatusModel
MJCodingImplementation
@end
@implementation ShareUserInformationModel
MJCodingImplementation
@end

@implementation DeviceVersionModel
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"dev_description" : @"description"
             };
}
@end
@implementation SelectRoomModel
MJCodingImplementation
@end
