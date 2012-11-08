//
//  UIImage+barleyBreak.m
//  barley-break
//
//  Created by Иван Ушаков on 08.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "UIImage+barleyBreak.h"

@implementation UIImage (barleyBreak)

- (UIImage *)crop:(CGRect)rect
{
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)resize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSArray *)sliceImageTo16Images
{
    float imagesSize = self.size.width / 4;
    CGImageRef cgImage = [self CGImage];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:16];
    
    for(int i = 0; i < 4 ; i++) {
        for (int j = 0; j < 4; j++) {
            CGImageRef tempImage = CGImageCreateWithImageInRect(cgImage, CGRectMake(j * imagesSize, i * imagesSize, imagesSize, imagesSize));
            [result addObject:[UIImage imageWithCGImage:tempImage]];
        }
    }
    return result;
}

@end
