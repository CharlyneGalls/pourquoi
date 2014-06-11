//
//  DefinitionViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"
#import "Definition.h"
#import "CommentaireCustomCell.h"
#import "Commentaire.h"
#import <Parse/Parse.h>

@class KeyboardAvoidingScrollView;

@interface DefinitionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSLayoutManagerDelegate, UITextViewDelegate>
{
    int sliderValue;
}

@property (strong, nonatomic) Definition *definition;
@property (strong, nonatomic) UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *favorisButton;
@property (nonatomic, assign) BOOL aleatoire;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (nonatomic, retain) IBOutlet UISlider *explicationSlider;
@property (weak, nonatomic) IBOutlet UITextView *explication;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explicationConstraintHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraintHeight;
@property (weak, nonatomic) IBOutlet GrowingTextView *growingTextView;
@property (weak, nonatomic) IBOutlet KeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) CommentaireCustomCell *prototypeCell;

- (void)loadInitialData;
- (void)backButton:(id)sender;
- (IBAction)valueChanged:(UISlider*)sender;
- (void)dismissKeyboard;

@end
