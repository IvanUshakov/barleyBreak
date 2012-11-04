//
//  BBNetworkConnection.h
//  barley-break
//
//  Created by Иван Ушаков on 04.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNetworkConnection : NSObject <NSURLConnectionDelegate>
@property (nonatomic, copy) void (^successBlock)(NSArray *imagesUrls);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, strong) NSURL *url;

- (BBNetworkConnection*)initWithUrl:(NSURL*)url success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure;
- (BBNetworkConnection*)initWithUrl:(NSURL *)url;

+ (BBNetworkConnection*)networkConnectionWithUrl:(NSURL *)url;
+ (BBNetworkConnection*)networkConnectionWithUrl:(NSURL*)url success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure;

- (void)start;
- (void)stop;

@end
