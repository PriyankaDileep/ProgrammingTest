//
//  FAListViewController.m
//  FeedsApp
//
//  Created by Dileep on 3/5/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

#import "FAListViewController.h"
#import "FAConstants.h"

@interface FAListViewController ()
@property(strong, nonatomic) UIRefreshControl *refreshController;
@property(strong, nonatomic) NSArray *arrFacts;
@property(strong, nonatomic) NSOperationQueue *operationQueue;
@end

@implementation FAListViewController
@synthesize refreshController = _refreshController;
@synthesize arrFacts = _arrFacts;
@synthesize operationQueue = _operationQueue;

#pragma mark - ==================================
#pragma mark View Life-cycle
#pragma mark ==================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //-- Tableview's row height & estimated row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    //register the class to use the default UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    //-- Tableview's pull to refresh control
    _refreshController = [[UIRefreshControl alloc] init];
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_9_x_Max) {
        self.tableView.refreshControl = _refreshController;
    } else {
        [self.tableView addSubview:_refreshController];
    }
    [_refreshController addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    //-- NavigationBar right bar item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];
    
    //-- Fetch JSON data from url
    [self fetchDataFromJSONFile];
}

#pragma mark - ==================================
#pragma mark Controls click events
#pragma mark ==================================

- (IBAction)btnRefreshClicked:(id)sender {
    [_refreshController endRefreshing];
    [self fetchDataFromJSONFile];
}

- (IBAction)pullToRefresh:(id)sender {
    [self fetchDataFromJSONFile];
}

#pragma mark - ==================================
#pragma mark Web-service call
#pragma mark ==================================

- (void)fetchDataFromJSONFile {
    //-- Search Query preparation
    NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [JSON_FILE_URL stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
    
    //-- Preparing a url from predefined link string.
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //-- A url request to fetch data in asynchronous manner.
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    //-- Make a web-service call to fetch a data from predefined url request.
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data != nil) {
                //-- As becuase downaloded data contains special characters first of all we have to conver it into String format.
                NSString *latinString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                
                //-- Now create a data from String content with the help of UTF8Encoding
                NSData *jsonData = [latinString dataUsingEncoding:NSUTF8StringEncoding];
                
                if (latinString != nil && jsonData != nil) {
                    NSError *error = nil;
                    //-- Fetch key-value pair object from a JSON data
                    NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                    
                    //-- Display an error if you get at the time of converting a JSON data to an object.
                    if (error != nil) {
                        NSLog(@"JSON Parsing Error due to : %@", [error localizedDescription]);
                    } else {
                        NSLog(@"%@", [dictInfo description]);
                    }
                } else {
                    NSLog(@"An error while encoding data or string conents.");
                }
            } else {
                NSLog(@"No data available to download or an error while downloading a data.");
            }
        } else {
            NSLog(@"%@", [connectionError localizedDescription]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ==================================
#pragma mark Table view data source
#pragma mark ==================================



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arrFacts != nil) {
        return _arrFacts.count;
    } else {
        return 10;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell == nil) {
        
    }
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
