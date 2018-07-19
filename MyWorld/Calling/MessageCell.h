//
//  MessageCell.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>


//
// This class build bubble message cells
// for Income or Outgoing messages
//
@interface MessageCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *message;
@property (strong, nonatomic) UIButton *resendButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) NSString *isFrom;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIImageView *bubbleImage;
@property (strong, nonatomic) UIButton *audioPlayButton;
@property (strong, nonatomic) UISlider *slider;

-(void)updateMessageStatus;

//Estimate BubbleCell Height
-(CGFloat)height;

@end
