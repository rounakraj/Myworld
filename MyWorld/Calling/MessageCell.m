//
//  MessageCell.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"
#import "MyWorld-Swift.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
//@import Photos

@interface MessageCell (){
  EYMaterialActivityIndicatorView *loader;
}
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIImageView *profileimgView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *statusIcon;
@property (strong, nonatomic) UIButton *aeroButton,*fullButton;
@property (assign,nonatomic) CGFloat testHeight;
@end


@implementation MessageCell

-(CGFloat)height
{
    return _bubbleImage.frame.size.height;
}
-(void)updateMessageStatus
{
//    [self buildCell];
//    //Animate Transition
//    _statusIcon.alpha = 0;
//    [UIView animateWithDuration:.5 animations:^{
//        _statusIcon.alpha = 1;
//    }];
}

#pragma mark -

-(id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
     loader = [EYMaterialActivityIndicatorView.alloc initWithCenter:(CGPoint){100,150}];
    _profileimgView = [[UIImageView alloc] init];
    _playButton = [[UIButton alloc] init];
    _audioPlayButton = [[UIButton alloc] init];
    _slider = [[UISlider alloc]init];
    _aeroButton = [[UIButton alloc] init];
    _usernameLabel = [[UILabel alloc] init];
    _bubbleImage = [[UIImageView alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _statusIcon = [[UIImageView alloc] init];
    _resendButton = [[UIButton alloc] init];
    _resendButton.hidden = YES;
   _fullButton= [[UIButton alloc] init];
    _imgView = [[UIImageView alloc] init];
    _textView = [[UITextView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    _profileimgView.image = nil;
    _usernameLabel.text = @"";
     _imgView.image = nil;
    _textView.text = @"";
    _timeLabel.text = @"";
    _statusIcon.image = nil;
    _bubbleImage.image = nil;
    _resendButton.hidden = YES;
    _aeroButton.hidden = YES;
    _fullButton.hidden = YES;
}

-(void)setMessage:(NSDictionary *)message{
    if([self.isFrom isEqualToString:@"AdminChat"]){
         _message = [[NSDictionary alloc]init];
        _message = message;
        [self setTextView];
        [self setTimeLabel];
        [self setBubble];
    }
    else{
        _message = [[NSDictionary alloc]init];
        _message = message;
        [self buildCell];
    }
    //message.heigh = self.height;
}

//----- ravinder ---//
-(void)buildCell{
    NSString *extension = [[_message valueForKey:@"chatFile"]  pathExtension];
    if ([extension isEqualToString:@".3gp"]&&[extension isEqualToString:@".mp3"]&& [extension isEqualToString:@".wav"]){
        
    }
    else{
        if ([_message valueForKey:@"chatFile"]!=[NSNull null]&&![[_message valueForKey:@"chatFile"] isEqual:@"<null>"] && [[_message valueForKey:@"chatFile"] length]>0) { // for image
            [self setImageView];
            [self setTimeLabelForImage];
            [self setBubbleForImage];
            _playButton.hidden = YES;
            loader.hidden = YES;
            _audioPlayButton.hidden = YES;
            _slider.hidden = YES;
            _imgView.hidden = NO;
            NSString *filePath = [_message valueForKey:@"chatFile"];
            //[self SaveImageToGallery:filePath];
            bool isFileExist = [self checkFileExist:filePath];
            if (!isFileExist){
                [self SaveImageToGallery:filePath];
                [self writeImageToDocumentDirectory:filePath];
            }
        }
        else if ([_message valueForKey:@"chatTime"]!=[NSNull null]&&![[_message valueForKey:@"chatTime"] isEqual:@"<null>"] && [[_message valueForKey:@"chatTime"] length]>0) { // for video
            [self setImageView];
            [self setTimeLabelForImage];
            [self setBubbleForImage];
            _audioPlayButton.hidden = YES;
             _slider.hidden = YES;
            _imgView.hidden = NO;
            NSString *filePath = [_message valueForKey:@"chatVideo"];
            //[self SaveVideoToGallery:filePath];
            bool isFileExist = [self checkFileExist:filePath];
            if (!isFileExist){
                   [self SaveVideoToGallery:filePath];
                   [self writeVideoToDocumentDirectory:filePath];
            }
            else{
                 loader.hidden = YES;
               _playButton.hidden = NO;
            }
        }
         else if ([_message valueForKey:@"chatAudio"]!=[NSNull null]&&![[_message valueForKey:@"chatAudio"] isEqual:@"<null>"] && [[_message valueForKey:@"chatAudio"] length]>0) { //Audio
             _playButton.hidden = YES;
             loader.hidden = YES;
             _audioPlayButton.hidden = NO;
              _slider.hidden = NO;
             _imgView.hidden = YES;
             [self setBubbleForAudio];
             [self setTimeLabelForAudio];
         }
        else{ // for text
            _audioPlayButton.hidden = YES;
            _playButton.hidden = YES;
            loader.hidden = YES;\
             _slider.hidden = YES;
            _imgView.hidden = YES;
            [self setTextView];
            [self setTimeLabel];
            [self setBubble];
        }
    }
    [self addStatusIcon];
    [self setStatusIcon];
    [self setFailedButton];
    [self setNeedsLayout];
}

-(BOOL)checkFileExist:(NSString*)pathForFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[pathForFile lastPathComponent]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath:path]){
         return YES;
    }
    return NO;
}


/*-(void)buildCell{
    NSString *extension = [[_message valueForKey:@"chatFile"]  pathExtension];
    if ([extension isEqualToString:@".3gp"]&&[extension isEqualToString:@".mp3"]&& [extension isEqualToString:@".wav"]){
        
    }
    else{
        if ([_message valueForKey:@"chatFile"]!=[NSNull null]&&![[_message valueForKey:@"chatFile"] isEqual:@"<null>"] && [[_message valueForKey:@"chatFile"] length]>0) {
            [self setImageView];
            [self setTimeLabelForImage];
            [self setBubbleForImage];
        }
    }
    if ([_message valueForKey:@"chatTime"]!=[NSNull null]&&![[_message valueForKey:@"chatTime"] isEqual:@"<null>"] && [[_message valueForKey:@"chatTime"] length]>0) {
        [self setImageView];
        [self setTimeLabelForImage];
        [self setBubbleForImage];
    }
    else{
        [self setTextView];
        [self setTimeLabel];
        [self setBubble];
    }
    [self addStatusIcon];
    [self setStatusIcon];
    [self setFailedButton];
    [self setNeedsLayout];
}*/

#pragma mark - TextView

-(void)setTextView{
    CGFloat max_witdh = 0.6*self.contentView.frame.size.width;
    _textView.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    _textView.font = [UIFont systemFontOfSize:13.0];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = NO;
    
    _textView.text = [_message valueForKey:@"chatMsg"];
    [_textView sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y = 0.0;
    CGFloat textView_w = _textView.frame.size.width;
    CGFloat textView_h = _textView.frame.size.height;
    UIViewAutoresizing autoresizing;
    
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1)
    {
        textView_x = self.contentView.frame.size.width - textView_w - 20;
        textView_y = 30;//ravinder
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
       // textView_x -= [self isSingleLineCase]?65.0:0.0;
        //textView_x -= [self isStatusFailedCase]?([self fail_delta]-15):0.0;
    }
    else
    {
        textView_x = 20;
        //textView_y = -1;
         textView_y = 30;//ravinder
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    _textView.autoresizingMask = autoresizing;
    _textView.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
   
    [self.contentView addSubview:_bubbleImage];
    [self.contentView addSubview:_timeLabel];
    //[self.contentView addSubview:_statusIcon];
    //[self.contentView addSubview:_resendButton];
    [self.contentView addSubview:_textView];
}

-(void)setImageView{
    CGFloat max_witdh = 0.6*320;
    //_imgView.frame = CGRectMake(0, 40, max_witdh, 120); //ravinder
    _imgView.frame = CGRectMake(0, 40, max_witdh, 170);
    _imgView.userInteractionEnabled = NO;
    NSString *image1;
    if ([_message valueForKey:@"chatFile"]!=[NSNull null]&&![[_message valueForKey:@"chatFile"] isEqual:@"<null>"] && [[_message valueForKey:@"chatFile"] length]>0) {
       image1=[_message valueForKey:@"chatFile"];
    }
    else if ([_message valueForKey:@"chatVideo"]!=[NSNull null]&&![[_message valueForKey:@"chatVideo"] isEqual:@"<null>"] && [[_message valueForKey:@"chatVideo"] length]>0){
        image1=[_message valueForKey:@"chatTime"];
    }
    NSURL *profileUrl=[NSURL URLWithString:image1];
    [_imgView sd_setImageWithURL:profileUrl];
    CGFloat imgView_x;
    CGFloat imgView_y;
    CGFloat imgView_w = _imgView.frame.size.width;
    CGFloat imgView_h = _imgView.frame.size.height;
    UIViewAutoresizing autoresizing;
    
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1){
        //imgView_x = self.contentView.frame.size.width - imgView_w - 20;//ravinder
        imgView_x = self.contentView.frame.size.width - imgView_w - 10;
        //imgView_y;
        imgView_y = 30;
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        [_playButton setFrame:CGRectMake(imgView_w/2 + imgView_x-20 , imgView_h/2 , 50, 50)];
        [loader setFrame:CGRectMake(imgView_w/2 + imgView_x-20 , imgView_h/2 , 50, 50)];
       // imgView_x -= [self isSingleLineCase]?65.0:0.0;
        //imgView_x -= [self isStatusFailedCase]?([self fail_delta]-15):0.0;
    }
    else
    {
        imgView_x = 20;
        //imgView_y = -1; //ravinder
        imgView_y = 30;
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
          [_playButton setFrame:CGRectMake(imgView_w/2, imgView_h/2 , 50, 50)];
          [loader setFrame:CGRectMake(imgView_w/2, imgView_h/2 , 50, 50)];
    }
    
    _imgView.autoresizingMask = autoresizing;
    _imgView.frame = CGRectMake(imgView_x, imgView_y, imgView_w, imgView_h);
    //_playButton.frame = CGRectMake(_imgView.frame.size.width/2, _imgView.frame.size.height/2 , 50, 50);
    //[_playButton setFrame:CGRectMake(_imgView.frame.size.width/2, _imgView.frame.size.height/2 , 50, 50)];
    //_playButton.backgroundColor = [UIColor redColor];
    [_playButton setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    [self.contentView addSubview:_bubbleImage];
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_playButton];
    [self.contentView addSubview:loader];
    //[self.contentView addSubview:_statusIcon];
    //[self.contentView addSubview:_resendButton];
    
    
    @try {
        _imgView.image = [MessageCell imageWithImage : _imgView.image];
    } @catch (NSException *exception) {
    }

}


#pragma mark - TimeLabel

-(void)setTimeLabel{
     //_timeLabel.frame = CGRectMake(0, 0, 52, 14);//ravinder
     _timeLabel.frame = CGRectMake(0, 0, 100, 14);
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.userInteractionEnabled = NO;
    _timeLabel.alpha = 0.7;
    //_timeLabel.backgroundColor = [UIColor blackColor];
    //_timeLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *dateString = [self.isFrom isEqualToString:@"AdminChat" ] ? [_message valueForKey:@"chatTime"] : [_message valueForKey:@"chatDate"];
    //NSString *dateString = [_message valueForKey:@"chatDate"];
    //---- ravinder
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    self.timeLabel.text = [df stringFromDate:dateFromString];*/
    self.timeLabel.text = dateString;
    //Set position
    CGFloat time_x;
    //CGFloat time_y = _textView.frame.size.height - 10;//ravinder
    CGFloat time_y = _textView.frame.origin.y- 20;
    
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1)
    {
        _timeLabel.textAlignment = NSTextAlignmentRight;
        //time_x = _textView.frame.origin.x + _textView.frame.size.width - _timeLabel.frame.size.width;//ravinder
        time_x = _textView.frame.origin.x + _textView.frame.size.width - _timeLabel.frame.size.width + 20;
        
    }
    else
    {
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        //time_x = MAX(_textView.frame.origin.x + _textView.frame.size.width - _timeLabel.frame.size.width,
       //              _textView.frame.origin.x);// ravinder
        time_x = 0;
    }
    
   
    
    _timeLabel.frame = CGRectMake(time_x,
                                  time_y,
                                  _timeLabel.frame.size.width,
                                  _timeLabel.frame.size.height);
    
    _timeLabel.autoresizingMask = _textView.autoresizingMask;
}

-(void)setTimeLabelForImage
{
    //_timeLabel.frame = CGRectMake(0, 0, 52, 14);//ravinder
    _timeLabel.frame = CGRectMake(0, 0, 100, 14);
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.userInteractionEnabled = NO;
    _timeLabel.alpha = 0.7;
    //_timeLabel.backgroundColor = [UIColor blackColor];
    
    
    NSString *dateString = [_message valueForKey:@"chatDate"];
   //----- ravinder
    /* NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    self.timeLabel.text = [df stringFromDate:dateFromString];*/
    self.timeLabel.text = dateString;
    
    //Set position
    CGFloat time_x;
    //CGFloat time_y = _imgView.frame.size.height +10;//ravinder
    CGFloat time_y = _imgView.frame.origin.y-25;
    
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1)
    {
        //time_x = _imgView.frame.origin.x + _imgView.frame.size.width - _timeLabel.frame.size.width;//ravinder
        
        _timeLabel.textAlignment = NSTextAlignmentRight;
        time_x = _imgView.frame.origin.x + _imgView.frame.size.width - _timeLabel.frame.size.width +10;
    }
    else
    {
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        //time_x = MAX(_imgView.frame.origin.x + _imgView.frame.size.width - _timeLabel.frame.size.width,
            //         _imgView.frame.origin.x); // ravinder
        time_x = 0;
    }
    
    if ([self isSingleLineCase])
    {
        time_x = _imgView.frame.origin.x + _imgView.frame.size.width - 5;
        time_y -= 10;
    }
    
    _timeLabel.frame = CGRectMake(time_x,
                                  time_y,
                                  _timeLabel.frame.size.width,
                                  _timeLabel.frame.size.height);
    
   // _timeLabel.autoresizingMask = _imgView.autoresizingMask;
}


-(BOOL)isSingleLineCase
{

    CGFloat delta_x =[[_message valueForKey:@"chatFlag"]integerValue] != 1 ?65.0:44.0;
    
    CGFloat textView_height = _imgView.frame.size.height;
    CGFloat textView_width = _imgView.frame.size.width;
    CGFloat view_width = self.contentView.frame.size.width;
    
    //Single Line Case
    return (textView_height <= 45 && textView_width + delta_x <= 0.8*view_width)?YES:NO;
}

#pragma mark - Bubble

- (void)setBubble
{
    //Margins to Bubble
    CGFloat marginLeft = 5;
    CGFloat marginRight = 2;
    
    //Bubble positions
    CGFloat bubble_x;
    //CGFloat bubble_y = 0;
     CGFloat bubble_y = 30;//ravinder
    CGFloat bubble_width;
    CGFloat bubble_height = MIN(_textView.frame.size.height + 8,
                                _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 6);
    
        if ([[_message valueForKey:@"chatFlag"]integerValue] != 1)
        {
            
            bubble_x = MIN(_textView.frame.origin.x -marginLeft,_timeLabel.frame.origin.x - 2*marginLeft);
            
            _bubbleImage.image = [[self imageNamed:@"bubbleMine"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:14];
            
            
            bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
            bubble_width -= [self isStatusFailedCase]?[self fail_delta]:0.0;
            NSLog(@"right buble");
            _bubbleImage.frame = CGRectMake(bubble_x, 30, bubble_width+5, _textView.frame.size.height+5);
        }
        else
        {
            bubble_x = marginRight;
            
            _bubbleImage.image = [[self imageNamed:@"bubbleSomeone"]
                                  stretchableImageWithLeftCapWidth:21 topCapHeight:14];
            
            bubble_width = MAX(_textView.frame.origin.x + _textView.frame.size.width + marginLeft,
                               _timeLabel.frame.origin.x + _timeLabel.frame.size.width + 2*marginLeft);
              NSLog(@"left buble");
              _bubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width+5, _textView.frame.size.height+5);
        }
        
        //_bubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);//ravinder
    
       NSLog(@"%@=",_bubbleImage);
        _bubbleImage.autoresizingMask = _textView.autoresizingMask;
    }


- (void)SaveImageToGallery:(NSString*)filePath {
    NSURL  *url = [NSURL URLWithString:filePath];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                NSLog(@"%@", changeRequest.description);
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"IMAGE SAVE");
                } else {
                    NSLog(@"IMAGE SAVE ERROR %@", error.localizedDescription);
                }
            }];
}

-(void)SaveVideoToGallery:(NSString*)filePath{
      NSURL  *video_url = [NSURL URLWithString:filePath];
      NSURL *sourceURL = video_url;
      NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"error saving: %@", error.localizedDescription);
            return;
        }
        
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[sourceURL lastPathComponent]];
        
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:tempURL];
            
            NSLog(@"%@", changeRequest.description);
        } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                loader.hidden = YES;
                _playButton.hidden = NO;
            });
            if (success) {
                NSLog(@"VIDEO SAVE");
                //[[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
            } else {
                NSLog(@"VIDEO SAVE ERROR %@", error.localizedDescription);
                //[[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
            }
        }];
    }];
    [download resume];
}

/*-(void)SaveVideoToGallery:(NSURL*)video_url{
        if (video_url) {
            if([video_url absoluteString].length < 1) {
                return;
            }
            
            NSLog(@"source will be : %@", video_url.absoluteString);
            NSURL *sourceURL = video_url;
            
            if([[NSFileManager defaultManager] fileExistsAtPath:[video_url absoluteString]]) {
                [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:video_url completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    if(assetURL) {
                        NSLog(@"VIDEO SAVED");
                    } else {
                        NSLog(@"VIDEO NOT SAVED");
                    }
                }];
                
            } else {
                
                NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    if(error) {
                        NSLog(@"error saving: %@", error.localizedDescription);
                        return;
                    }
                    
                    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
                    NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[sourceURL lastPathComponent]];
                    
                    [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
                    
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:tempURL];
                        
                        NSLog(@"%@", changeRequest.description);
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            NSLog(@"saved down");
                            [[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
                        } else {
                            NSLog(@"something wrong %@", error.localizedDescription);
                            [[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];
                        }
                    }];
                }];
                [download resume];
            }
        }
}*/

-(void)writeImageToDocumentDirectory:(NSString*)url{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // NSLog(@"Downloading Started");
        NSString *urlToDownload = url;
        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if (urlData){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[url lastPathComponent]];
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                // NSLog(@"File Saved !");
            });
        }
    });
}


-(void)writeVideoToDocumentDirectory:(NSString*)url{
    //download the file in a seperate thread.
    loader.hidden = NO;
    _playButton.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // NSLog(@"Downloading Started");
        NSString *urlToDownload = url;
        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if (urlData){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[url lastPathComponent]];
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                // NSLog(@"File Saved !");
                 //loader.hidden = YES;
                //_playButton.hidden = NO;
            });
        }
    });
}

-(void)setTimeLabelForAudio{
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake(0, 0, 100, 14);
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.userInteractionEnabled = NO;
    //_timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.alpha = 0.7;
    
    NSString *dateString = [_message valueForKey:@"chatDate"];
    self.timeLabel.text = dateString;
    //Set position
    CGFloat time_x;
    CGFloat time_y = _bubbleImage.frame.origin.y- 20;
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1){
        _timeLabel.textAlignment = NSTextAlignmentRight;
        time_x = _bubbleImage.frame.origin.x + _bubbleImage.frame.size.width - 100;
    }
    else{
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        time_x = 0;
    }
    _timeLabel.frame = CGRectMake(time_x,time_y,_timeLabel.frame.size.width,_timeLabel.frame.size.height);
    [self.contentView addSubview:_timeLabel];
}

-(void)setSlliderForAudio{
    //[_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
  
}

-(void)setBubbleForAudio{
    CGFloat marginRight = 5;
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 30;
    CGFloat bubble_width;
    CGFloat bubble_height = 50;
    _bubbleImage = [[UIImageView alloc]init];
    //[_audioPlayButton setBackgroundColor:[UIColor redColor]];
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1){ //right
        bubble_x = self.contentView.frame.size.width *0.5;
        _bubbleImage.image = [[self imageNamed:@"bubbleMine"]
                              stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
         _bubbleImage.frame = CGRectMake(bubble_x-2, bubble_y-7, bubble_width+8, bubble_height);
         [_audioPlayButton setFrame:CGRectMake(bubble_x-2 + 10, _bubbleImage.center.y - 15 , 30, 30)];
         [_slider setFrame:CGRectMake(_audioPlayButton.frame.origin.x + _audioPlayButton.frame.size.width + 5, _bubbleImage.center.y - 5 , _bubbleImage.frame.size.width - 60, 10)];
    }
    else{ //left
        bubble_x = marginRight;
        _bubbleImage.image = [[self imageNamed:@"bubbleSomeone"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
       bubble_width = self.contentView.frame.size.width *0.5;//self.contentView.frame.size.width - bubble_x - marginRight;
        _bubbleImage.frame = CGRectMake(bubble_x-2, bubble_y-7, bubble_width+8, bubble_height);
        [_audioPlayButton setFrame:CGRectMake(bubble_x-2 + 15, _bubbleImage.center.y - 15 , 30, 30)];
        [_slider setFrame:CGRectMake(_audioPlayButton.frame.origin.x + _audioPlayButton.frame.size.width + 5, _bubbleImage.center.y - 5 , _bubbleImage.frame.size.width - 60, 10)];
    }
     [_audioPlayButton setImage:[UIImage imageNamed:@"ic_play_green"] forState:UIControlStateNormal];
     [_slider setBackgroundColor:[UIColor clearColor]];
     [_slider setThumbImage:[UIImage imageNamed:@"ic_circle_fill"] forState:UIControlStateNormal];
    //_slider.minimumValue = 0.0;
    _slider.maximumValue = 0.0;
    _slider.continuous = YES;
    _slider.value = 25.0;
    [self.contentView addSubview:_bubbleImage];
    [self.contentView  addSubview:_audioPlayButton];
    [self.contentView  addSubview:_slider];
}


- (void)setBubbleForImage{
    //Margins to Bubble
    CGFloat marginLeft = 5;
    CGFloat marginRight = 2;
    
    //Bubble positions
    CGFloat bubble_x;
   // CGFloat bubble_y = 0; //ravinder
    CGFloat bubble_y = 30;
    CGFloat bubble_width;
    CGFloat bubble_height = MIN(_imgView.frame.size.height + 8,
                                _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 6);
    
    if ([[_message valueForKey:@"chatFlag"]integerValue] != 1)
    {
        
        bubble_x = MIN(_imgView.frame.origin.x -marginLeft,_timeLabel.frame.origin.x - 2*marginLeft);
        
        
        _bubbleImage.image = [[self imageNamed:@"bubbleMine"]
                              stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        
        
         //bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
         bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
       // bubble_width -= [self isStatusFailedCase]?[self fail_delta]:0.0;
    }
    else
    {
        bubble_x = marginRight;
        
        _bubbleImage.image = [[self imageNamed:@"bubbleSomeone"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        bubble_width = MAX(_imgView.frame.origin.x + _imgView.frame.size.width + marginLeft,
                           _timeLabel.frame.origin.x + _timeLabel.frame.size.width + 2*marginLeft);
    }
    
    //_bubbleImage.frame = CGRectMake(bubble_x-2, bubble_y-7, bubble_width, bubble_height+10);//ravinder
    _bubbleImage.frame = CGRectMake(bubble_x-2, bubble_y-7, bubble_width+8, _imgView.frame.size.height+17);
    _bubbleImage.autoresizingMask = _imgView.autoresizingMask;
}


#pragma mark - StatusIcon

-(void)addStatusIcon
{
    CGRect time_frame = _timeLabel.frame;
    CGRect status_frame = CGRectMake(0, 0, 15, 14);
    status_frame.origin.x = time_frame.origin.x + time_frame.size.width + 5;
    status_frame.origin.y = time_frame.origin.y;
    _statusIcon.frame = status_frame;
    _statusIcon.contentMode = UIViewContentModeLeft;
    _statusIcon.autoresizingMask = _textView.autoresizingMask;
}
-(void)setStatusIcon
{
    
     if ([[self.message valueForKey:@"status"]  isEqual: @"N"])
        _statusIcon.image = [self imageNamed:@"status_notified"];
    else if ([[self.message valueForKey:@"status"]  isEqual: @"Y"])
        _statusIcon.image = [self imageNamed:@"status_read"];
   
//    if (self.message.status == MessageStatusSending)
//        _statusIcon.image = [self imageNamed:@"status_sending"];
//    else if (self.message.status == MessageStatusSent)
//        _statusIcon.image = [self imageNamed:@"status_sent"];
//    else if (self.message.status == MessageStatusReceived)
//        _statusIcon.image = [self imageNamed:@"status_notified"];
//    else if (self.message.status == MessageStatusRead)
//        _statusIcon.image = [self imageNamed:@"status_read"];
//    if (self.message.status == MessageStatusFailed)
//        _statusIcon.image = nil;
    
   // _statusIcon.hidden = _message.sender == MessageSenderSomeone;
}

#pragma mark - Failed Case

//
// This delta is how much TextView
// and Bubble should shit left
//
-(NSInteger)fail_delta
{
    return 60;
}
-(BOOL)isStatusFailedCase
{
    //return self.message.status == MessageStatusFailed;
    return NO;
}
-(void)setFailedButton
{
    NSInteger b_size = 22;
    CGRect frame = CGRectMake(self.contentView.frame.size.width - b_size - [self fail_delta]/2 + 5,
                              (self.contentView.frame.size.height - b_size)/2,
                              b_size,
                              b_size);
    
    _resendButton.frame = frame;
    _resendButton.hidden = ![self isStatusFailedCase];
    [_resendButton setImage:[self imageNamed:@"status_failed"] forState:UIControlStateNormal];
}

#pragma mark - UIImage Helper

-(UIImage *)imageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName
                      inBundle:[NSBundle bundleForClass:[self class]]
 compatibleWithTraitCollection:nil];
}



+(UIImage*)imageWithImage: (UIImage*) sourceImage
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = screenWidth / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
