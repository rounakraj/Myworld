//
//  AdminChatVC.h
//  MyWorld
//
//  Created by Shankar Kumar on 07/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AdminChatVC : UIViewController
@property (nonatomic, copy) NSString* userId2;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFeild;
@property(nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, copy) NSString* tittleString;
@property (weak, nonatomic) IBOutlet UIImageView *backGraoundImage;
@property (weak, nonatomic) IBOutlet UIToolbar *itemBar;

@end
