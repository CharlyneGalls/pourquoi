//
//  LoginViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginContainerViewController.h"

@class KeyboardAvoidingScrollView;

@interface LoginViewController : UIViewController

@property (nonatomic, weak) LoginContainerViewController *loginContainerVC;

@property (weak, nonatomic) IBOutlet KeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIButton *menuButton;
@property (nonatomic, assign) BOOL logout;

- (IBAction)swapLogin:(id)sender;

@end
