//
//  ChatVideoController.h
//  MyWorld
//
//  Created by mac on 06/05/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;

@interface ChatVideoController : UIViewController<AVPlayerViewControllerDelegate>
@property(nonatomic,strong) AVPlayerViewController *playerViewController;
@property(nonatomic,strong) NSString *urlStr;
@property(nonatomic,assign) BOOL isFromMyPost;
@end
