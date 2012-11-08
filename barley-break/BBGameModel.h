//
//  BBGameModel.h
//  barley-break
//
//  Created by Иван Ушаков on 08.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    actionLeft = -1,
    actionRight = 1,
    actionUp = -4,
    actionDown = 4
} actions;

@interface BBGameModel : NSObject
- (BOOL)checkAction:(int)action;
- (void)doAction:(int)action;
- (BOOL)checkFinishState;
- (int*)state;
- (int)clearItem;
@end
