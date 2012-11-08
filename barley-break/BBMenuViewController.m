//
//  BBMenuViewController.m
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBMenuViewController.h"
#import "BBSearchReultsViewController.h"

@interface BBMenuViewController ()

@end

@implementation BBMenuViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BBMenuToSelectImage"]) {
        ((BBSearchReultsViewController*)segue.destinationViewController).searchString = self.searchTextField.text;
    }
}

@end
