//
//  UserEditViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 20/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

#import "MBProgressHUD.h"

@class KeyboardAvoidingScrollView;

@interface UserEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *userPicture;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *defineNewPasswordField;

@property (weak, nonatomic) IBOutlet KeyboardAvoidingScrollView *scrollView;


- (IBAction)addPicture:(id)sender;

- (IBAction)logoutButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)backButton:(id)sender;


@end
