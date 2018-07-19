//
//  ImagePreviewViewController.m
//  MyWorld
//
//  Created by mac on 03/06/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImagePreviewViewController ()

@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.urlStr] placeholderImage:[UIImage imageNamed:@"ic_background"]];
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


@end
