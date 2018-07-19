//
//  CallingVC.m
//  CallingDemo
//
//  Created by Shankar Kumar on 24/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

#import "CallingVC.h"
#import "CallingVC+UI.h"
#import "NotificationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CallingVC ()<SINCallDelegate>
@property (nonatomic, strong) NSLayoutConstraint *aspectRatio;

@property (nonatomic, strong) NSLayoutConstraint *aspectContraint;
@end

@implementation CallingVC

- (id<SINAudioController>)audioController {
    return [[[NotificationManager sharedController] client] audioController];
}

- (void)setCall:(id<SINCall>)call {
    _call = call;
    _call.delegate = self;
}

#pragma mark - UIViewController Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.call direction] == SINCallDirectionIncoming) {
        [self setCallStatusText:@""];
        [self showButtons:kButtonsAnswerDecline];
        [[self audioController] enableSpeaker];
        [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
        [_speakerBtn setImage:[UIImage imageNamed:@"speakeron"] forState:UIControlStateNormal];

    } else {
        [self setCallStatusText:@"calling..."];
        [self showButtons:kButtonsHangup];
        [_speakerBtn setImage:[UIImage imageNamed:@"speakerOff"] forState:UIControlStateNormal];

    }
    self.userImage.contentMode = UIViewContentModeScaleToFill;

    if (_userImg.length > 1) {
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:_userImg] placeholderImage:[UIImage imageNamed:@"ic_profile"]];
    }else{
        [self.userImage setImage:[UIImage imageNamed:@"ic_profile"]];
    }
    
    @try {
        self.userImage.image = [CallingVC imageWithImage : self.userImage.image];
    } @catch (NSException *exception) {
    }
    
    self.userImage.autoresizingMask=UIViewAutoresizingFlexibleHeight;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.remoteUsername.text = [self.call remoteUserId];
}

#pragma mark - Call Actions

- (IBAction)accept:(id)sender {
    [[self audioController] stopPlayingSoundFile];
    [[self audioController] disableSpeaker];
    [self.call answer];
}

- (IBAction)decline:(id)sender {
    [[self audioController] disableSpeaker];
    [self.call hangup];
    [self dismiss];
}

- (IBAction)hangup:(id)sender {
    [self.call hangup];
    [self dismiss];
}

- (void)onDurationTimer:(NSTimer *)unused {
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
    [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call {
    [self setCallStatusText:@"ringing..."];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call {
    [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
    [self showButtons:kButtonsHangup];
    [[self audioController] stopPlayingSoundFile];
}
- (IBAction)SpeakerAction:(UIButton *)sender {
    if ([sender.currentImage isEqual: [UIImage imageNamed:@"speakerOff"]]) {
        [sender setImage:[UIImage imageNamed:@"speakeron"] forState:UIControlStateNormal];
        [[self audioController] enableSpeaker];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"speakerOff"] forState:UIControlStateNormal];
        [[self audioController] disableSpeaker];
        
    }
}
- (void)callDidEnd:(id<SINCall>)call {
    [self dismiss];
    [[self audioController] stopPlayingSoundFile];
    [self stopCallDurationTimer];
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}
+(UIImage*)imageWithImage: (UIImage*) sourceImage
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = screenWidth / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

