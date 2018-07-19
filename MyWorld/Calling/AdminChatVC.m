//
//  AdminChatVC.m
//  MyWorld
//
//  Created by Shankar Kumar on 07/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

#import "AdminChatVC.h"
#import "MessageCell.h"
#import "HPGrowingTextView.h"
#import "ServerController.h"
#import "AFHTTPSessionManager.h"
#import <IQKeyboardManagerSwift/IQKeyboardManagerSwift-Swift.h>
#import "MyWorld-Swift.h"
#import "constants.h"


@interface AdminChatVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,HPGrowingTextViewDelegate,UIScrollViewDelegate>
{
    NSData *imageMessage;
    UIView *containerView;
    HPGrowingTextView *textView;
    NSTimer *timerCall;
}

@property (strong, nonatomic) NSMutableArray *chatArray;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation AdminChatVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setTableView];
    self.title=_tittleString;
    [self loadDataFromServer];
    self.inputTextFeild.delegate=self;
    timerCall = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats: YES];
}

-(void)viewDidAppear:(BOOL)animated{
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self addView];
}

-(void)popAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBarHidden = YES;
    [timerCall invalidate];
    timerCall = nil;
    [self.view endEditing:YES];
}


-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
}

- (IBAction)userDidTapScreen:(id)sender{
    [self.view resignFirstResponder];
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
    cell.isFrom = @"AdminChat";
    cell.message = [_chatArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeOfText;
    sizeOfText.width=130;
    sizeOfText.height=[AdminChatVC heightForText:[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"] font:[UIFont systemFontOfSize:15.0] withinWidth:sizeOfText.width];
        
        if (sizeOfText.height<44) {
            return 50 + 20;
        }
        else{
            return sizeOfText.height+20;
        }
   
    /*CGSize sizeOfText;
    sizeOfText.width=130;
    if ([[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatFile"] length] > 0 ) {
        sizeOfText.height=170;
    }else
        if ([[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"]!=[NSNull null]) {
            sizeOfText.height=[AdminChatVC heightForText:[[_chatArray objectAtIndex:indexPath.row ]valueForKey:@"chatMsg"] font:[UIFont systemFontOfSize:15.0] withinWidth:sizeOfText.width];
        }
    NSLog(@"sizeOfText.height%f",sizeOfText.height);
    if (sizeOfText.height<44) {
        return 50;
    }else
        return sizeOfText.height+10;*/
}

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
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

-(void) scrollToTop{
    if ([self numberOfSectionsInTableView:self.tableView] > 0){
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
                             @"userId":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"showAdminchat.php"] userInfo:params withSelector:@selector(getResponse:) delegate:self];
    
}
- (IBAction)backAction:(id)sender {
    //[self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendMessageServer:(NSString *)message{
    NSDictionary *params = @{
                             @"userId":[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],
                             @"userType":@"user",
                             @"chatMsg":message,
                             };
    NSLog(@"request parameter: %@", params);
    [[ServerController sharedController] callWebServiceGetJsonResponse:[WEBSERVICE_URL stringByAppendingString:@"setAdminchat.php"] userInfo:params withSelector:@selector(getSendResponse:) delegate:self];
}

-(void)getSendResponse:(id)data{
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

-(void)getResponse:(id)data{
    if (data!=[NSNull null]) {
        if ([[data valueForKey:@"responseCode"] isEqual:@"200"]) {
            
            self.chatArray= [[NSMutableArray alloc]init];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"alldata %@",data);
            [self.chatArray addObjectsFromArray:[data valueForKey:@"chatList"]];
            
            [self.tableView reloadData];
            [self scrollToTop];
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



/*- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(keyboardSize.height> (self.view.frame.size.height - textView.frame.size.height -textView.frame.origin.y)){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = self.view.frame.size.height - textView.frame.size.height -textView.frame.origin.y-keyboardSize.height - 10;
            self.view.frame = f;
        }];
        
    }
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}*/

//Code from Brett Schumann
/*-(void) keyboardWillShow:(NSNotification *)note{
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
}*/

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
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



- (void)addView {
    
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
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    containerView.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
}

-(void)resignTextView{
    [textView resignFirstResponder];
}


- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    [textView resignFirstResponder];
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

@end
