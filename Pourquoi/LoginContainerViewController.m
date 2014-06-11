//
//  LoginContainerViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 19/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "LoginContainerViewController.h"

#import "SignInViewController.h"
#import "SignUpViewController.h"

#define SegueIdentifierSignIn @"embedSignIn"
#define SegueIdentifierSignUp @"embedSignUp"

@interface LoginContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) SignInViewController *signInVC;
@property (strong, nonatomic) SignUpViewController *signUpVC;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation LoginContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierSignUp;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueIdentifierSignUp]) {
        self.signInVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierSignIn]) {
        self.signUpVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierSignUp]) {
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.signInVC];
        }
        else {
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierSignIn]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.signUpVC];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];

        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierSignUp]) ? SegueIdentifierSignIn : SegueIdentifierSignUp;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSignUp]) && self.signInVC) {
        [self swapFromViewController:self.signUpVC toViewController:self.signInVC];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSignIn]) && self.signUpVC) {
        [self swapFromViewController:self.signInVC toViewController:self.signUpVC];
        return;
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end
