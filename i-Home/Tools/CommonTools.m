//
//  CommonTools.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize boundingSize = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(boundingSize.width+0.5f, boundingSize.height+0.5f);
}
@end
