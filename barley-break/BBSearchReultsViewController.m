//
//  BBSearchReultsViewController.m
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBSearchReultsViewController.h"
#import "BBNetworkModel.h"
#import "BBImageCollectionCell.h"
#import "UIImage+barleyBreak.h"
#import "BBGameViewController.h"

@interface BBSearchReultsViewController ()
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imagesData;
@property (strong, nonatomic) NSMutableSet *loadingImages;
@end

@implementation BBSearchReultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.collectionView registerClass:[BBImageCollectionCell class] forCellWithReuseIdentifier:@"BBImageCollectionCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.imagesData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"BBImageCollectionCell" forIndexPath:indexPath];
    if ([self.images[indexPath.row] isKindOfClass:[UIImage class]]) {
        cell.imageView.image = self.images[indexPath.row];
    }
    else if([self.loadingImages containsObject:@(indexPath.row)]) {
        [self loadImageAtIndex:indexPath.row];
    }
    return cell;
}

- (void)setSearchString:(NSString *)searchString
{
    if (_searchString != searchString) {
        _searchString = searchString;
        [BBNetworkModel startSearchingWithText:searchString success:^(NSArray *imagesUrls) {
            [self.imagesData addObjectsFromArray:imagesUrls];
            for (NSInteger i = 0; i < [self.imagesData count]; i++) {
                self.images[i] = [NSNull null];
                [self loadImageAtIndex:i];
            }
            [self.collectionView reloadData];
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

#pragma mark - private

- (void)loadImageAtIndex:(NSInteger)index
{
    [self.loadingImages addObject:@(index)];
    [BBNetworkModel startLoadImageWithURL:[NSURL URLWithString:self.imagesData[index][@"tbUrl"]]
                                  success:^(UIImage *image) {
                                      CGFloat maxSize = MIN(image.size.width, image.size.height);
                                      CGRect crop = CGRectMake((image.size.width - maxSize) / 2.0, (image.size.height - maxSize) / 2.0, maxSize, maxSize);
                                      self.images[index] = [image crop:crop];
                                      BBImageCollectionCell *cell = (BBImageCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                                      cell.imageView.image = self.images[index];
                                      [self.loadingImages removeObject:@(index)];
                                  } failure:^(NSError *error) {
                                      [self.loadingImages removeObject:@(index)];
                                  }];
}

#pragma mark - properties

- (NSMutableArray*)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSMutableArray*)imagesData
{
    if (!_imagesData) {
        _imagesData = [[NSMutableArray alloc] init];
    }
    return _imagesData;
}

- (NSMutableSet*)loadingImages
{
    if (!_loadingImages) {
        _loadingImages = [[NSMutableSet alloc] init];
    }
    return _loadingImages;
}

#pragma mark -

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"BBImageSelectToGame"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        if (![_images[indexPath.row] isKindOfClass:[UIImage class]]) {
            return NO;
        }
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BBImageSelectToGame"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        ((BBGameViewController*)segue.destinationViewController).imageData = self.imagesData[indexPath.row];
    }
}

@end
