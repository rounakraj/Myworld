//
//  NotificationManager.m
//  DMV_Driver
//
//  Created by Alivenet Solution on 28/09/17.
//  Copyright © 2017 Shankar. All rights reserved.
//

#import "NotificationManager.h"
#import "CallViewController.h"
#import "CallingVC.h"
#import <Sinch/Sinch.h>

@interface NotificationManager ()<SINClientDelegate,SINCallClientDelegate,SINManagedPushDelegate>

@end
@implementation NotificationManager

+ (NotificationManager *)sharedController
{
    static NotificationManager *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
    
}

-(void)openViewContorller:(id<SINCall>)param{
    
    if ([param.details isVideoOffered]) {
        
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CallViewController *controller = [main instantiateViewControllerWithIdentifier:@"CallViewController"];
        controller.call=param;
        [_Notification_Delegate openVideo:controller];
    }else{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CallingVC *controller = [main instantiateViewControllerWithIdentifier:@"CallingVC"];
        controller.call=param;
        [_Notification_Delegate openCalling:controller];
    }
}

- (void)initSinchClientWithUserId:(NSString *)userId {
    
    if (!_client) {
        _client = [Sinch clientWithApplicationKey:@"6c4a1382-8f43-48e9-80a9-12ab418aa335"
                                applicationSecret:@"uerzn1M0tEa3d3tEPQosng=="
                                  environmentHost:@"clientapi.sinch.com"
                                           userId:userId];
        
        _client.delegate = self;
        _client.callClient.delegate = self;
        [_client setSupportCalling:YES];
        //[_client setSupportPushNotifications:YES];
        [_client start];
        [_client startListeningOnActiveConnection];
        self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
        self.push.delegate = self;
        [self.push setDesiredPushTypeAutomatically];
    }
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
    NSLog(@"%@", message);
}
    
- (void)managedPush:(id<SINManagedPush>)managedPush didReceiveIncomingPushWithPayload:(NSDictionary *)payload forType:(NSString *)pushType {
    [self handleRemoteNotification:payload];

}
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    if (!_client) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if (userId) {
            [self initSinchClientWithUserId:userId];
        }
    }
    [self.client relayRemotePushNotification:userInfo];
}
    
- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
}
@end

