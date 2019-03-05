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
    if([model.type intValue] == 5 && [model.serial_type intValue] == 1){
        return DimmerTabel;
    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 4){
        return BrightTempTabel;
    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 2){
        return BrightRBGTabel;
    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 3){
        return RGBTabel;
    }else if ([model.type intValue] == 7 ){
        return SocketTabel;
    }else if ([model.type intValue] == 8){
        return SwitchTabel;
    }else if ([model.type intValue] == 13 || [model.type intValue] == 14){
        return CurtainTabel;
    }else if ([model.type intValue] == 21){
        return AirCondiTabel;
    }else{
        return nil;
    }
}

- (NSString *)getDeviceIcon:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == ACCESSORY_CATEGORY_UNKNOWN) {
        
    }else if (deviceType == ACCESSORY_CATEGORY_OTHER){
//        return @"device_aircon";
    }else if (deviceType == ACCESSORY_CATEGORY_BRIDGE){
//        return @"device_aircon";
    }else if (deviceType == ACCESSORY_CATEGORY_FAN){
//        return @"device_aircon";
    }else if (deviceType == ACCESSORY_CATEGORY_GARAGE){
//        return @"device_aircon";
    }else if (deviceType == ACCESSORY_CATEGORY_LIGHTBULB){
        if (serialType == 1) {
            return @"device_light_sensor";
        }else if (serialType == 2){
            return @"device_rgb";
        }else if (serialType == 3){
            return @"device_rgb";
        }else{
            return @"device_light_bulb";
        }
    }else if (deviceType == ACCESSORY_CATEGORY_DOORLOCK){
        return @"device_doorlock";
    }else if (deviceType == ACCESSORY_CATEGORY_OUTLET){
        return @"device_socket";
    }else if (deviceType == ACCESSORY_CATEGORY_SWITCH){
        return @"device_power";
    }else if (deviceType == ACCESSORY_CATEGORY_THERMOSTAT){
        return @"device_thermometer";
    }else if (deviceType == ACCESSORY_CATEGORY_SENSOR){
        return @"device_sensor";
    }else if (deviceType == ACCESSORY_CATEGORY_SECURITY_SYSTEM){
        return @"device_sensor";
    }else if (deviceType == ACCESSORY_CATEGORY_DOOR){
        
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW){
        return @"device_curtains";
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW_COVER){
        return @"device_curtains";
    }else if (deviceType == ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH){
        return @"device_power";
    }else if (deviceType == ACCESSORY_CATEGORY_RANGE_EXTENDER){
        
    }else if (deviceType == ACCESSORY_CATEGORY_IP_CAMERA){
        return @"device_camera";
    }else if (deviceType == ACCESSORY_CATEGORY_VIDEO){
        return @"device_camera";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_PURIFIER){
        return @"device_gas_sensor";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HEATER){
        return @"device_temperature";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_CONDITIONER){
        return @"device_aircon";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HUMIDIFIER){
        return @"device_water";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER){
        return @"device_fire_sensor1";
    }else{
        
    }
    return @"12";
}
- (NSString *)setDeviceName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == ACCESSORY_CATEGORY_UNKNOWN) {
        return [NSString stringWithFormat:@"Unknown%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_OTHER){
        return [NSString stringWithFormat:@"Other%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_BRIDGE){
        return [NSString stringWithFormat:@"Bridge%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_FAN){
        return [NSString stringWithFormat:@"Fan%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_GARAGE){
        return [NSString stringWithFormat:@"Garage%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_LIGHTBULB){
        if (serialType == 1) {
//            return [NSString stringWithFormat:@"%@%@",Localized(@"dimmer_device"),[self return3Number]];
            return [NSString stringWithFormat:@"Dimmer%@",[self return3Number]];
        }else if (serialType == 2){
//            return [NSString stringWithFormat:@"%@%@",Localized(@"light_device"),[self return3Number]];
//            return [NSString stringWithFormat:@"Lightbulb%@",[self return3Number]];
            return [NSString stringWithFormat:@"RGBW%@",[self return3Number]];
        }else if (serialType == 3){
//            return [NSString stringWithFormat:@"%@%@",Localized(@"rgb_device"),[self return3Number]];
            return [NSString stringWithFormat:@"RGBW%@",[self return3Number]];
        }else{
//            return [NSString stringWithFormat:@"%@%@",Localized(@"light_device"),[self return3Number]];
            return [NSString stringWithFormat:@"Lightbulb%@",[self return3Number]];
            
        }
    }else if (deviceType == ACCESSORY_CATEGORY_DOORLOCK){
        return [NSString stringWithFormat:@"Door Lock%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_OUTLET){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"outlet_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Outlet%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SWITCH){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"switch_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Switch%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_THERMOSTAT){
        return [NSString stringWithFormat:@"Thermostat%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SENSOR){
        return [NSString stringWithFormat:@"Sensor%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SECURITY_SYSTEM){
        return [NSString stringWithFormat:@"Security System%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_DOOR){
        return [NSString stringWithFormat:@"Door%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"curtain_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Curtain%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW_COVER){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"curtain_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Curtain%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH){
        return [NSString stringWithFormat:@"Programmable Switch%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_RANGE_EXTENDER){
        return [NSString stringWithFormat:@"Range Extender%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_IP_CAMERA){
        return [NSString stringWithFormat:@"IP Camera%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_VIDEO){
        return [NSString stringWithFormat:@"Video%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_PURIFIER){
        return [NSString stringWithFormat:@"Air Purifier%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HEATER){
        return [NSString stringWithFormat:@"Air Heater%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_CONDITIONER){
//        return [NSString stringWithFormat:@"%@%@",Localized(@"air_device"),[self return3Number]];
        return [NSString stringWithFormat:@"Air Conditioner%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HUMIDIFIER){
        return [NSString stringWithFormat:@"Air Humidifier%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER){
        return [NSString stringWithFormat:@"Air Dehumidifier%@",[self return3Number]];
    }else{
        return [NSString stringWithFormat:@"Reserved%@",[self return3Number]];
    }
    
}
- (NSString *)getDeviceName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == ACCESSORY_CATEGORY_UNKNOWN) {
        return [NSString stringWithFormat:@"Unknown-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_OTHER){
        return [NSString stringWithFormat:@"Other-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_BRIDGE){
        return [NSString stringWithFormat:@"Bridge-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_FAN){
        return [NSString stringWithFormat:@"Fan-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_GARAGE){
        return [NSString stringWithFormat:@"Garage-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_LIGHTBULB){
        if (serialType == 1) {
           return [NSString stringWithFormat:@"%@-%@",Localized(@"dimmer_device"),[self return3Number]];
        }else if (serialType == 2){
//         return [NSString stringWithFormat:@"%@-%@",Localized(@"light_device"),[self return3Number]];
            return [NSString stringWithFormat:@"%@-%@",Localized(@"rgb_device"),[self return3Number]];
        }else if (serialType == 3){
            return [NSString stringWithFormat:@"%@-%@",Localized(@"rgb_device"),[self return3Number]];
            
        }else{
          return [NSString stringWithFormat:@"%@-%@",Localized(@"light_device"),[self return3Number]];
            
        }
    }else if (deviceType == ACCESSORY_CATEGORY_DOORLOCK){
        return [NSString stringWithFormat:@"Door Lock-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_OUTLET){
        return [NSString stringWithFormat:@"%@-%@",Localized(@"outlet_device"),[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SWITCH){
        return [NSString stringWithFormat:@"%@-%@",Localized(@"switch_device"),[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_THERMOSTAT){
        return [NSString stringWithFormat:@"Thermostat-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SENSOR){
        return [NSString stringWithFormat:@"Sensor-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_SECURITY_SYSTEM){
        return [NSString stringWithFormat:@"Security System-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_DOOR){
        return [NSString stringWithFormat:@"Door-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW){
        return [NSString stringWithFormat:@"%@-%@",Localized(@"curtain_device"),[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW_COVER){
        return [NSString stringWithFormat:@"%@-%@",Localized(@"curtain_device"),[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH){
        return [NSString stringWithFormat:@"Programmable Switch-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_RANGE_EXTENDER){
        return [NSString stringWithFormat:@"Range Extender-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_IP_CAMERA){
        return [NSString stringWithFormat:@"IP Camera-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_VIDEO){
        return [NSString stringWithFormat:@"Video-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_PURIFIER){
        return [NSString stringWithFormat:@"Air Purifier-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HEATER){
        return [NSString stringWithFormat:@"Air Heater-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_CONDITIONER){
        return [NSString stringWithFormat:@"%@-%@",Localized(@"air_device"),[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HUMIDIFIER){
        return [NSString stringWithFormat:@"Air Humidifier-%@",[self return3Number]];
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER){
        return [NSString stringWithFormat:@"Air Dehumidifier-%@",[self return3Number]];
    }else{
       return [NSString stringWithFormat:@"Reserved-%@",[self return3Number]];
    }
    
}
- (NSString *)getDeviceTypeName:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == ACCESSORY_CATEGORY_UNKNOWN) {
        return @"未知";
    }else if (deviceType == ACCESSORY_CATEGORY_OTHER){
        return @"其他";
    }else if (deviceType == ACCESSORY_CATEGORY_BRIDGE){
        return @"桥接器";
    }else if (deviceType == ACCESSORY_CATEGORY_FAN){
        return @"风扇";
    }else if (deviceType == ACCESSORY_CATEGORY_GARAGE){
        return @"车库";
    }else if (deviceType == ACCESSORY_CATEGORY_LIGHTBULB){
        if (serialType == 1) {
            return Localized(@"dimmer_device");
        }else if (serialType == 2){
            return Localized(@"light_device");
        }else if (serialType == 4){
            return Localized(@"light_device");
        }else{
            return Localized(@"rgb_device");
        }
    }else if (deviceType == ACCESSORY_CATEGORY_DOORLOCK){
        return @"门锁";
    }else if (deviceType == ACCESSORY_CATEGORY_OUTLET){
        
        return Localized(@"outlet_device");
    }else if (deviceType == ACCESSORY_CATEGORY_SWITCH){
        return Localized(@"switch_device");
    }else if (deviceType == ACCESSORY_CATEGORY_THERMOSTAT){
        return @"恒温器";
    }else if (deviceType == ACCESSORY_CATEGORY_SENSOR){
        return @"传感器";
    }else if (deviceType == ACCESSORY_CATEGORY_SECURITY_SYSTEM){
        return @"安全系统";
    }else if (deviceType == ACCESSORY_CATEGORY_DOOR){
        return @"门";
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW){
        
        return Localized(@"curtain_device");
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW_COVER){
        return Localized(@"curtain_device");
    }else if (deviceType == ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH){
        return @"安全系统";
    }else if (deviceType == ACCESSORY_CATEGORY_RANGE_EXTENDER){
        return @"增程器";
    }else if (deviceType == ACCESSORY_CATEGORY_IP_CAMERA){
        return @"网络摄像机";
    }else if (deviceType == ACCESSORY_CATEGORY_VIDEO){
        return @"录像";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_PURIFIER){
        return @"空气净化器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HEATER){
        return @"空气加热器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_CONDITIONER){
        return Localized(@"air_device");
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HUMIDIFIER){
        return @"空气增湿器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER){
        return @"空气干燥器";
    }else{
        return @"预留";
    }
    
}
-(NSString *)getDeviceType:(int)deviceType andSerialType:(int)serialType
{
    if (deviceType == ACCESSORY_CATEGORY_UNKNOWN) {
        return @"未知";
    }else if (deviceType == ACCESSORY_CATEGORY_OTHER){
        return @"其他";
    }else if (deviceType == ACCESSORY_CATEGORY_BRIDGE){
        return @"桥接器";
    }else if (deviceType == ACCESSORY_CATEGORY_FAN){
        return @"风扇";
    }else if (deviceType == ACCESSORY_CATEGORY_GARAGE){
        return @"车库";
    }else if (deviceType == ACCESSORY_CATEGORY_LIGHTBULB){
        if (serialType == 1) {
            return Localized(@"dimmer_device");
        }else if (serialType == 2){
            return Localized(@"light_device");
        }else if (serialType == 4){
            return Localized(@"light_device");
        }else{
            return Localized(@"rgb_device");
        }
    }else if (deviceType == ACCESSORY_CATEGORY_DOORLOCK){
        return @"门锁";
    }else if (deviceType == ACCESSORY_CATEGORY_OUTLET){
        return Localized(@"outlet_device");
    }else if (deviceType == ACCESSORY_CATEGORY_SWITCH){
        return Localized(@"switch_device");
    }else if (deviceType == ACCESSORY_CATEGORY_THERMOSTAT){
        return @"恒温器";
    }else if (deviceType == ACCESSORY_CATEGORY_SENSOR){
        return @"传感器";
    }else if (deviceType == ACCESSORY_CATEGORY_SECURITY_SYSTEM){
        return @"安全系统";
    }else if (deviceType == ACCESSORY_CATEGORY_DOOR){
        return @"门";
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW){
        return Localized(@"curtain_device");
    }else if (deviceType == ACCESSORY_CATEGORY_WINDOW_COVER){
        return Localized(@"curtain_device");
    }else if (deviceType == ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH){
        return @"安全系统";
    }else if (deviceType == ACCESSORY_CATEGORY_RANGE_EXTENDER){
        return @"增程器";
    }else if (deviceType == ACCESSORY_CATEGORY_IP_CAMERA){
        return @"网络摄像机";
    }else if (deviceType == ACCESSORY_CATEGORY_VIDEO){
        return @"录像";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_PURIFIER){
        return @"空气净化器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HEATER){
        return @"空气加热器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_CONDITIONER){
        return Localized(@"air_device");
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_HUMIDIFIER){
        return @"空气增湿器";
    }else if (deviceType == ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER){
        return @"空气干燥器";
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
