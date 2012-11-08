//
//  BBNetworkModel.m
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBNetworkModel.h"

static NSString *SearchURL = @"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&imgsz=xxlarge&as_filetype=jpg&q=%@";
static NSString *networkModelErrorDomain = @"com.barleyBreak.networkModel";

typedef enum {
    networkModelErrorCodesCanNotCreateImage = 1,
} networkModelErrorCodes;

@implementation BBNetworkModel

+ (NSOperationQueue*)networkOperationQueue
{
    static NSOperationQueue *_sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedQueue = [[NSOperationQueue alloc] init];
    });
    return _sharedQueue;
}

+ (void)startSearchingWithText:(NSString*)text success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure
{
    NSString *searchURL = [NSString stringWithFormat:SearchURL, [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchURL]
                                             cachePolicy:NSURLCacheStorageAllowed
                                         timeoutInterval:30.0f];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self networkOperationQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   failure(error);
                                   return;
                               }
                               
                               id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                               if (error || [json[@"responseStatus"] integerValue] != 200) {
                                   failure(error);
                                   return;
                               }
                            
                               success(json[@"responseData"][@"results"]);
                           }];
}

+ (void)startLoadImageWithURL:(NSURL*)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0f];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self networkOperationQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   failure(error);
                                   return;
                               }
                            
                               UIImage *image = [[UIImage alloc] initWithData:data];
                               if (!image) {
                                   failure([NSError errorWithDomain:networkModelErrorDomain code:networkModelErrorCodesCanNotCreateImage userInfo:nil]);
                               }
                               
                               success(image);
                           }];
}

+ (void)stopAllConnections
{
    [[self networkOperationQueue] cancelAllOperations];
}

@end
