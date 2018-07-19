//
//  ServerController.m
//  Reunion
//
//  Created by Shankar on 04/20/16.
//  Copyright (c) 2016 Shankar. All rights reserved.
//

#import "ServerController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@implementation ServerController
static ServerController* _sharedServerController;
NSMutableData *appListData ;
NSURLConnection *appListFeedConnection;

+ (ServerController*)sharedController {
    @synchronized(self) {
        if (_sharedServerController == nil) {
            _sharedServerController=[[self alloc] init];
        }
    }
    return _sharedServerController;
}

- (BOOL)checkNetworkStatusWithAlert:(BOOL)shouldAlert {
    
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    BOOL isNetworkAvail = YES;
    switch (internetStatus)
    {
        case NotReachable:
        {
            isNetworkAvail = NO;
            break;
            
        }
        case ReachableViaWiFi:
        {
            isNetworkAvail = YES;
            break;
            
        }
        case ReachableViaWWAN:
        {
            isNetworkAvail = YES;
            break;
        }
    }
    if(isNetworkAvail == NO && shouldAlert == YES) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection!" message:@"Internet connection appears to be offline. Try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    return isNetworkAvail;
}




#pragma mark call services
- (void)callWebServiceGetJsonResponse:(NSString *)string userInfo:(NSMutableDictionary* )userParams withSelector:(SEL)selector delegate:(id)delegate
{
    BOOL isNetwrk =  [[ServerController sharedController] checkNetworkStatusWithAlert:YES];
    
    if (!isNetwrk)
        return;
    
    self.delegate = delegate;
    self.selectorMethod = selector;
    if (![self checkNetworkStatusWithAlert:YES])
    {
        return;
    }
    NSData *postData = [self encodeDictionary:userParams];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:string]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ...
                                          //UI code
                                      
                                      if (error) {
                                          if (error.code == kCFURLErrorNotConnectedToInternet){
                                              // if we can identify the error, we can present a more precise message to the user.
                                              NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"No Connection Error"};
                                              NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                                               code:kCFURLErrorNotConnectedToInternet
                                                                                           userInfo:userInfo];

                                              //[self handleError:noConnectionError];
                                          } else {
                                              // otherwise handle the error generically
                                              //[self handleError:error];
                                          }
                                          
                                      }else{
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"%@", json);
                                              [self.delegate performSelector:self.selectorMethod withObject:json];
                                              if ([[NSThread currentThread] isMainThread]){
                                                  NSLog(@"In main thread--completion handler");
                                              }
                                              else{
                                                  NSLog(@"Not in main thread--completion handler");
                                              }
                                          });
                                          
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    
    
}
- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    
    return [encodedDictionary dataUsingEncoding:NSASCIIStringEncoding];
}



- (void)handleError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{

    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    });
    
}
@end
