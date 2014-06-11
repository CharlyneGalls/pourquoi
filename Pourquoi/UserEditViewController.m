//
//  UserEditViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 20/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "UserEditViewController.h"
#import "MenuViewController.h"
#import "KeyboardAvoidingScrollView.h"

@interface UserEditViewController ()
{
    BOOL userpictureOK;
    BOOL usernameOK;
    BOOL passwordOK;
}
@end

@implementation UserEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadInitialData];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.scrollView contentSizeToFit];
    
    self.usernameField.delegate = self;
    self.currentPasswordField.delegate = self;
    self.defineNewPasswordField.delegate = self;
}

- (void)loadInitialData
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        self.userPicture.image = [UIImage imageNamed:@"placeholder-edit.jpg"];
        self.userPicture.file = [object objectForKey:@"imageFile"];
        [self.userPicture loadInBackground];
        
        self.usernameField.placeholder = [object objectForKey:@"username"];
        [self.usernameField setFont:[UIFont fontWithName:@"Lora" size:20]];
        
    }];
    
    [self.currentPasswordField setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [self.defineNewPasswordField setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
}

- (IBAction)addPicture:(id)sender
{
    [self showPhotoLibary];
}

- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.userPicture.image = originalImage;
    
    [self saveImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)checkField
{
    if ([self.currentPasswordField.text isEqualToString:[PFUser currentUser].password]) {
        [self savePassword];
    }
    
    if (![self.usernameField.text isEqualToString:@""]) {
        [self saveUsername];
    }
    
    if (userpictureOK || usernameOK || passwordOK) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Mise à jour"
                              message:@"Les changements ont été correctement effectués."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oops !"
                              message:@"Les champs ne sont pas correctement remplis."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)saveImage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    if ([self.usernameField.text isEqualToString:@""]){
        NSData *imageData = UIImageJPEGRepresentation(self.userPicture.image, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@", self.usernameField.placeholder];
        
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        
        [[PFUser currentUser] setObject:imageFile forKey:@"imageFile"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
        }];
    }
    
    else {
        NSData *imageData = UIImageJPEGRepresentation(self.userPicture.image, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@", self.usernameField.text];
        
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        
        [[PFUser currentUser] setObject:imageFile forKey:@"imageFile"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
        }];
    }
    
    userpictureOK = YES;
}

- (void)savePassword
{
    [PFUser currentUser].password = self.defineNewPasswordField.text;
    [[PFUser currentUser] saveInBackground];
    passwordOK = YES;
}

- (void)saveUsername
{
    [PFUser currentUser].username = self.usernameField.text;
    [[PFUser currentUser] saveInBackground];
    usernameOK = YES;
}

- (IBAction)saveButton:(id)sender {
    [self checkField];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOut];
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"categorieViewController"]]
                                                 animated:YES];
}

@end
