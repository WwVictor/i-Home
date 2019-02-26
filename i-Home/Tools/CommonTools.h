//
//  CommonTools.h
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define PASSWORDCODE @"PASSWORDCODE"
#define KGetRoom [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"room.data"]]
static inline CGFloat TQFontSizeFit(CGFloat value) {
    if ([UIScreen mainScreen].bounds.size.width < 375.0f) return value * 0.9;
    if ([UIScreen mainScreen].bounds.size.width > 375.0f) return value * 1.1;
    return value;
}

static inline CGFloat TQSizeFitW(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.width / 375.0f);
}

static inline CGFloat TQSizeFitH(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.height / 667.0f);
}
@interface CommonTools : NSObject
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize;
@end
