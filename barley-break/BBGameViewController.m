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
#import "BBGameModel.h"

@interface BBGameViewController ()
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) BBGameModel *gameModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger time;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL finished;
@end

@implementation BBGameViewController

#pragma mark - properties

- (void)setImageData:(NSDictionary*)imageData
{
    if (_imageData != imageData) {
        _imageData = imageData;
        [BBNetworkModel startLoadImageWithURL:[NSURL URLWithString:_imageData[@"url"]]
                                      success:^(UIImage *image) {
                                          CGFloat minSize = MIN(image.size.width, image.size.height);
                                          CGRect crop = CGRectMake((image.size.width - minSize) / 2.0, (image.size.height - minSize) / 2.0, minSize, minSize);
                                          image = [image crop:crop];
                                          image = [image resize:CGSizeMake(320.0f, 320.0f)];
                                          NSArray *images = [image sliceImageTo16Images];
                                          
                                          int *state = self.gameModel.state;
                                          for (NSInteger i = 0; i < 16; i++) {
                                              UIImageView *imageView = [[UIImageView alloc] initWithImage:images[state[i]]];
                                              imageView.frame = [self rectForImageViewOnIndex:i];
                                              [self.gameView addSubview:imageView];
                                              [self.imageViews addObject:imageView];
                                              
                                              if (state[i] < 15) {
                                                  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                                               action:@selector(tapGestureRecognizerHendler:)];
                                                  recognizer.numberOfTapsRequired = 1;
                                                  recognizer.numberOfTouchesRequired = 1;
                                                  [imageView addGestureRecognizer:recognizer];
                                                  imageView.userInteractionEnabled = YES;
                                              }
                                              else {
                                                  imageView.hidden = YES;
                                              }
                                          }
                                          self.timer = [NSTimer timerWithTimeInterval:1.0f
                                                                               target:self
                                                                             selector:@selector(timerHendler)
                                                                             userInfo:nil
                                                                              repeats:YES];
                                          [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
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

- (CGRect)rectForImageViewOnIndex:(NSInteger)index
{
    NSInteger row = index / 4;
    NSInteger column = index % 4;
    return CGRectMake(column * 80.0f, row * 80.0f, 80.0f, 80.0f);
}

#pragma mark - private

- (void)tapGestureRecognizerHendler:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded && !self.finished) {
        NSInteger index = [self.imageViews indexOfObject:recognizer.view];
        int action = index - [self.gameModel clearItem];
        if ([self.gameModel checkAction:action]) {
            [self.gameModel doAction:action];
            [self.imageViews exchangeObjectAtIndex:index withObjectAtIndex:index - action];
            recognizer.view.frame = [self rectForImageViewOnIndex:index - action];
            self.score++;
            self.scoreLable.text = [NSString stringWithFormat:@"Score: %d", self.score];
            if ([self.gameModel checkFinishState]) {
                [self.timer invalidate];
                self.finished = YES;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"You are win!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

- (void)timerHendler
{
    self.time++;
    self.timeLable.text = [NSString stringWithFormat:@"Time: %d", self.time];
}

#pragma mark - properties

- (BBGameModel*)gameModel
{
    if (!_gameModel) {
        _gameModel = [[BBGameModel alloc] init];
    }
    return _gameModel;
}

- (NSMutableArray*)imageViews
{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] initWithCapacity:15];
    }
    return _imageViews;
}

@end
