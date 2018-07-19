//
//  CallingVC.h
//  CallingDemo
//
//  Created by Shankar Kumar on 24/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "SINUIViewController.h"


@interface CallingVC : SINUIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) NSString *userImg;
@property (weak, nonatomic) IBOutlet UIButton *speakerBtn;

@property (weak, nonatomic) IBOutlet UILabel *remoteUsername;
@property (weak, nonatomic) IBOutlet UILabel *callStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;

@property (nonatomic, readwrite, strong) NSTimer *durationTimer;

@property (nonatomic, readwrite, strong) id<SINCall> call;

- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;
- (IBAction)hangup:(id)sender;
@end

