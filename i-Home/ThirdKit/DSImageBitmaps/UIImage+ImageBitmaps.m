//
//  UIImage+ImageBitmaps.m
//  Pods-DSImageBitmaps
//
//  Created by dasheng on 2018/7/16.
//

#import "UIImage+ImageBitmaps.h"

@implementation UIImage (ImageBitmaps)

- (NSArray *)convertToMode:(DSImageMode)mode{
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef context = nil;
    
    // Create a bitmap context to draw the uiimage into
    switch (mode) {
        case DSImageModeRGBA:
            context = [self newBitmapRGBA8ContextFromImage:imageRef];
            break;
        case DSImageModeGray:
            context = [self newBitmapGrayContextFromImage:imageRef];
            break;
        default:
            break;
    }
    
    if(!context) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);
        
        if(newBitmap) {    // Copy the data
            for(int i = 0; i < bufferLength; ++i) {
                newBitmap[i] = bitmapData[i];
            }
        }
        
        free(bitmapData);
        
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    CGContextRelease(context);
    
    switch (mode) {
        case DSImageModeRGBA:{
            NSMutableArray *rowsArray = [NSMutableArray array];
            NSMutableArray *columnsArray = [NSMutableArray array];
            NSMutableArray *pixDataArray = [NSMutableArray array];
            for (int i=0; i<width*height*4; i++) {
                if(i%4 == 0){
                    if ([pixDataArray count] == 4) {
                        [columnsArray addObject:pixDataArray];
                    }
                    pixDataArray = [NSMutableArray array];
                }
                [pixDataArray addObject:[[NSNumber alloc] initWithInteger:newBitmap[i]]];
        
                if (i%(width*4) == 0) {
                    if ([columnsArray count] == width) {
                        [rowsArray addObject:columnsArray];
                    }
                    columnsArray = [NSMutableArray array];
                }
            }
            [columnsArray addObject:pixDataArray];
            [rowsArray addObject:columnsArray];
            return rowsArray;
        }
            break;
        case DSImageModeGray:{
            NSMutableArray *rowsArray = [NSMutableArray array];
            NSMutableArray *pixDataArray = [NSMutableArray array];
            for (int i=0; i<width*height; i++) {
                if (i%(width) == 0) {
                    if ([pixDataArray count] == width) {
                        [rowsArray addObject:pixDataArray];
                    }
                    pixDataArray = [NSMutableArray array];
                }
                [pixDataArray addObject:[[NSNumber alloc] initWithInteger:newBitmap[i]]];
            }
            [rowsArray addObject:pixDataArray];
            return rowsArray;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space Gray\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast); 
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

- (CGContextRef) newBitmapGrayContextFromImage:(CGImageRef) image {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 8;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceGray();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaNone);
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@end
