//
//  BBGameViewController.h
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBGameViewController : UIViewController
@property (strong, nonatomic) NSDictionary *imageData;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@end
