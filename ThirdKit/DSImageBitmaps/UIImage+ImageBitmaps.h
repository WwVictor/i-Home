//
//  UIImage+ImageBitmaps.h
//  Pods-DSImageBitmaps
//
//  Created by dasheng on 2018/7/16.
//

#import <UIKit/UIKit.h>

//iOS不支持CMYK，Mac OS X支持CMYK
typedef NS_ENUM(NSInteger, DSImageMode) {
    DSImageModeGray = 1,
    DSImageModeRGBA
};

@interface UIImage (ImageBitmaps)

- (NSArray *)convertToMode:(DSImageMode)mode;

@end
