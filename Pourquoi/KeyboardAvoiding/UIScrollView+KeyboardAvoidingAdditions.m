//
//  UIScrollView+KeyboardAvoidingAdditions.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "UIScrollView+KeyboardAvoidingAdditions.h"
#import "KeyboardAvoidingScrollView.h"
#import <objc/runtime.h>

static const CGFloat kCalculatedContentPadding = 10;
static const CGFloat kMinimumScrollOffsetPadding = 20;

static const int kStateKey;

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface KeyboardAvoidingState : NSObject
@property (nonatomic, assign) UIEdgeInsets priorInset;
@property (nonatomic, assign) UIEdgeInsets priorScrollIndicatorInsets;
@property (nonatomic, assign) BOOL         keyboardVisible;
@property (nonatomic, assign) CGRect       keyboardRect;
@property (nonatomic, assign) CGSize       priorContentSize;
@end

@implementation UIScrollView (KeyboardAvoidingAdditions)

- (KeyboardAvoidingState*)keyboardAvoidingState {
    KeyboardAvoidingState *state = objc_getAssociatedObject(self, &kStateKey);
    if ( !state ) {
        state = [[KeyboardAvoidingState alloc] init];
        objc_setAssociatedObject(self, &kStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
        [state release];
#endif
    }
    return state;
}

- (void)KeyboardAvoiding_keyboardWillShow:(NSNotification*)notification {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( state.keyboardVisible ) {
        return;
    }
    
    UIView *firstResponder = [self KeyboardAvoiding_findFirstResponderBeneathView:self];
    
    state.keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    state.keyboardVisible = YES;
    state.priorInset = self.contentInset;
    state.priorScrollIndicatorInsets = self.scrollIndicatorInsets;
    
    if ( [self isKindOfClass:[KeyboardAvoidingScrollView class]] ) {
        state.priorContentSize = self.contentSize;
        
        if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
            self.contentSize = [self KeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
        }
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = [self KeyboardAvoiding_contentInsetForKeyboard];
    
    if ( firstResponder ) {
        CGFloat viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           [self KeyboardAvoiding_idealOffsetForView:firstResponder
                                                                 withViewingAreaHeight:viewableHeight])
                      animated:NO];
    }
    
    self.scrollIndicatorInsets = self.contentInset;
    
    [UIView commitAnimations];
}

- (void)KeyboardAvoiding_keyboardWillHide:(NSNotification*)notification {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( !state.keyboardVisible ) {
        return;
    }
    
    state.keyboardRect = CGRectZero;
    state.keyboardVisible = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    if ( [self isKindOfClass:[KeyboardAvoidingScrollView class]] ) {
        self.contentSize = state.priorContentSize;
    }
    
    self.contentInset = state.priorInset;
    self.scrollIndicatorInsets = state.priorScrollIndicatorInsets;
    [UIView commitAnimations];
}

- (void)KeyboardAvoiding_updateContentInset {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
        self.contentInset = [self KeyboardAvoiding_contentInsetForKeyboard];
    }
}

- (void)KeyboardAvoiding_updateFromContentSizeChange {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
		state.priorContentSize = self.contentSize;
        self.contentInset = [self KeyboardAvoiding_contentInsetForKeyboard];
    }
}

#pragma mark - Utilities

- (BOOL)KeyboardAvoiding_focusNextTextField {
    UIView *firstResponder = [self KeyboardAvoiding_findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        return NO;
    }
    
    CGFloat minY = CGFLOAT_MAX;
    UIView *view = nil;
    [self KeyboardAvoiding_findTextFieldAfterTextField:firstResponder beneathView:self minY:&minY foundView:&view];
    
    if ( view ) {
        [view performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
        return YES;
    }
    
    return NO;
}

-(void)KeyboardAvoiding_scrollToActiveTextField {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( !state.keyboardVisible ) return;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset = CGPointMake(0, [self KeyboardAvoiding_idealOffsetForView:[self KeyboardAvoiding_findFirstResponderBeneathView:self]
                                                               withViewingAreaHeight:visibleSpace]);
    [UIView animateWithDuration:0.25 animations:^{
        [self setContentOffset:idealOffset animated:NO];
    }];
}

#pragma mark - Helpers

- (UIView*)KeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self KeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (void)KeyboardAvoiding_findTextFieldAfterTextField:(UIView*)priorTextField beneathView:(UIView*)view minY:(CGFloat*)minY foundView:(UIView**)foundView {
    CGFloat priorFieldOffset = CGRectGetMinY([self convertRect:priorTextField.frame fromView:priorTextField.superview]);
    for ( UIView *childView in view.subviews ) {
        if ( childView.hidden ) continue;
        if ( ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]) && childView.isUserInteractionEnabled) {
            CGRect frame = [self convertRect:childView.frame fromView:view];
            if ( childView != priorTextField
                    && CGRectGetMinY(frame) >= priorFieldOffset
                    && CGRectGetMinY(frame) < *minY &&
                    !(frame.origin.y == priorTextField.frame.origin.y
                      && frame.origin.x < priorTextField.frame.origin.x) ) {
                *minY = CGRectGetMinY(frame);
                *foundView = childView;
            }
        } else {
            [self KeyboardAvoiding_findTextFieldAfterTextField:priorTextField beneathView:childView minY:minY foundView:foundView];
        }
    }
}

- (void)KeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view {
    for ( UIView *childView in view.subviews ) {
        if ( ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]) ) {
            [self KeyboardAvoiding_initializeView:childView];
        } else {
            [self KeyboardAvoiding_assignTextDelegateForViewsBeneathView:childView];
        }
    }
}

-(CGSize)KeyboardAvoiding_calculatedContentSizeFromSubviewFrames {
    
    BOOL wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    BOOL wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    CGRect rect = CGRectZero;
    for ( UIView *view in self.subviews ) {
        rect = CGRectUnion(rect, view.frame);
    }
    rect.size.height += kCalculatedContentPadding;
    
    self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator;
    
    return rect.size;
}


- (UIEdgeInsets)KeyboardAvoiding_contentInsetForKeyboard {
    KeyboardAvoidingState *state = self.keyboardAvoidingState;
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = state.keyboardRect;
    newInset.bottom = keyboardRect.size.height - (CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds));
    return newInset;
}

-(CGFloat)KeyboardAvoiding_idealOffsetForView:(UIView *)view withViewingAreaHeight:(CGFloat)viewAreaHeight {
    CGSize contentSize = self.contentSize;
    CGFloat offset = 0.0;

    CGRect subviewRect = [view convertRect:view.bounds toView:self];

    CGFloat padding = (viewAreaHeight - subviewRect.size.height) / 2;
    if ( padding < kMinimumScrollOffsetPadding ) {
        padding = kMinimumScrollOffsetPadding;
    }

    offset = subviewRect.origin.y - padding - self.contentInset.top;
    
    if ( offset > (contentSize.height - viewAreaHeight) ) {
        offset = contentSize.height - viewAreaHeight;
    }

    if ( offset < -self.contentInset.top ) {
        offset = -self.contentInset.top;
    }

    return offset;
}

- (void)KeyboardAvoiding_initializeView:(UIView*)view {
    if ( [view isKindOfClass:[UITextField class]] && ((UITextField*)view).returnKeyType == UIReturnKeyDefault && (![(id)view delegate] || [(id)view delegate] == self) ) {
        [(id)view setDelegate:self];
        UIView *otherView = nil;
        CGFloat minY = CGFLOAT_MAX;
        [self KeyboardAvoiding_findTextFieldAfterTextField:view beneathView:self minY:&minY foundView:&otherView];
        
        if ( otherView ) {
            ((UITextField*)view).returnKeyType = UIReturnKeyNext;
        } else {
            ((UITextField*)view).returnKeyType = UIReturnKeyDone;
        }
    }
}

@end


@implementation KeyboardAvoidingState
@end
