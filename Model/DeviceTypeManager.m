//
//  DeviceTypeManager.m
//  iThing
//
//  Created by Frank on 2018/10/10.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "DeviceTypeManager.h"
#import "MyFileHeader.h"

@implementation DeviceTypeManager
+ (DeviceTypeManager *)shareManager {
    static DeviceTypeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        manager = [DeviceTypeManager new];
    });
    return manager;
}
- (NSString *)get8Userid
{
    NSString *str;
    for (int i = 0; i < 8; i++) {
        int x = (arc4random() % 10);
        if (i == 0) {
            if (x == 0) {
                x = 1;
            }
            str = [NSString stringWithFormat:@"%d",x];
        }else{
            str = [NSString stringWithFormat:@"%@%d",str,x];
        }
        
    }
    NSLog(@"get8Userid === %@",str);
    return str;
}
- (NSString *)get10Homeid
{
    NSString *str;
    for (int i = 0; i < 10; i++) {
        int x = (arc4random() % 10);
        if (i == 0) {
            if (x == 0) {
                x = 1;
            }
            str = [NSString stringWithFormat:@"%d",x];
        }else{
            str = [NSString stringWithFormat:@"%@%d",str,x];
        }
    }
    NSLog(@"get10Homeid === %@",str);
    return str;
}
- (NSString *)get14Roomid
{
    NSString *str;
    for (int i = 0; i < 14; i++) {
        int x = (arc4random() % 10);
        if (i == 0) {
            if (x == 0) {
                x = 1;
            }
            str = [NSString stringWithFormat:@"%d",x];
        }else{
            str = [NSString stringWithFormat:@"%@%d",str,x];
        }
    }
    NSLog(@"get14Roomid === %@",str);
    return str;
}
- (NSString *)get12Sceneid
{
    NSString *str;
    for (int i = 0; i < 12; i++) {
        int x = (arc4random() % 10);
        if (i == 0) {
            if (x == 0) {
                x = 1;
            }
            str = [NSString stringWithFormat:@"%d",x];
        }else{
            str = [NSString stringWithFormat:@"%@%d",str,x];
        }
    }
    NSLog(@"get12Sceneid === %@",str);
    return str;
}
- (NSString *)get16Deviceid
{
    NSString *str;
    for (int i = 0; i < 16; i++) {
        int x = (arc4random() % 10);
        if (i == 0) {
            if (x == 0) {
                x = 1;
            }
            str = [NSString stringWithFormat:@"%d",x];
        }else{
            str = [NSString stringWithFormat:@"%@%d",str,x];
        }
    }
    NSLog(@"str === %@",str);
    return str;
}
- (NSString *)getDeviceTableName:(DeviceInformationModel *)model
{
    if([model.type intValue] == 1){
        if ([model.serial_type intValue] == 1) {
            return DimmerTabel;
        }else if ([model.serial_type intValue] == 2){
            return BrightRBGTabel;
        }else if ([model.serial_type intValue] == 3){
            return RGBTabel;
        }else{
            return BrightTempTabel;
        }
        
    }else if ([model.type intValue] == 2 ){
        return SocketTabel;
    }else if ([model.type intValue] == 3){
        return SwitchTabel;
    }else if ([model.type intValue] == 4){
        return CurtainTabel;
    }else if ([model.type intValue] == 5){
        return AirCondiTabel;
    }else{
        return nil;
    }
}

- (NSString *)getDeviceIcon:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == DEV_TYPE_LIGHTBULB) {
        if (serialType == 1) {
           return @"device_light_sensor";
        }else if (serialType == 2){
            return @"device_rgb";
        }else if (serialType == 3){
            return @"device_rgb";
        }else{
            return @"device_light_bulb";
        }
        
    }else if (deviceType == DEV_TYPE_SOCKET){
        return @"device_socket";
    }else if (deviceType == DEV_TYPE_SWITCH){
        return @"device_power";
    }else if (deviceType == DEV_TYPE_CURTAIN){
        return @"device_curtains";
    }else if (deviceType == DEV_TYPE_AIR_COND){
        return @"device_aircon";
    }else{
        return @"";
    }
}
- (NSString *)setDeviceName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == DEV_TYPE_LIGHTBULB) {
        if (serialType == 1) {
            return [NSString stringWithFormat:@"Dimmer%@",[self return3Number]];
        }else if (serialType == 2){
            return [NSString stringWithFormat:@"RGBW%@",[self return3Number]];
        }else if (serialType == 3){
            return [NSString stringWithFormat:@"RGBW%@",[self return3Number]];
        }else{
            return [NSString stringWithFormat:@"Lightbulb%@",[self return3Number]];
        }
        
    }else if (deviceType == DEV_TYPE_SOCKET){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"outlet_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Outlet%@",[self return3Number]];
    }else if (deviceType == DEV_TYPE_SWITCH){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"switch_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Switch%@",[self return3Number]];
    }else if (deviceType == DEV_TYPE_CURTAIN){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"curtain_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Curtain%@",[self return3Number]];
    }else if (deviceType == DEV_TYPE_AIR_COND){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"air_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Air Conditioner%@",[self return3Number]];
    }else{
        return [NSString stringWithFormat:@"Reserved%@",[self return3Number]];
    }
    
}
- (NSString *)getDeviceName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == DEV_TYPE_LIGHTBULB) {
        if (serialType == 1) {
            return [NSString stringWithFormat:@"%@-%@",Localized(@"dimmer_device"),[self return3Number]];
        }else if (serialType == 2){
            return [NSString stringWithFormat:@"%@-%@",Localized(@"rgb_device"),[self return3Number]];
        }else if (serialType == 3){
            return [NSString stringWithFormat:@"%@-%@",Localized(@"rgb_device"),[self return3Number]];
        }else{
            return [NSString stringWithFormat:@"%@-%@",Localized(@"light_device"),[self return3Number]];
        }
        
    }else if (deviceType == DEV_TYPE_SOCKET){
        //        return [NSString stringWithFormat:@"%@%@",Localized(@"outlet_device"),[self return3Number]];
        return [NSString stringWithFormat:@"%@-%@",Localized(@"outlet_device"),[self return3Number]];
    }else if (deviceType == DEV_TYPE_SWITCH){
        //        return [NSString stringWithFormat:@"%@%@",Localized(@"switch_device"),[self return3Number]];
        return [NSString stringWithFormat:@"%@-%@",Localized(@"switch_device"),[self return3Number]];
    }else if (deviceType == DEV_TYPE_CURTAIN){
        //        return [NSString stringWithFormat:@"%@%@",Localized(@"curtain_device"),[self return3Number]];
        return [NSString stringWithFormat:@"%@-%@",Localized(@"curtain_device"),[self return3Number]];
    }else if (deviceType == DEV_TYPE_AIR_COND){
        //        return [NSString stringWithFormat:@"%@%@",Localized(@"air_device"),[self return3Number]];
        return [NSString stringWithFormat:@"%@-%@",Localized(@"air_device"),[self return3Number]];
    }else{
        return [NSString stringWithFormat:@"Reserved%@",[self return3Number]];
    }
    
    
}
- (NSString *)getDeviceTypeName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == DEV_TYPE_LIGHTBULB) {
        if (serialType == 1) {
            return Localized(@"dimmer_device");
        }else if (serialType == 2){
            return Localized(@"rgb_device");
        }else if (serialType == 3){
            return Localized(@"rgb_device");
        }else{
            return Localized(@"light_device");
        }
    }else if (deviceType == DEV_TYPE_SOCKET){
        return Localized(@"outlet_device");
    }else if (deviceType == DEV_TYPE_SWITCH){
        return Localized(@"switch_device");
    }else if (deviceType == DEV_TYPE_CURTAIN){
        return Localized(@"curtain_device");
    }else if (deviceType == DEV_TYPE_AIR_COND){
        return Localized(@"air_device");
    }else{
        return @"预留";
    }
}
-(NSString *)getDeviceType:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == DEV_TYPE_LIGHTBULB) {
        if (serialType == 1) {
            return Localized(@"dimmer_device");
        }else if (serialType == 2){
            return Localized(@"rgb_device");
        }else if (serialType == 3){
            return Localized(@"rgb_device");
        }else{
            return Localized(@"light_device");
        }
    }else if (deviceType == DEV_TYPE_SOCKET){
        return Localized(@"outlet_device");
    }else if (deviceType == DEV_TYPE_SWITCH){
        return Localized(@"switch_device");
    }else if (deviceType == DEV_TYPE_CURTAIN){
        return Localized(@"curtain_device");
    }else if (deviceType == DEV_TYPE_AIR_COND){
        return Localized(@"air_device");
    }else{
        return @"预留";
    }
}
#pragma mark 二进制转十进制
- (int)convertDecimalSystemFromBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (NSInteger i = 0; i < binary.length; i ++){
        
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    return ll;
}

//十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(int)decimal
{
    int num = decimal;//[decimal intValue];
    int remainder = 0;//余数
    int divisor = 0;//除数
    NSString * prepare = @"";
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    if (result.length < 8) {
        NSString *newResult = @"";
        for (int j = 0; j < 8-result.length; j++) {
            newResult = [NSString stringWithFormat:@"%d%@",0,newResult];
        }
        result = [NSString stringWithFormat:@"%@%@",newResult,result];
    }
    return result;
}
- (NSString *)getWeekStringWithDecimal:(NSString *)decimal
{
    NSString *weekResult = @"";
    for (int i = 0; i < decimal.length; i++) {
        NSString *str = [decimal substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"1"]) {
      
            if (i == 0) {
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_sun")];
            }else if (i == 1){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_mon")];
            }else if (i == 2){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_tues")];
            }else if (i == 3){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_wed")];
            }else if (i == 4){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_thur")];
            }else if (i == 5){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_fri")];
            }else if (i == 6){
                weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_sat")];
            }else{
                
            }
        }
    }
    return weekResult;
}
- (NSString *)getWeekTimeWithDecimalSystem:(NSString *)decimal
{
    NSString *weekResult = @"";
    for (int i = 0; i < decimal.length; i++) {
        NSString *str = [decimal substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"1"]) {
            if (i == 0) {
              weekResult = [NSString stringWithFormat:@"%@%@",weekResult,Localized(@"tx_schedular_su")];
            }else if (i == 1){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_mo")];
            }else if (i == 2){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_tue")];
            }else if (i == 3){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_we")];
            }else if (i == 4){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_thu")];
            }else if (i == 5){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_fr")];
            }else if (i == 6){
              weekResult = [NSString stringWithFormat:@"%@ %@",weekResult,Localized(@"tx_schedular_sa")];
            }else{
                
            }
        }
    }
    return weekResult;
}
//返回6位大小写字母和数字
-(NSString *)return3Number{
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:3];
    int num = arc4random()%999+1;
    result = [NSString stringWithFormat:@"%d",num];
    return result;
}
//返回6位大小写字母和数字
-(NSString *)return6LetterAndNumber{
    //定义一个包含数字，大小写字母的字符串
    NSString * numAll = @"0123456789";
    NSString *strAll = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:4];
    for (int i = 0; i < 4; i++)
    {
        if (i == 0 || i == 2) {
            //获取随机数
            NSInteger index = arc4random() % (numAll.length-1);
            char tempStr = [numAll characterAtIndex:index];
            result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
        }else{
            //获取随机数
            NSInteger index = arc4random() % (strAll.length-1);
            char tempStr = [strAll characterAtIndex:index];
            result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
        }
        
       
    }
    
    return result;
}

@end
