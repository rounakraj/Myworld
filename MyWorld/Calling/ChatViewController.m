//
//  ChatViewController.m
//  Frow
//
//  Created by CodeCube Technologies on 27/10/15.
//  Copyright (c) 2015 CodeCube Technologies. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "HPGrowingTextView.h"
#import "ServerController.h"
#import "AFHTTPSessionManager.h"
#import "CallViewController.h"
#import <Sinch/Sinch.h>
#import "CallingVC.h"
#import "NotificationManager.h"
#import <IQKeyboardManagerSwift/IQKeyboardManagerSwift-Swift.h>
#import "constants.h"
#import "ChatVideoController.h"
#import "ImagePreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@import SVProgressHUD;

@interface ChatViewController() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,HPGrowingTextViewDelegate,UIScrollViewDelegate,SINCallClientDelegate,NotificationDelegate>
{
    NSData *imageMessage;
    UIView *containerView;
    HPGrowingTextView *textView;
    NSTimer *timerCall;
 
}
@property (strong, nonatomic) NSMutableArray *chatArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@end

@implementation ChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTableView];
    self.title=_tittleString;
    self.inputTextFeild.delegate=self;
    self.client.callClient.delegate = self;
    [NotificationManager sharedController].Notification_Delegate = self;
    _titleLabel.text = self.emailID;
}

-(void)viewWillAppear:(BOOL)animated{
     [self requestForPermission];
}

-(void)requestForPermission{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized){
        [self loadDataFromServer];
        timerCall = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats: YES];
    }
    else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized)
            [self loadDataFromServer];
            timerCall = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats: YES];
        }];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    //[IQKeyboardManager sh]
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self addView];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = YES;
    [timerCall invalidate];
    timerCall = nil;
    [self.view endEditing:YES];
    [self sendSetRecentchatServer];
}


-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
}

- (IBAction)userDidTapScreen:(id)sender{
    [self.view resignFirstResponder];
}

-(void)playBtnTapped:(UIButton*)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ChatVideoController *obj = [sb instantiateViewControllerWithIdentifier:@"ChatVideoController"];
    obj.urlStr = [[_chatArray objectAtIndex:sender.tag]objectForKey:@"chatVideo"];
    obj.isFromMyPost = NO;
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)playAudioBtnTapped:(UIButton*)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ChatVideoController *obj = [sb instantiateViewControllerWithIdentifier:@"ChatVideoController"];
    obj.urlStr = [[_chatArray objectAtIndex:sender.tag]objectForKey:@"chatAudio"];
    obj.isFromMyPost = NO;
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)previewImage:(UITapGestureRecognizer*)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ImagePreviewViewController *obj = [sb instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
    obj.urlStr = [[_chatArray objectAtIndex:sender.view.tag]objectForKey:@"chatFile"];
    [self.navigationController pushViewController:obj animated:NO];
}


#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_chatArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.isFrom = @"NormalChat";
    cell.message = [_chatArray objectAtIndex:indexPath.row];
    cell.playButton.tag = indexPath.row;
    cell.audioPlayButton.tag = indexPath.row;
    [cell.playButton addTarget:self action:@selector(playBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.audioPlayButton addTarget:self action:@selector(playAudioBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatFile"] length] > 0){ //image
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewImage:)];
        cell.imgView.tag = indexPath.row;
        cell.imgView.userInteractionEnabled = YES;
        [cell.imgView addGestureRecognizer:tapRecognizer];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
     //UITableViewCell *cell = (UITableViewCell *)[gestureRecognizer view];
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //NSLog(@"%ld",(long)indexPath.row);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        self.chatID = [self.chatArray[indexPath.row] objectForKey:@"chatId"];
        if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatFile"] length] > 0){ // for image
           self.fileName = [self.chatArray[indexPath.row] objectForKey:@"chatFile"];
        }
       if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatTime"] length] > 0){ //for video
           self.fileName = [self.chatArray[indexPath.row] objectForKey:@"chatVideo"];
        }
       [self showDeletePopup];
    }
}

-(void)deleteChat{//:(id)sender {
    NSDictionary *params = @{
                             @"userId":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"chatId":self.chatID
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"deletechats.php"] userInfo:params withSelector:@selector(getSendResponse:) delegate:self];
}

-(void)showDeletePopup{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to delete ?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesBtn = [UIAlertAction
                              actionWithTitle:@"YES"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  [self deleteChat];
                              }];
    
    UIAlertAction *noBtn = [UIAlertAction
                              actionWithTitle:@"NO"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  [self.tableView reloadData];
                            }];
    [alert addAction:yesBtn];
    [alert addAction:noBtn];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeOfText;
    sizeOfText.width=130;
    
    if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatFile"] length] > 0){ // for image
        return 220;
    }
    else if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatTime"] length] > 0){ //for video
        return 220;
    }
    else if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatAudio"] length] > 0){
        return 50 + 20;
    }
    else{ // for text
          sizeOfText.height=[ChatViewController heightForText:[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"] font:[UIFont systemFontOfSize:15.0] withinWidth:sizeOfText.width];
        
        if (sizeOfText.height<44) {
            return 50 + 20;
        }
        else{
            return sizeOfText.height+20;
        }
    }
    /*if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatFile"] length] > 0 ) {
        sizeOfText.height=170;
    }
    else if ([[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"]!=[NSNull null]) {
         sizeOfText.height=[ChatViewController heightForText:[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"] font:[UIFont systemFontOfSize:15.0] withinWidth:sizeOfText.width];
    }
    NSLog(@"sizeOfText.height%f",sizeOfText.height);
    if (sizeOfText.height<44) {
        return 50;
    }
    else{
       return sizeOfText.height+10;
    }*/
 
    //return 220;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Print");
}


+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}


- (void)cameraAction:(id)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self takePhoto];
                                                    }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self selectImageFromGallery];
                                                    }];
    
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self selectVideo];
                                                    }];
    
   UIAlertAction *button4 = [UIAlertAction actionWithTitle:@"Audio" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self recordAudio];
                                                    }];
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button3];
    [alert addAction:button4];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)sendAction:(id)sender {
    //[self resignTextView];
    //Send message to server
    if (textView.text.length>0) {
        NSString *theString = textView.text;
        theString = [theString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        NSLog(@"%@", theString);
        [self sendMessageServer:theString];
        textView.text=@"";
    }
}

- (void)deleteFileFromDocumentDirectory:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removedSuccessFullyAlert show];
    }
    else{
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (id<SINClient>)client {
    return [[NotificationManager sharedController] client];
}

- (IBAction)callAction:(id)sender {
    id<SINCall> call = [self.client.callClient callUserWithId:_emailID];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    CallingVC *controller = [main instantiateViewControllerWithIdentifier:@"CallingVC"];
    controller.call=call;
    [self.navigationController presentViewController:controller animated:true completion:nil];
}

- (IBAction)videoCallAction:(id)sender {
    id<SINCall> call = [self.client.callClient callUserVideoWithId:_emailID];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    CallViewController *controller = [main instantiateViewControllerWithIdentifier:@"CallViewController"];
    controller.call=call;
    [self.navigationController presentViewController:controller animated:true completion:nil];
}
- (void)openCalling:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:true];
    
}

- (void)openVideo:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:true];
    
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

-(void) scrollToTop
{
    if ([self numberOfSectionsInTableView:self.tableView] > 0)
    {
        
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)loadDataFromServer{
    NSDictionary *params = @{
                             @"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"userId2":_userId2,
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"showUserchat.php"] userInfo:params withSelector:@selector(getResponse:) delegate:self];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)recordAudio{
    IQAudioRecorderViewController *controller = [[IQAudioRecorderViewController alloc] init];
    controller.delegate = self;
    controller.title = @"Record";
    controller.allowCropping = YES;
    self.isFrom = @"audio";
    controller.barStyle = UIBarStyleBlack;
    [self presentBlurredAudioRecorderViewControllerAnimated:controller];
}


#pragma mark - IQAudioRecorderViewControllerDelegate
-(void)audioRecorderController:(IQAudioRecorderViewController *)controller didFinishWithAudioAtPath:(NSString *)filePath {
     self.audioData = [NSData dataWithContentsOfFile:filePath];
    [self sendImageDataToServer];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)audioRecorderControllerDidCancel:(IQAudioRecorderViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([self.isFrom isEqualToString:@"video"]) {
         NSURL * URL = [info valueForKey:UIImagePickerControllerMediaURL];
         self.videoData = [[NSData alloc]init];
         self.videoThumbnail = [[NSData alloc]init];
         self.videoData = [NSData dataWithContentsOfURL:URL];
         UIImage *thumbNailImage = [self getThumbnailForVideoNamed:URL];
         self.videoThumbnail =  UIImageJPEGRepresentation(thumbNailImage, 0.5);
         //NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         //NSString *documentdirectory=[path objectAtIndex:0];
         //NSString *name = [URL lastPathComponent];
         //NSString *filePath = [NSString stringWithFormat:[documentdirectory stringByAppendingPathComponent: @"/%@.%@"],name,[name pathExtension]];
         //[data writeToFile:filePath atomically:YES];
    }
    else{
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        imageMessage = [[NSData alloc]init];
        imageMessage = UIImageJPEGRepresentation(image, 0.5);
        /*CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        int maxFileSize = 250*1024;
        NSData *imageData = UIImageJPEGRepresentation(image, compression);
        while ([imageData length] > maxFileSize && compression > maxCompression){
            compression -= 0.1;
            imageMessage = UIImageJPEGRepresentation(image, compression);
        }*/
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self sendImageDataToServer ];
    }];
}

+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *intervalString = [NSString stringWithFormat:@"%f", today];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intervalString doubleValue]];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *orderID = [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:date]];
    return orderID;
    
}


- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSString *text = [growingTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text isEqualToString:@""])
        [self.rightButton setSelected:YES];
    else
        [self.rightButton setSelected:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender{
    //executes when you scroll the scrollView
    //[self resignTextView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetPoint = *targetContentOffset;
    CGPoint currentPoint = scrollView.contentOffset;
    
    if (targetPoint.y > currentPoint.y) {
        NSLog(@"up");
        [self resignTextView];
    }
    else {
        NSLog(@"down");
        //[self resignTextView];

    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // execute when you drag the scrollView
    //[self resignTextView];
}



-(void)addView {
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(50, 5, self.view.frame.size.width-100, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.layer.cornerRadius=5;
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyDone; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"";
    textView.layer.borderColor =  [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    textView.layer.borderWidth = 0.5;

    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
    [containerView addSubview:textView];
    self.leftButton = [[UIButton alloc] init];
    self.leftButton.frame = CGRectMake(10, 0, 40, 40);
    self.leftButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.leftButton setImage:[UIImage imageNamed:@"attach"] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.view.frame.size.width - 50, 5
                               , 50, 30);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    [containerView addSubview:self.leftButton];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    containerView.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
}

-(void)resignTextView{
    [textView resignFirstResponder];
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    [textView resignFirstResponder];
    return YES;
}

-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}


-(void)sendImageDataToServer{
    //[SVProgressHUD show];
    NSDictionary *params = [[NSDictionary alloc]init];
    if ([self.isFrom isEqualToString:@"video"]){
        params = @{@"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                   @"userId2":_userId2};
    }
    else if ([self.isFrom isEqualToString:@"audio"]){
        params = @{@"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                   @"userId2":_userId2};
    }
    else{
        params = @{@"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                   @"userId2":_userId2,
                   @"chatMsg":@""};
    }
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[WEBSERVICE_URL stringByAppendingString:@"setUserchat.php"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([self.isFrom isEqualToString:@"video"]){
            if(self.videoData.length > 0){
                [formData appendPartWithFileData:self.videoThumbnail name:@"thumbVideo" fileName:[NSString stringWithFormat:@"%f%s",[[NSDate date] timeIntervalSince1970],".jpg"] mimeType:@"image/jpeg"];
                [formData appendPartWithFileData:self.videoData name:@"chatVideo" fileName:[NSString stringWithFormat:@"%f%s",[[NSDate date] timeIntervalSince1970],".mov"] mimeType:@"video/mov"];
                self.videoData = nil;
                self.videoThumbnail = nil;
                 [SVProgressHUD show];
            }
        }
        else if ([self.isFrom isEqualToString:@"audio"]){
          if(self.audioData.length > 0){
              [formData appendPartWithFileData:self.audioData name:@"chatAudio" fileName:[NSString stringWithFormat:@"%f%s",[[NSDate date] timeIntervalSince1970],".mp3"] mimeType:@"m4a/mp3"];
              self.audioData = nil;
          }
        }
        else{
            [formData appendPartWithFileData:imageMessage name:@"chatFile" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
            imageMessage = nil;
             [SVProgressHUD show];
        }
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      [SVProgressHUD dismiss];
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          [self loadDataFromServer];
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    [uploadTask resume];
}


-(void)sendMessageServer:(NSString *)message{
    NSDictionary *params = @{
                             @"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"userId2":_userId2,
                             @"chatMsg":message,
                             @"chatFile":@""
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"setUserchat.php"] userInfo:params withSelector:@selector(getSendResponse:) delegate:self];
}

-(void)getSendResponse:(id)data{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
            [self loadDataFromServer];
        }
        else{
            /*UIAlertController * alert=[UIAlertController
                                       alertControllerWithTitle:@"Message" message:[data valueForKey:@"responseMessage"]preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action){
             
             }];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];*/
        }
    }
}

-(void)getResponse:(id)data
{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
            
            self.chatArray= [[NSMutableArray alloc]init];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"alldata %@",data);
            [self.chatArray addObjectsFromArray:[data valueForKey:@"chatList"]];
            
            [self.tableView reloadData];
            //[self scrollToTop];
        }else{
            /*
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
             */
        }
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
//- (void)keyboardWasShown:(NSNotification*)aNotification{
//   /* NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    _tableView.contentInset = contentInsets;
//    _tableView.scrollIndicatorInsets = contentInsets;
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect,  containerView.frame.origin) ) {
//        [_tableView scrollRectToVisible: containerView.frame animated:YES];
//    }*/
//    NSDictionary *keyInfo = [aNotification userInfo];
//    CGRect keyboardFrame = [[keyInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    //CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    //convert it to the same view coords as the tableView it might be occluding
//    keyboardFrame = [self.tableView convertRect:keyboardFrame fromView:nil];
//    //calculate if the rects intersect
//    CGRect intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds);
//    if (!CGRectIsNull(intersect)) {
//        //yes they do - adjust the insets on tableview to handle it
//        //first get the duration of the keyboard appearance animation
//        NSTimeInterval duration = [[keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        // adjust the animation curve - untested
//        NSInteger curve = [aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
//        //change the table insets to match - animated to the same duration of the keyboard appearance
//        [UIView animateWithDuration:duration delay:0.0 options:curve animations: ^{
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
//            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
//        } completion:nil];
//    }
//}

// Called when the UIKeyboardWillHideNotification is sent
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
//    /*UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    _tableView.contentInset = contentInsets;
//    _tableView.scrollIndicatorInsets = contentInsets;*/
//    NSDictionary *keyInfo = [aNotification userInfo];
//    NSTimeInterval duration = [[keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    NSInteger curve = [aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
//    //change the table insets to match - animated to the same duration of the keyboard appearance
//    [UIView animateWithDuration:duration delay:0.0 options:curve animations: ^{
//        self.tableView.contentInset = UIEdgeInsetsZero;
//        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
//    } completion:nil];
//}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void)sendSetRecentchatServer{
    
    NSDictionary *params = @{
                             @"userId1":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"userId2":_userId2,
                             
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"setRecentchat.php"] userInfo:params withSelector:@selector(getRecentSendResponse:) delegate:self];
    
}

-(void)getRecentSendResponse:(id)data
{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
            [self loadDataFromServer];
            
        }else{
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"Message" message:[data valueForKey:@"responseMessage"]preferredStyle:UIAlertControllerStyleAlert];
            
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

@end
