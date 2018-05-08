//
//  FATableViewDataSource.h
//  FeedsApp
//
//  Created by Priyanka Dileep  on 3/5/18.
//  Copyright © 2018 Priyanka Dileep . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FAServiceManager.h"

@interface FATableViewDataSource : NSObject
@property(strong, nonatomic) FAServiceManager *fAServiceManager;
- (id)initTableView:(UITableView *)tableView withServiceManger:(FAServiceManager *)service;

@end
