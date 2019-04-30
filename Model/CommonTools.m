


//
//  CommonTools.m
//  LongToothIM
//
//  Created by Divella on 2017/12/26.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize;{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize boundingSize = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(boundingSize.width+0.5f, boundingSize.height+0.5f);
}


+ (int)getRandomFourNumbers {
    return [self getRandomNumber:1000 and:9999];
}

+ (int)getRandomNumbers:(NSInteger)count {
    int a = pow(10, count-1);
    int b = pow(10, count)-1;
    return [self getRandomNumber:a and:b];
}


+ (int)getRandomNumber:(int)numberA and:(int)numberB {
    return (int)(numberA + (arc4random() % (numberB - numberA + 1)));
}

+ (NSString *)generateRandomImageName {
    NSInteger avatarId = arc4random_uniform(24)+1;
    NSString *avatatName = [NSString stringWithFormat:@"head_%02ld", (long)avatarId];
    
    return avatatName;
}

+ (NSString *)Capital:(NSString*)sourceString {
    
    NSMutableString *source = [sourceString mutableCopy];
    
    if (source && sourceString.length>0) {
        CFRange range = CFRangeMake(0, 1);
        CFStringTransform((__bridge CFMutableStringRef)source, &range, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)source, &range, kCFStringTransformStripDiacritics, NO);
        NSString *phonetic = source;
        phonetic = [phonetic substringToIndex:1];
        phonetic = [phonetic uppercaseString];
        int temp = [phonetic characterAtIndex:0];
        if (temp < 65 || temp > 122 || (temp > 90 && temp < 97)) {
            //不合法的title
            phonetic = @"#";
        }
        else {
            phonetic = phonetic;
        }
        
        return phonetic;
    }
    else {
        return @"#";
    }
}
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return
//    [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
