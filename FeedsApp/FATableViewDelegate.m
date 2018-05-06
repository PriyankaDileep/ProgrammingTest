//
//  FATableViewDelegate.m
//  FeedsApp
//
//  Created by Dileep on 3/5/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

#import "FATableViewDelegate.h"


@interface FATableViewDelegate()<UITableViewDelegate>
@end

@implementation FATableViewDelegate
@synthesize fAServiceManager = _fAServiceManager;

#pragma mark - ==================================
#pragma mark Initial methods for alloc & dealloc
#pragma mark ==================================

- (id)initTableView:(UITableView *)tableView withServiceManger:(FAServiceManager *)service {
    if (self == [super init]) {
        _fAServiceManager = service;
        tableView.delegate = self;
        
    }
    return self;
}

- (void)dealloc {
    _fAServiceManager = nil;
}

#pragma mark - ==================================
#pragma mark Table view delegate method
#pragma mark ==================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}
@end
