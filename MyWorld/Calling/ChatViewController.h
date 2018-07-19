//
//  ChatViewController.h
//  Frow
//
//  Created by CodeCube Technologies on 27/10/15.
//  Copyright (c) 2015 CodeCube Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQAudioRecorderViewController.h"

@interface ChatViewController : UIViewController<IQAudioRecorderViewControllerDelegate>
@property (nonatomic, copy) NSString* userId2;
@property (nonatomic, copy) NSString* emailID;
@property (nonatomic, copy) NSString* chatID;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backAction;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFeild;
@property(nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, copy) NSString* tittleString;
@property (weak, nonatomic) IBOutlet UIImageView *backGraoundImage;
@property (weak, nonatomic) IBOutlet UIToolbar *itemBar;
@property (weak, nonatomic) NSString *isFrom;
@property (strong,nonatomic) NSData *videoData;
@property (strong,nonatomic) NSData *audioData;
@property (strong,nonatomic) NSData *videoThumbnail;
@property (weak, nonatomic) NSString *fileName;
- (IBAction)cameraAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)callAction:(id)sender;
- (IBAction)videoCallAction:(id)sender;

@end
