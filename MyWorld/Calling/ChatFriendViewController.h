//
//  ViewController.h
//  CallingDemo
//
//  Created by Shankar Kumar on 24/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatFriendViewController : UIViewController
- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSString *isFrom;
@property (strong,nonatomic) NSData *videoData;
@property (strong,nonatomic) NSData *videoThumbnail;
@property (assign,nonatomic) BOOL isKeyboardDone;

@end

