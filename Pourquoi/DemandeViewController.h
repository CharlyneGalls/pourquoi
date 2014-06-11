//
//  DemandeViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 14/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DemandeCustomTextView.h"

@class KeyboardAvoidingScrollView;

@interface DemandeViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet DemandeCustomTextView *textView;
@property (weak, nonatomic) IBOutlet KeyboardAvoidingScrollView *scrollView;

@end