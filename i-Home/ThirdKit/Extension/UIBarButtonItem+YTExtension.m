//
//  UIBarButtonItem+YTExtension.m
//  PrivateTalk
//
//  Created by Heaven on 2016/11/29.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "UIBarButtonItem+YTExtension.h"
#import "UIButton+YTExtension.h"

@implementation UIBarButtonItem (YTExtension)

+ (instancetype)barButtonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithTitle:title imageName:imageName target:target action:action];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)barButtonWithTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor imageName:(NSString *)imageName target:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithTitle:title normalColor:titleColor highlightedColor:nil titleFont:titleFont imageName:imageName backImageName:nil target:target action:action];
    [button sizeToFit];
//    button.backgroundColor = [UIColor cyanColor];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)barButtonWithTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor titleFont:(UIFont *)titleFont imageName:(NSString *)imageName backImageName:(NSString *)backImageName target:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithTitle:title normalColor:normalColor highlightedColor:highlightedColor titleFont:titleFont imageName:imageName backImageName:backImageName target:target action:action];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}

@end
