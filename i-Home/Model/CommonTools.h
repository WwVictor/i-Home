//
//  CommonTools.h
//  LongToothIM
//
//  Created by Divella on 2017/12/26.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@interface CommonTools : NSObject

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize;

+ (int)getRandomFourNumbers;
+ (int)getRandomNumbers:(NSInteger)count;
+ (NSString *)generateRandomImageName;

+ (NSString *)Capital:(NSString*)sourceString;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
