//
//  UIButton+YTExtension.m
//  PrivateTalk
//
//  Created by Heaven on 2016/11/29.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "UIButton+YTExtension.h"
#import "CommonTools.h"
///// 标题默认颜色
//#define kItemTitleColor ([UIColor colorWithWhite:80.0 / 255.0 alpha:1.0])
///// 标题高亮颜色
//#define kItemTitleHighlightedColor ([UIColor colorWithRed:205/255.0 green:50/255.0 blue:50/255.0 alpha:1.0])
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/// 标题默认颜色
#define kItemTitleColor ([UIColor whiteColor])
/// 标题高亮颜色
#define kItemTitleHighlightedColor ([UIColor colorWithWhite:1.0 alpha:0.5])

/// 标题字体大小
#define kItemFontSize   14

@implementation UIButton (YTExtension)

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    
    UIButton *button = [self buttonWithTitle:title normalColor:nil highlightedColor:nil titleFont:nil imageName:imageName backImageName:nil target:target action:action];
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize imageName:(NSString *)imageName backImageName:(NSString *)backImageName {
    
    UIButton *button = [[self alloc] init];
    
    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    // 图片
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSString *highlighted = [NSString stringWithFormat:@"%@_highlighted", imageName];
        if ([UIImage imageNamed:highlighted]) {
            [button setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
        }
        
        NSString *selected = [NSString stringWithFormat:@"%@_selected", imageName];
        if ([UIImage imageNamed:selected]) {
            [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
        }
    }
    
    // 背景图片
    if (backImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        
        NSString *backHighlighted = [NSString stringWithFormat:@"%@_highlighted", backImageName];
        if ([UIImage imageNamed:backHighlighted]) {
            [button setBackgroundImage:[UIImage imageNamed:backHighlighted] forState:UIControlStateHighlighted];
        }
        
        NSString *selected = [NSString stringWithFormat:@"%@_selected", imageName];
        if ([UIImage imageNamed:selected]) {
            [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
        }
    }
    
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backImageName:(NSString *)backImageName {
    
    UIButton *button = [self buttonWithTitle:title normalColor:titleColor highlightedColor:nil titleFont:nil imageName:nil backImageName:backImageName target:nil action:nil];
    
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor titleFont:(UIFont *)titleFont imageName:(NSString *)imageName backImageName:(NSString *)backImageName target:(id)target action:(SEL)action {
    
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    
    // 字体
    if (titleFont != nil) {
        button.titleLabel.font = titleFont;
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:kItemFontSize];
    }
    
    // 标题颜色
    if (normalColor != nil) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:kItemTitleColor forState:UIControlStateNormal];
    }
    
    // 设置标题
    if (title != nil) {
        CGSize size = [CommonTools sizeForString:title font:button.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 44)];
        if (size.width > SCREEN_WIDTH/3) {
            NSString *exchangeTitle = [NSString stringWithFormat:@"返回"];
            [button setTitle:exchangeTitle forState:UIControlStateNormal];
            [button setTitle:exchangeTitle forState:UIControlStateHighlighted];
        }
        else {
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateHighlighted];
        }
    }
    
    if (highlightedColor != nil) {
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    }  else if (highlightedColor == nil && normalColor != nil) {
        [button setTitleColor:[normalColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    } else {
        [button setTitleColor:kItemTitleHighlightedColor forState:UIControlStateHighlighted];
    }
    
    // 图片
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSString *highlighted = [NSString stringWithFormat:@"%@_highlighted", imageName];
        if ([UIImage imageNamed:highlighted]) {
            [button setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
        }
        
        NSString *selected = [NSString stringWithFormat:@"%@_selected", imageName];
        if ([UIImage imageNamed:selected]) {
            [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
        }
        
    }
    
    // 背景图片
    if (backImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        
        NSString *backHighlighted = [NSString stringWithFormat:@"%@_highlighted", backImageName];
        if ([UIImage imageNamed:backHighlighted]) {
            [button setBackgroundImage:[UIImage imageNamed:backHighlighted] forState:UIControlStateHighlighted];
        }
        
        NSString *selected = [NSString stringWithFormat:@"%@_selected", imageName];
        if ([UIImage imageNamed:selected]) {
            [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
        }
    }
    
    [button sizeToFit];
    
    // 监听方法
    if (action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

@end
