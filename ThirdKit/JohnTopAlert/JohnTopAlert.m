//
//  JohnTopAlert.m
//  顶部提示框
//
//  Created by YuanQuanTech on 2016/11/11.
//  Copyright © 2016年 John Lai. All rights reserved.
//

#import "JohnTopAlert.h"
#import "UIColor+Tools.h"

@interface JohnTopAlert ()

@property (nonatomic,strong) UILabel *alertLB;

@property (nonatomic,weak) UIImageView *pointIMGV;

@property (nonatomic,weak) UILabel *pointLB;

@end

@implementation JohnTopAlert

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, -64,[UIScreen mainScreen].bounds.size.width, 64);
        self.alertShowTime = 2.5;
        [UIView transitionWithView:self duration:0.25 options:0 animations:^{
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,32);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(removeAlert) withObject:nil afterDelay:self.alertShowTime];
        }];

       [self createAlert];
    }
    return self;
}

#pragma mark - 基础设置
- (void)createAlert{
    //设置提示图
    self.backgroundColor = [UIColor colorWithHexString:@"008DD4"];
    UIImageView *alertIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20 +(self.frame.size.height - 40)/ 2 , 20, 20)];
    [self addSubview:alertIMGV];
    self.pointIMGV = alertIMGV;
    
    //设置提示信息
    UILabel *alertMsg = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alertIMGV.frame) + 10, 20 +(self.frame.size.height - 20 - 42) / 2, self.frame.size.width - CGRectGetMaxX(alertIMGV.frame) - 10 - 10 - 10, 42)];
    alertMsg.textColor = [UIColor whiteColor];
    alertMsg.textAlignment = NSTextAlignmentLeft;
    alertMsg.font = [UIFont systemFontOfSize:17.f];
    alertMsg.numberOfLines = 2;
    [self addSubview:alertMsg];
    self.pointLB = alertMsg;
    
}

#pragma mark - 根据外部调用个性化显示
- (void)setAlertBgColor:(UIColor *)alertBgColor{
    self.backgroundColor = alertBgColor;
}

- (void)showAlertMessage:(NSString *)msg alertType:(MessageType)type{
    self.pointLB.text = msg;
    if (type == SuccessAlert) {
        self.pointIMGV.image = [UIImage imageNamed:@"bannertips_success"];
    }
    if (type == FailedAlert) {
        self.pointIMGV.image = [UIImage imageNamed:@"bannertips_warning"];
    }
}

#pragma mark -  展示提示框
- (void)alertShow{
   UIWindow *window = [UIApplication sharedApplication].keyWindow;
   [window addSubview:self];
}

#pragma mark - 移除提示框
- (void)removeAlert{
    [UIView transitionWithView:self duration:0.25 options:0 animations:^{
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,-32);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
