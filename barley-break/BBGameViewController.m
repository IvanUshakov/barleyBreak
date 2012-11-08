//
//  BBGameViewController.m
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBGameViewController.h"
#import "BBNetworkModel.h"
#import "UIImage+barleyBreak.h"

@interface BBGameViewController ()
@property (weak, nonatomic) NSMutableArray *imageViews;
@end

@implementation BBGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - properties

- (void)setImageData:(NSDictionary*)imageData
{
    if (_imageData != imageData) {
        _imageData = imageData;
        [BBNetworkModel startLoadImageWithURL:[NSURL URLWithString:_imageData[@"url"]]
                                      success:^(UIImage *image) {
                                          image = [image resize:CGSizeMake(320.0f, 320.0f)];
                                          NSArray *images = [image sliceImageTo16Images];
                                          [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                              
                                              NSInteger row = idx / 4;
                                              NSInteger column = idx % 4;
                                              imageView.frame = CGRectMake(column * 80.0f, row * 80.0f, 80.0f, 80.0f);
                                              
                                              [self.gameView addSubview:imageView];
                                              [self.imageViews addObject:imageView];
                                              
                                              if (idx == 14) {
                                                  *stop = YES;
                                              }
                                          }];
                                      } failure:^(NSError *error) {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                                                          message:error.localizedDescription
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"Ok"
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                      }];
    }
}

@end
