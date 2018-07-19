//
//  ChatVideoController.m
//  MyWorld
//
//  Created by mac on 06/05/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import "ChatVideoController.h"

@interface ChatVideoController (){
    AVPlayer *player;
    UIButton *playBtn;
}
@end

@implementation ChatVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playVideo];
    //[self playVideo1];
}

-(void)playVideo{
    //NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    NSURL *videoURL = [NSURL URLWithString:self.urlStr];
    player = [AVPlayer playerWithURL:videoURL];
    self.playerViewController = [AVPlayerViewController new];
    self.playerViewController.player = player;
    [self.playerViewController setVideoGravity:AVLayerVideoGravityResize];
    if (self.isFromMyPost){
           [self.playerViewController.view setFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height -64)];
    }
    else{
         [self.playerViewController.view setFrame:CGRectMake(self.view.frame.origin.x,64, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
    }

    [self.view addSubview:self.playerViewController.view];
}

-(void)playVideo1{
    //NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    NSURL *videoURL = [NSURL URLWithString:self.urlStr];
    player = [AVPlayer playerWithURL:videoURL];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*0.4)];
    //containerView.backgroundColor = [UIColor orangeColor];
    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = containerView.bounds;
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [playerLayer setVideoGravity:AVLayerVideoGravityResize];
    [containerView.layer addSublayer:playerLayer];
    [self.view addSubview:containerView];
    
    playBtn = [[UIButton alloc]initWithFrame:CGRectMake(containerView.frame.size.width*0.5-25, containerView.frame.size.height*0.5-25 + 64, 50, 50)];
    playBtn.backgroundColor = [UIColor greenColor];
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

-(void)playBtnTapped:(UIButton*)sender{
    if (player.timeControlStatus == AVPlayerTimeControlStatusPlaying){
        playBtn.backgroundColor = [UIColor greenColor];
        [playBtn setTitle:@"Play" forState:UIControlStateNormal];
        [player pause];
    }
    else{
        playBtn.backgroundColor = [UIColor redColor];
        [playBtn setTitle:@"Pause" forState:UIControlStateNormal];
        [player play];
    }
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
