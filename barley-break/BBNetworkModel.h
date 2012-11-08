//
//  BBNetworkModel.h
//  barley-break
//
//  Created by Иван Ушаков on 03.11.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNetworkModel : NSObject

+ (void)startSearchingWithText:(NSString*)text success:(void (^)(NSArray *imagesUrls))success failure:(void (^)(NSError *error))failure;
+ (void)startLoadImageWithURL:(NSURL*)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
+ (void)stopAllConnections;

@end
