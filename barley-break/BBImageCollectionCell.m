//
//  BBImageCollectionCell.m
//  barley-break
//
//  Created by Иван Ушаков on 07.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBImageCollectionCell.h"

@implementation BBImageCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
    }
    return self;
}
@end
