//
//  UIBarButtonItem+extension.m
//  CarKey
//
//  Created by 蒋远路 on 15/8/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "UIBarButtonItem+extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentImage.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//     button.imageEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
