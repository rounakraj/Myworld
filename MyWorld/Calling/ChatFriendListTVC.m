//
//  ChatFriendListTVC.m
//  MyWorld
//
//  Created by Shankar Kumar on 27/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import "ChatFriendListTVC.h"

@implementation ChatFriendListTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;

    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0.25f;
    self.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
