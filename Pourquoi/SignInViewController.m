//
//  SignInViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

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
        [self connectUser];
    }
}

- (void)connectUser
{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (!error){
            NSLog(@"Login user!");
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"There was an error in registration");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Oops !"
                                  message:@"Une erreur s'est produite lors de la connexion."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)connecterButton:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self checkField];
}
@end
