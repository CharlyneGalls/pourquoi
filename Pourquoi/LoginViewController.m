//
//  LoginViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "LoginViewController.h"
#import "KeyboardAvoidingScrollView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.scrollView contentSizeToFit];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.loginContainerVC = segue.destinationViewController;
    }
}

- (IBAction)swapLogin:(id)sender
{
    if ([self.loginButton.currentTitle isEqualToString:@"J'AI DEJA UN COMPTE ?"]) {
        [self.loginButton setTitle:@"JE N'AI PAS ENCORE DE COMPTE ?" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"JE N'AI PAS ENCORE DE COMPTE ?" forState:UIControlStateHighlighted];
    } else {
        [self.loginButton setTitle:@"J'AI DEJA UN COMPTE ?" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"J'AI DEJA UN COMPTE ?" forState:UIControlStateHighlighted];
    }

    [self.loginContainerVC swapViewControllers];
}

- (IBAction)closeModal:(id)sender
{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
