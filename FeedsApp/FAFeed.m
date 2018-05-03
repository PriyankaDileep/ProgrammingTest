//
//  FAFeed.m
//  FeedsApp
//
//  Created by Dileep on 3/5/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

#import "FAFeed.h"

@implementation FAFeed
@synthesize title = _title;
@synthesize descr = _descr;
@synthesize imageHref = _imageHref;

- (id)initObjectWithDictionary:(NSDictionary *)dictInfo {
    if (self == [super init]) {
        _title = dictInfo[@"title"];
        _descr = dictInfo[@"description"];
        _imageHref = dictInfo[@"imageHref"];
    }
    return self;
}

- (void)dealloc {
    _title = nil;
    _descr = nil;
    _imageHref = nil;
}

@end
