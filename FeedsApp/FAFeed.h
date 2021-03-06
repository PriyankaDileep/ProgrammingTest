//
//  FAFeed.h
//  FeedsApp
//
//  Created by Priyanka Dileep on 3/5/18.
//  Copyright © 2018 Priyanka Dileep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAFeed : NSObject
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *descr;
@property(copy, nonatomic) NSString *imageHref;
- (id)initObjectWithDictionary:(NSDictionary *)dictInfo;
@end
