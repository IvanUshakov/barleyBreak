//
//  BBGameModel.m
//  barley-break
//
//  Created by Иван Ушаков on 08.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBGameModel.h"

@implementation BBGameModel {
    int state[16];
    int clearItem;
}

- (BBGameModel*)init
{
    self = [super init];
    if (self) {
        [self generateStartState];
    }
    return self;
}

- (BOOL)checkFinishState
{
    for (int i = 0; i < 16; i++) {
        if (state[i] != i) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkAction:(int)action
{
    if (action != actionLeft && action != actionRight && action != actionUp && action != actionDown) {
        return NO;
    }
    int item = clearItem + action;
    if (item < 0 || item >= 16) {
        return NO;
    }
    if ((action == actionRight) && ((clearItem + 1) % 4 == 0)) {
        return NO;
    }
    if ((action == actionLeft) && (clearItem % 4 == 0)) {
        return NO;
    }
    return YES;
}

- (void)doAction:(int)action
{
    if ([self checkAction:action]) {
        int secondItem = clearItem + action;
        int swap = state[clearItem];
        state[clearItem] = state[secondItem];
        state[secondItem] = swap;
        clearItem = secondItem;
    }
}

- (void)generateStartState
{
    for (int i = 0; i < 16; i++) {
        state[i] = i;
    }
    clearItem = 15;
    
    int actions[4] = {actionLeft, actionRight, actionUp, actionDown};
    int numSwaps = 1;
    int prevAction = 0;
    while (numSwaps > 0) {
        int action = actions[random() % 4];
        if ([self checkAction:action] && prevAction !=action) {
            [self doAction:action];
            numSwaps--;
            prevAction = action;
        }
    }
}

- (int*)state
{
    return state;
}

- (int)clearItem
{
    return clearItem;
}


@end
