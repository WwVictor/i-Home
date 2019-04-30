//
//  UITabBar+Badge.h
//  PrivateTalk
//
//  Created by OTT on 2016/12/23.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BadgeType){
    BadgeStyleRedDot,
    BadgeStyleNumber,
    BadgeStyleNone
};

@interface UITabBar (Badge)

/**
 *设置tab上icon的宽度，用于调整badge的位置
 */
- (void)setTabIconWidth:(CGFloat)width;

/**
 *设置badge的top
 */
- (void)setBadgeTop:(CGFloat)top;

/**
 *设置badge样、数字
 */
- (void)setBadgeStyle:(BadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index;


@end
