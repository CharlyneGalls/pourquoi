//
//  DemandeViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 14/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "DemandeViewController.h"
#import "KeyboardAvoidingScrollView.h"

@interface DemandeViewController ()

@end

@implementation DemandeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.textView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView contentSizeToFit];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing  = 20;
    
    self.textView.font               = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.textView.attributedText     = [[NSAttributedString alloc] initWithString:@"Pourquoi, " attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];

    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.name.font = [UIFont fontWithName:@"Lora" size:20];
    [self.textView setTextColor:[UIColor grayColor]];
    self.textView.font = [UIFont fontWithName:@"Lato-Regular" size:16];
}

#pragma mark - add why

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // if textview is fill with space
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:charSet];
    
    if ([textView.text isEqualToString:@""] || [trimmedString isEqualToString:@""] || [textView.text isEqualToString:@"Pourquoi, "] || [textView.text isEqualToString:@"Pourquoi,"]) {
        textView.text = @"Pourquoi, ";
        [textView setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    }
    [textView resignFirstResponder];
}

- (IBAction)sendPourquoi:(id)sender
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.textView.text stringByTrimmingCharactersInSet:charSet];
    
    if (!([self.textView.text isEqualToString:@"Pourquoi, "] || [self.textView.text isEqualToString:@"Pourquoi,"])) {
        if ([trimmedString isEqualToString:@""]) {
            self.textView.text = @"Pourquoi, ";
        } else {
            PFObject *newQuestion = [PFObject objectWithClassName:@"Question"];
            [newQuestion setObject:[self.textView text] forKey:@"question"];
            [newQuestion setObject:[PFUser currentUser] forKey:@"auteur"];
            
            [newQuestion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Poser une question"
                                                                      message:@"Votre pourquoi a bien été envoyé"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    
                    [message show];
                    self.textView.text = @"Pourquoi, ";
                }
            }];
        }
        [self dismissKeyboard];
    }
}

- (void)dismissKeyboard {
    [self textViewDidEndEditing:self.textView];
}

@end
