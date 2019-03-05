//
//  JohnAlertManager.m
//  顶部提示框
//
//  Created by YuanQuanTech on 2016/11/11.
//  Copyright © 2016年 John Lai. All rights reserved.
//

#import "JohnAlertManager.h"
#import "JohnTopAlert.h"
#import "UIColor+Tools.h"

@implementation JohnAlertManager

+ (void)showSuccessAlert:(NSString *)msg{
    JohnTopAlert *alert = [[JohnTopAlert alloc]init];
    [alert showAlertMessage:msg alertType:SuccessAlert];
    /**可在此定制背景颜色和显示时间**/
     //alert.alertBgColor = [UIColor colorWithHexString:NavBgColor];
     //alert.alertShowTime = 3.f;
    [alert alertShow];
}

+ (void)showFailedAlert:(NSString *)msg{
    JohnTopAlert *alert = [[JohnTopAlert alloc]init];
    [alert showAlertMessage:msg alertType:FailedAlert];
     alert.alertBgColor = [UIColor colorWithHexString:@"008DD4"];
     //alert.alertShowTime = 3.f;
    [alert alertShow];
}

@end
