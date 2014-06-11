//
//  SignUpViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)checkField;
- (void)registerNewUser;
- (IBAction)registerButton:(id)sender;

@end
