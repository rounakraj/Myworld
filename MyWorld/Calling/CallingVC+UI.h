//
//  CallingVC+UI.h
//  CallingDemo
//
//  Created by Shankar Kumar on 25/12/17.
//  Copyright © 2017 Shankar Kumar. All rights reserved.
//

#import "CallingVC.h"
#import "CallViewController+UI.h"

@interface CallingVC (UIAdjustments)
- (void)setCallStatusText:(NSString *)text;

- (void)showButtons:(EButtonsBar)buttons;

- (void)setDuration:(NSInteger)seconds;
- (void)startCallDurationTimerWithSelector:(SEL)sel;
- (void)stopCallDurationTimer;
@end
