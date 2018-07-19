//
//  ServerController.h
//  Reunion
//
//  Created by Shankar on 04/20/16.
//  Copyright (c) 2016 Shankar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"


@protocol ServerProtocol <NSObject>
- (void)requestFinished:(NSDictionary *)dictionary;
@end

@interface ServerController : NSObject
+ (ServerController*)sharedController;
@property (nonatomic, strong) id<ServerProtocol> delegate;
@property (nonatomic) SEL selectorMethod;
- (void)callWebServiceGetJsonResponse:(NSString *)string userInfo:(NSDictionary *)userParams withSelector:(SEL)selector delegate:(id)delegate;
- (BOOL)checkNetworkStatusWithAlert:(BOOL)shouldAlert;
@end
