//
//  UIImage+barleyBreak.h
//  barley-break
//
//  Created by Иван Ушаков on 08.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (barleyBreak)
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)resize:(CGSize)rect;
- (NSArray *)sliceImageTo16Images;
@end
