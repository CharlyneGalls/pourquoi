//
//  SignUpViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.name setFont:[UIFont fontWithName:@"Lora" size:20]];
    [self.usernameField setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [self.passwordField setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
}

- (void)checkField
{
    if ([self.usernameField.text isEqualToString:@""] ||
        [self.passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oops !"
                              message:@"Tous les champs doivent être correctement remplis."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self registerNewUser];
    }
}

- (void)registerNewUser
{
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Registration success !");
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil]; 
        } else {
            NSLog(@"There was an error in registration");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Oops !"
                                  message:@"Une erreur s'est produite lors de l'enregistrement."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)registerButton:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self checkField];
}
@end
