//
//  UIScrollView+KeyboardAvoidingAdditions.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (KeyboardAvoidingAdditions)
- (BOOL)KeyboardAvoiding_focusNextTextField;
- (void)KeyboardAvoiding_scrollToActiveTextField;

- (void)KeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)KeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)KeyboardAvoiding_updateContentInset;
- (void)KeyboardAvoiding_updateFromContentSizeChange;
- (void)KeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView*)KeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
-(CGSize)KeyboardAvoiding_calculatedContentSizeFromSubviewFrames;
@end
