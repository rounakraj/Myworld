//
//  ImagePreviewViewController.h
//  MyWorld
//
//  Created by mac on 03/06/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(nonatomic,strong) NSString *urlStr;

@end
