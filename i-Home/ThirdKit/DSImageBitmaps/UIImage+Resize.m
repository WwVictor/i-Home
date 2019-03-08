//
//  UIImage+Resize.m
//  DSImageBitmaps
//
//  Created by dasheng on 2018/8/6.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size
{
    size.width = size.width*2;
    size.height = size.height*2;
    CGSize originalsize = [originalImage size];
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        rate = widthRate>heightRate?heightRate:widthRate;
        CGImageRef imageRef = nil;
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        return standardImage;
    }
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}

- (UIImage *)imageByCroppingWithStyle:(XYCropImageStyle)style
{
    CGRect rect;
    switch (style) {
        case XYCropImageStyleLeft:
            rect = CGRectMake(0, 0, self.size.width/2, self.size.height);
            break;
        case XYCropImageStyleCenter:
            rect = CGRectMake(self.size.width/4, 0, self.size.width/2, self.size.height);
            break;
        case XYCropImageStyleRight:
            rect = CGRectMake(self.size.width/2, 0, self.size.width/2, self.size.height);
            break;
        case XYCropImageStyleLeftOneOfThird:
            rect = CGRectMake(0, 0, self.size.width/3, self.size.height);
            break;
        case XYCropImageStyleCenterOneOfThird:
            rect = CGRectMake(self.size.width/3, 0, self.size.width/3, self.size.height);
            break;
        case XYCropImageStyleRightOneOfThird:
            rect = CGRectMake(self.size.width/3*2, 0, self.size.width/3, self.size.height);
            break;
        case XYCropImageStyleLeftQuarter:
            rect = CGRectMake(0, 0, self.size.width/4, self.size.height);
            break;
        case XYCropImageStyleCenterLeftQuarter:
            rect = CGRectMake(self.size.width/4, 0, self.size.width/4, self.size.height);
            break;
        case XYCropImageStyleCenterRightQuarter:
            rect = CGRectMake(self.size.width/4*2, 0, self.size.width/4, self.size.height);
            break;
        case XYCropImageStyleRightQuarter:
            rect = CGRectMake(self.size.width/4*3, 0, self.size.width/4, self.size.height);
            break;
        default:
            break;
    }
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}
- (UIImage *)croppedImageWithRect:(CGRect)bounds {
    if (self.scale > 1.0f) {
        bounds = CGRectMake(bounds.origin.x * self.scale,
                          bounds.origin.y * self.scale,
                          bounds.size.width * self.scale,
                          bounds.size.height * self.scale);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)croppedImageWithPixelRect:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)resizedImageToSize:(CGSize)dstSize{
    return [self resizedImageToSize:dstSize isPixelSize:NO];
}

- (UIImage *)resizedImageToWidth:(CGFloat)width{
    CGFloat height = self.size.height/(self.size.width/width);
    return [self resizedImageToSize:CGSizeMake(width, height)];
}

- (UIImage *)resizedImageToHeight:(CGFloat)height{
    CGFloat width = self.size.width/(self.size.height/height);
    return [self resizedImageToSize:CGSizeMake(width, height)];
}

- (UIImage *)resizedImageToPixelSize:(CGSize)dstSize{
    return [self resizedImageToSize:dstSize isPixelSize:YES];
}

- (UIImage *)resizedImageToPixelWidth:(CGFloat)width{
    CGFloat height = self.size.height/(self.size.width/width);
    return [self resizedImageToPixelSize:CGSizeMake(width, height)];
}

- (UIImage *)resizedImageToPixelHeight:(CGFloat)height{
    CGFloat width = self.size.width/(self.size.height/height);
    return [self resizedImageToPixelSize:CGSizeMake(width, height)];
}

#pragma mark - fix orientation
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark- Util

-(UIImage*)resizedImageToSize:(CGSize)dstSize isPixelSize:(BOOL)isPixelSize
{
    CGImageRef imgRef = self.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    /* Don't resize if we already meet the required destination size. */
    if (CGSizeEqualToSize(srcSize, dstSize)) {
        return self;
    }
    CGFloat scaleRatio = dstSize.width / srcSize.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight: //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    /////////////////////////////////////////////////////////////////////////////
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, isPixelSize?1:self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    CGContextConcatCTM(context, transform);
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
