//
//  FAListViewController.m
//  FeedsApp
//
//  Created by Dileep on 3/5/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

#import "FAListViewController.h"
#import "FAConstants.h"
#import "AppDelegate.h"
#import "FATableViewDataSource.h"
#import "FATableViewDelegate.h"
#import "FAServiceManager.h"

@interface FAListViewController ()
@property(strong, nonatomic) UIRefreshControl *refreshController;
@property(strong, nonatomic) FATableViewDataSource *faTableviewDatasource;
@property(strong, nonatomic) FATableViewDelegate *faTableviewDelegate;
@property(strong, nonatomic) FAServiceManager *faServiceManager;
@end

@implementation FAListViewController
@synthesize refreshController = _refreshController;
@synthesize faServiceManager = _faServiceManager;
@synthesize faTableviewDatasource = _faTableviewDatasource;
@synthesize faTableviewDelegate = _faTableviewDelegate;


#pragma mark - ==================================
#pragma mark View Life-cycle
#pragma mark ==================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //-- Change status bar style
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //-- NavigationBar right bar item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];
    
    //-- Tableview's row height & estimated row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
        self.tableView.estimatedRowHeight = 110.0;
    } else {
        self.tableView.estimatedRowHeight = 65.0;
    }
    self.tableView.tableFooterView = [UIView new];
    
    //-- Tableview's pull to refresh control
    _refreshController = [[UIRefreshControl alloc] init];
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_9_x_Max) {
        self.tableView.refreshControl = _refreshController;
    } else {
        [self.tableView addSubview:_refreshController];
    }
    [_refreshController addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    //-- Intiate the controller
    FAServiceManager *obj_faServiceManager = [[FAServiceManager alloc] init];
    obj_faServiceManager.delegate = (id)self;
    self.faServiceManager = obj_faServiceManager; //-- Assign a controller
    obj_faServiceManager = nil;
    
    //-- Initiate the datasource for table view & integrate datesource methods with the help of FactController
    _faTableviewDatasource = [[FATableViewDataSource alloc]initTableView:self.tableView withServiceManger:self.faServiceManager];
    //-- Initiate the delegate for table view & integrate delegate methods with the help of FactController
    _faTableviewDelegate = [[FATableViewDelegate alloc]initTableView:self.tableView withServiceManger:self.faServiceManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    _refreshController = nil;
}

#pragma mark - ==================================
#pragma mark FactController Delegate methods
#pragma mark ==================================

- (void)connectionDidReceiveFailure:(NSString *)error {
    self.title = @"";
    [appDelegate displayAnAlertWith:@"Alert !!" andMessage:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshController endRefreshing];
    });
}

- (void)connectionDidFinishLoading:(NSDictionary *)dictResponseInfo {
    self.title = dictResponseInfo[@"title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshController endRefreshing];
        if (self.faServiceManager.arrFeeds != nil && self.faServiceManager.arrFeeds.count > 0) {
            self.tableView.hidden = NO;
        } else {
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
    });
}

#pragma mark - ==================================
#pragma mark Controls click events
#pragma mark ==================================

- (IBAction)btnRefreshClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [_refreshController endRefreshing];
    [self.faServiceManager fetchDataFromJSONFile];
}

- (IBAction)pullToRefresh:(id)sender {
    [_refreshController beginRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [self.faServiceManager fetchDataFromJSONFile];
}




@end
