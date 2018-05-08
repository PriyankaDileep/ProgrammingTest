//
//  FeedsAppTests.m
//  FeedsAppTests
//
//  Created by Priyanka Dileep on 3/5/18.
//  Copyright © 2018 Priyanka Dileep. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FAServiceManager.h"
#import "FAListViewController.h"

@interface FeedsAppTests : XCTestCase
@property (nonatomic, strong) FAListViewController *obj_faListViewController;
@end

@implementation FeedsAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _obj_faListViewController = [[FAListViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        FAServiceManager *obj_faServiceManager = [[FAServiceManager alloc] init];
        [obj_faServiceManager fetchDataFromJSONFile];
    }];
}
#pragma mark - ==================================
#pragma mark - View loading tests
#pragma mark ==================================

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.obj_faListViewController.tableView, @"TableView not initiated");
}

#pragma mark - ==================================
#pragma mark - UITableView tests
#pragma mark ==================================


- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.obj_faListViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.obj_faListViewController.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.obj_faListViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    //_obj_faListViewcontroller = [[FactsListViewController alloc] init];
    XCTAssertNotNil(_obj_faListViewController.tableView.delegate, @"Table delegate cannot be nil");
}


@end
