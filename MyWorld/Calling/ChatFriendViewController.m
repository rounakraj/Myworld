//
//  ViewController.m
//  CallingDemo
//
//  Created by Shankar Kumar on 24/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

#import "ChatFriendViewController.h"
#import "CallViewController.h"
#import <Sinch/Sinch.h>
#import "CallingVC.h"
#import "NotificationManager.h"
#import "ServerController.h"
#import "ChatViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatFriendListTVC.h"
#import "constants.h"
#import <SwiftQRScanner/SwiftQRScanner-Swift.h>
#import "MyWorld-Swift.h"
#import "DCPathButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChatFriendViewController ()<SINCallClientDelegate,NotificationDelegate,SINCallDelegate,QRScannerCodeDelegate,
DCPathButtonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray *userArray;
    QRCodeScannerController *qrController;
    NSData *imageMessage;
}
@end

@implementation ChatFriendViewController
- (id<SINClient>)client {
    return [[NotificationManager sharedController] client];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.client.callClient.delegate = self;
    NSDictionary *params = @{
                             @"userId":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"getFriends.php"] userInfo:params withSelector:@selector(getResponse:) delegate:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NotificationManager sharedController].Notification_Delegate = self;
    [self configureDCPathButton];
    self.isKeyboardDone = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return userArray.count;
   
}
- (IBAction)addFriendAction:(id)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Friends Source"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"Search By Name" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self searchFriendList:@"searchName"];
                                                    }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Search By Email" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self searchFriendList:@"searchEmail"];

                                                    }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Search in the List" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self sendFriendRequesr];
                                                    }];
    UIAlertAction *button4 = [UIAlertAction actionWithTitle:@"Scan QR Code" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        qrController = [[QRCodeScannerController alloc]init];
                                                        qrController.delegate = self;
                                                        [self presentViewController:qrController animated:true completion:nil];
                                                    }];
    [alert addAction:button0];
    
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button3];
    [alert addAction:button4];

    
    [self presentViewController:alert animated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatFriendListTVC *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.nameLbl.text = [userArray[indexPath.row] valueForKey:@"firstName"];


    cell.userImage.image=[UIImage imageNamed:@"ic_profile"];
    
    if ([userArray[indexPath.row] valueForKey:@"profileImage"]) {
        [cell.userImage sd_setImageWithURL:[userArray[indexPath.row] valueForKey:@"profileImage"] placeholderImage:[UIImage imageNamed:@"ic_profile"]];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [self.client isStarted]) {
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[userArray[indexPath.row]valueForKey:@"emailId"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
                ChatViewController *controller = [main instantiateViewControllerWithIdentifier:@"ChatViewController"];
                controller.userId2 = [userArray[indexPath.row]valueForKey:@"userId"];
                controller.emailID = [userArray[indexPath.row]valueForKey:@"emailId"];
                [self.navigationController pushViewController:controller animated:YES];
            }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            id<SINCall> call = [self.client.callClient callUserWithId:[userArray[indexPath.row]valueForKey:@"emailId"]];
            UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
            CallingVC *controller = [main instantiateViewControllerWithIdentifier:@"CallingVC"];
            controller.call=call;
            controller.userImg=[userArray[indexPath.row] valueForKey:@"profileImage"];
            [self.navigationController presentViewController:controller animated:true completion:nil];
        }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Video Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                id<SINCall> call = [self.client.callClient callUserVideoWithId:[userArray[indexPath.row]valueForKey:@"emailId"]];
                UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
                CallViewController *controller = [main instantiateViewControllerWithIdentifier:@"CallViewController"];
                controller.call=call;
                [self.navigationController presentViewController:controller animated:true completion:nil];
                
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cencel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // OK button tapped.
                
            }]];
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
       
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0;
}



#pragma mark - SINCallClientDelegate

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {

    if ([call.details isVideoOffered]) {

    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    CallViewController *controller = [main instantiateViewControllerWithIdentifier:@"CallViewController"];
    controller.call=call;
    [self.navigationController presentViewController:controller animated:true completion:nil];
    }else{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
        CallingVC *controller = [main instantiateViewControllerWithIdentifier:@"CallingVC"];
        controller.call=call;
        [self.navigationController presentViewController:controller animated:true completion:nil];
    }
}

- (void)openCalling:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:true];

}

- (void)openVideo:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:true];

}
-(void)getResponse:(id)data
{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
           
            userArray = [data valueForKey:@"friendList"];
            [self.tableView reloadData];
        }else{
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"User List" message:[data valueForKey:@"responseMessage"]preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
            
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrCodeScanningDidCompleteWithResultWithResult:(NSString * _Nonnull)result {
    NSLog(@"email:  %@",result);
    [qrController dismissViewControllerAnimated:true completion:nil];
    NSDictionary *params = @{
                             @"userId":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"emailId":result
                             };
     [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"sendfriendRequest.php"] userInfo:params withSelector:@selector(getFriendRequestResponse:) delegate:self];
}

- (void)qrCodeScanningFailedWithErrorWithError:(NSString * _Nonnull)error {
    NSLog(@"email:  %@",error);
    [qrController dismissViewControllerAnimated:true completion:nil];

}

-(void)getFriendRequestResponse:(id)data
{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
            
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"Friend Request" message:[data valueForKey:@"responseMessage"]preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
            
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"Friend Request" message:[data valueForKey:@"responseMessage"]preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
            
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
-(void)sendFriendRequesr {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendsRequestViewController *controller = [main instantiateViewControllerWithIdentifier:@"FriendsRequestViewController"];
    [self.navigationController pushViewController:controller animated:true ];

}
-(void)searchFriendList:(NSString *)search {
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchFriendsViewController *controller = [main instantiateViewControllerWithIdentifier:@"SearchFriendsViewController"];
    controller.searchKey = search;
    [self.navigationController pushViewController:controller animated:true ];

}

-(void)imageMessageSelectFriends{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectFriendsViewController *controller = [main instantiateViewControllerWithIdentifier:@"SelectFriendsViewController"];
    controller.imageData = imageMessage;
    [self.navigationController pushViewController:controller animated:true ];
    
}

-(void)videoMessageSelectFriends{
    
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectFriendsViewController *controller = [main instantiateViewControllerWithIdentifier:@"SelectFriendsViewController"];
    controller.videoesData = self.videoData;
    controller.thumb_nail = self.videoThumbnail;

    [self.navigationController pushViewController:controller animated:true ];
    
}


-(void)textMessageSelectFriends:(NSString *)message{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectFriendsViewController *controller = [main instantiateViewControllerWithIdentifier:@"SelectFriendsViewController"];
    controller.message = message;
    [self.navigationController pushViewController:controller animated:true ];
}


//////////////Folloting button////////////////


- (void)configureDCPathButton {
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab-1"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 itemButton_4,
                                 itemButton_5
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 120.0f;
    
    // Change the DCButton's center
    //
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bottomViewColor = [UIColor blackColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTop;
    
    [self.view addSubview:dcPathButton];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - DCPathButton Delegate

//- (void)pathButton:(DCPathButton *)dcPathButton didUpdateOrientation:(DCPathButtonOrientation)orientation {
    // Update the buttons center to account for the device orientation change.
    //
  //  [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
    //    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
  //  } completion:NULL];
//}

- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    NSLog(@"ItemButton will present");
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap %@ at index : %tu", dcPathButton, itemButtonIndex);
    if(itemButtonIndex==0){
        [self recoreVideo];
    }else if(itemButtonIndex==1){
        [self selectVideo];
    }else if(itemButtonIndex==2){
        [self takePhoto];
    }else if(itemButtonIndex==3){
        [self selectImageFromGallery ];
    }else if(itemButtonIndex==4){
        [self sendMessage];
    }
}

- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    NSLog(@"ItemButton did present");
}

/*-(void)sendMessage{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"MyWorld" message:@"Enter your message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
      alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
     //[alertView textFieldAtIndex:0].delegate = self;
      alertView.delegate = self;
     [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}*/


-(void)sendMessage{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"MyWorld"
                               message:@"Send Message"
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* send = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action){
                          UITextField *textField = alert.textFields[0];
                          NSLog(@"text was %@", textField.text);
                              if (!self.isKeyboardDone && textField.text.length > 0){
                                 [self textMessageSelectFriends:textField.text];
                              }
                              else{
                                  self.isKeyboardDone = NO;
                              }
                        }];
    [alert addAction:send];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"message";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = self;
    }];
    [self presentViewController:alert animated:YES completion:^{
        [alert.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.isKeyboardDone = YES;
    [self.view endEditing:YES];
    return YES;
}

-(void)dismissKeyboard{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
     self.isFrom = @"camera";
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"camera not available");
    }
}

-(void)selectVideo{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
    self.isFrom = @"video";
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) selectImageFromGallery{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    self.isFrom = @"gallery";
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) recoreVideo{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.isFrom = @"video";
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([self.isFrom isEqualToString:@"video"]) {
        NSURL * URL = [info valueForKey:UIImagePickerControllerMediaURL];
        self.videoData = [[NSData alloc]init];
        self.videoThumbnail = [[NSData alloc]init];
        self.videoData = [NSData dataWithContentsOfURL:URL];
        UIImage *thumbNailImage = [self getThumbnailForVideoNamed:URL];
        self.videoThumbnail =  UIImageJPEGRepresentation(thumbNailImage, 0.5);
        [self videoMessageSelectFriends];
    }
    else if([self.isFrom isEqualToString:@"gallery"]){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        imageMessage = [[NSData alloc]init];
        imageMessage = UIImageJPEGRepresentation(image, 0.5);
        [self imageMessageSelectFriends];
       
    } else if([self.isFrom isEqualToString:@"camera"]){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        imageMessage = [[NSData alloc]init];
        imageMessage = UIImageJPEGRepresentation(image, 0.5);
         [self imageMessageSelectFriends];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(UIImage *)getThumbnailForVideoNamed:(NSURL *)videoURL{
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *thumbNailImage = [[UIImage alloc] initWithCGImage:oneRef];
    return thumbNailImage;
}

@end
