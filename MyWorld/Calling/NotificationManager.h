//
//  NotificationManager.h
//  DMV_Driver
//
//  Created by Alivenet Solution on 28/09/17.
//  Copyright © 2017 Shankar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sinch/Sinch.h>

@protocol NotificationDelegate <NSObject>
-(void)openCalling:(UIViewController *)controller;
-(void)openVideo:(UIViewController *)controller;

@end

@interface NotificationManager : NSObject
+ (NotificationManager*)sharedController;
@property (strong, nonatomic) id<SINClient> client;
- (void)initSinchClientWithUserId:(NSString *)userId;

-(void)openViewContorller:(id<SINCall>)param;
@property (nonatomic, strong) id<NotificationDelegate> Notification_Delegate;
@property (nonatomic, readwrite, strong) id<SINManagedPush> push;

@end

