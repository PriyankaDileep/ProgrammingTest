//
//  AppDelegate.h
//  FeedsApp
//
//  Created by Dileep on 3/5/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;//-- Application Main Window to represent the entire application views
@property (strong, nonatomic) UINavigationController *navigationController; //-- Applicataio Main Navigation Controller

//-- A function to display alert
- (void)displayAnAlertWith:(NSString *)title andMessage:(NSString *)message;

@end

