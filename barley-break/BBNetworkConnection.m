//
//  BBNetworkConnection.m
//  barley-break
//
//  Created by Иван Ушаков on 04.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "BBNetworkConnection.h"

@interface BBNetworkConnection ()
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation BBNetworkConnection

- (BBNetworkConnection*)initWithUrl:(NSURL*)url success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure
{
    self = [super init];
    if (self) {
        self.url = url;
        self.successBlock = success;
        self.failureBlock = failure;
        
        self.connection = [NSURLConnection alloc]
    }
    return self;
}

- (BBNetworkConnection*)initWithUrl:(NSURL *)url
{
    return [self initWithUrl:url success:NULL failure:NULL];
}

+ (BBNetworkConnection*)networkConnectionWithUrl:(NSURL *)url
{
    return [[self alloc] initWithUrl:url];
}

+ (BBNetworkConnection*)networkConnectionWithUrl:(NSURL*)url success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure
{
    return [[self alloc] initWithUrl:url success:success failure:failure];
}

- (void)start
{
    
}

- (void)stop
{
    
}

@end
