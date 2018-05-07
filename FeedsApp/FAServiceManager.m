//
//  FAServiceManager.m
//  FeedsApp
//
//  Created by Priyanka Dileep on 3/5/18.
//  Copyright © 2018 Priyanka Dileep. All rights reserved.
//

#import "FAServiceManager.h"
#import "FAConstants.h"
#import "FAFeed.h"

@interface FAServiceManager ()
@property(strong, nonatomic) NSURLConnection *connection;
@property(strong, nonatomic) NSMutableData *data;
@property(strong, nonatomic) NSURLResponse *response;
@end

@implementation FAServiceManager
@synthesize arrFeeds = _arrFeeds;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize response = _response;
@synthesize delegate = _delegate;


- (id)init{
    if (self == [super init]) {
        _arrFeeds = [NSArray array];
    }
    return self;
}

- (void)setarrFeeds:(NSArray *)arrFeeds {
    
    _arrFeeds = arrFeeds;
       
}

-(void) dealloc {
    if (_arrFeeds) {
        _arrFeeds = nil;
    }
}
#pragma mark - ==================================
#pragma mark User-defined methods
#pragma mark ==================================

- (void)resetProperties {
    //-- Remove the old data prior making a web-service call
    _data = nil;
    //-- Remove the old response prior making a web-service call
    _response = nil;
    //-- Cancel the previous operation prior starting a new operation
    if (_connection) {
        [_connection cancel];
        //-- Un-Schedule the run loop for connection
        [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _connection = nil;
    }
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
    
    //-- To reset the web-service related values
    [self resetProperties];
    
    //-- To initiate the connection object.
    _connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    //-- Schedule the run loop for connection
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //-- Start after initiation
    [_connection start];
}


#pragma mark - ==================================
#pragma mark NSURLConnection delegate functions
#pragma mark ==================================

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //-- To reset the web-service related values
    [self resetProperties];
    [_delegate connectionDidReceiveFailure: [error localizedDescription]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //-- Create mutable data once the response received.
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    //-- Cache the response object for later use in ConnectionDidFinishLoading.
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //-- Append the data received from server.
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_response && ((NSHTTPURLResponse *)_response).statusCode == 200) {
        //-- As becuase downaloded data contains special characters first of all we have to conver it into String format.
        NSString *latinString = [[NSString alloc] initWithData:_data encoding:NSISOLatin1StringEncoding];
        
        //-- Now create a data from String content with the help of UTF8Encoding
        NSData *jsonData = [latinString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (latinString != nil && jsonData != nil) {
            NSError *error = nil;
            //-- Fetch key-value pair object from a JSON data
            NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            //-- Display an error if you get at the time of converting a JSON data to an object.
            if (error != nil) {
                //-- To reset the web-service related values
                [self resetProperties];
                [_delegate connectionDidReceiveFailure: [NSString stringWithFormat:@"JSON Parsing Error due to : %@", [error localizedDescription]]];
            } else {
                NSLog(@"%@", [dictInfo description]);
                if (_arrFeeds) {
                    _arrFeeds = nil;
                }
                NSArray *arrTmp = [NSArray arrayWithArray:dictInfo[@"rows"]];
                [arrTmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FAFeed *obj_feed = [[FAFeed alloc]initObjectWithDictionary:obj];
                    if (!_arrFeeds) {
                        _arrFeeds = [[NSArray alloc] initWithObjects:obj_feed, nil];
                    } else {
                        _arrFeeds = [_arrFeeds arrayByAddingObject:obj_feed];
                    }
                }];
                [_delegate connectionDidFinishLoading:dictInfo];
                //-- To reset the web-service related values
                [self resetProperties];
            }
        } else {
            //-- To reset the web-service related values
            [self resetProperties];
            [_delegate connectionDidReceiveFailure:@"An error while manipulating data or string conents."];
        }
    } else {
        //-- To reset the web-service related values
        [self resetProperties];
        if (_data) {
            //-- As becuase downaloded data, first of all, we have to convert it into String format.
            NSString *errorMessage = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
            [_delegate connectionDidReceiveFailure:errorMessage];
        } else {
            [_delegate connectionDidReceiveFailure:@"No data available to download or an error while downloading a data."];
        }
    }
}



@end
