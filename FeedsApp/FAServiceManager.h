//
//  FAServiceManager.h
//  FeedsApp
//
//  Created by Priyanka Dileep on 3/5/18.
//  Copyright © 2018 Priyanka Dileep. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedsControllerDeleagte;

@protocol FeedsControllerDeleagte
@optional
- (void)connectionDidReceiveFailure:(NSString *)error;
- (void)connectionDidFinishLoading:(NSDictionary *)dictResponseInfo;
@end

@interface FAServiceManager : NSObject
@property(strong, nonatomic) NSArray *arrFeeds;
@property(assign, nonatomic) id<FeedsControllerDeleagte> delegate;
- (void)fetchDataFromJSONFile;
@end
