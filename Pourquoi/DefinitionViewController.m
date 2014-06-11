//
//  DefinitionViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "DefinitionViewController.h"
#import "LoginViewController.h"
#import "KeyboardAvoidingScrollView.h"
#import "RESideMenu.h"
#import "NSDate+NVTimeAgo.h"

@interface DefinitionViewController ()

@property (nonatomic, strong) NSArray *commentairesArray;

@end

@implementation DefinitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadInitialData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.growingTextView.delegate = self;
    self.explication.layoutManager.delegate = self;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.explicationSlider setMinimumTrackTintColor:[UIColor groupTableViewBackgroundColor]];
    [self.explicationSlider setMaximumTrackTintColor:[UIColor groupTableViewBackgroundColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.scrollView contentSizeToFit];
    [self.view addGestureRecognizer:tap];
}

-(CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 5.5;
}

#pragma mark -
#pragma mark ViewController LoadInitialData

- (void)loadInitialData
{
    sliderValue = 1;
    
    if (self.aleatoire == 0) {
        self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -5, 55, 55)];
        [self.menuButton setImage:[UIImage imageNamed:@"button-back-white.png"] forState:UIControlStateNormal];
        [self.menuButton setImage:[UIImage imageNamed:@"button-back-white.png"] forState:UIControlStateHighlighted];
        [self.menuButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateNormal];
        [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateHighlighted];
        [self.menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.image.file = self.definition.imageFile;
    self.name.text = self.definition.name;
    [self.name setFont:[UIFont fontWithName:@"Lora" size:20]];
    
    [self.scrollView addSubview:self.menuButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.explication.text = self.definition.explications[sliderValue];
    [self.explication setTextColor:[UIColor grayColor]];
    [self.explication setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    
    CGSize sizeThatFitsTextView = [self.explication sizeThatFits:CGSizeMake(self.explication.frame.size.width, MAXFLOAT)];
    self.explicationConstraintHeight.constant = ceilf(sizeThatFitsTextView.height);
    
    [self.tableView reloadData];
    
    PFUser *user = [PFUser currentUser];
    if (user.username != nil)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Favoris"];
        [query whereKey:@"auteur" equalTo:[PFUser currentUser]];
        [query whereKey:@"name" equalTo:self.name.text];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error){
                if (objects.count > 0) {
                    self.favorisButton.alpha = 1.0f;
                }
            }
        }];
    }
    
    [self performSelector:@selector(retrieveFromParse)];
}

- (IBAction)valueChanged:(UISlider*)sender
{
    float index = self.explicationSlider.value;
    
    if (index < 0.5) {
        sliderValue = 0;
        [self viewWillAppear:YES];
    } else if (index > 0.5 && index < 1.5) {    
        sliderValue = 1;
        [self viewWillAppear:YES];
    } else {
        sliderValue = 2;
        [self viewWillAppear:YES];
    }
}

- (void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFavoris:(id)sender
{
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        if ([sender alpha] != 1.0f) {
            [sender setAlpha:1.0];
            PFQuery *favoris = [PFQuery queryWithClassName:@"Favoris"];
            [favoris whereKey:@"auteur" equalTo:[PFUser currentUser]];
            [favoris whereKey:@"name" equalTo:self.name.text];
            [favoris findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"%d", objects.count);
                if (objects.count == 0) {
                    PFObject *newFavoris = [PFObject objectWithClassName:@"Favoris"];
                    [newFavoris setObject:self.definition.name forKey:@"name"];
                    [newFavoris setObject:self.definition.imageFile forKey:@"imageFile"];
                    [newFavoris setObject:self.definition.categorie forKey:@"categorie"];
                    [newFavoris setObject:self.definition.explications forKey:@"explications"];
                    [newFavoris setObject:[PFUser currentUser] forKey:@"auteur"];
                    [newFavoris saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         NSLog(@"add");
                        [sender setAlpha:1.0];
                    }];
                } else {
                    for (PFObject *object in objects) {
                        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"delete in array");
                            [sender setAlpha:0.5];
                        }];
                    }
                }
            }];
        } else {
            [sender setAlpha:0.5];
            PFQuery *deleteFavoris = [PFQuery queryWithClassName:@"Favoris"];
            [deleteFavoris whereKey:@"auteur" equalTo:[PFUser currentUser]];
            [deleteFavoris whereKey:@"name" equalTo:self.name.text];
            [deleteFavoris getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"normal delete");
                    [sender setAlpha:0.5];
                }];
            }];
        }
    }
    else {
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (void)retrieveFromParse
{
    PFQuery *retrieveCommentaire = [PFQuery queryWithClassName:@"Commentaire"];
    [retrieveCommentaire whereKey:@"definition" equalTo:self.name.text];
    [retrieveCommentaire includeKey:@"auteur"];
    [retrieveCommentaire orderByDescending:@"createdAt"];
    retrieveCommentaire.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [retrieveCommentaire findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.commentairesArray = [[NSArray alloc] initWithArray:objects];
        }
        
        [self.tableView reloadData];
        
        if (self.tableView.contentSize.height == 0) {
            self.tableViewConstraintHeight.constant = self.tableView.contentSize.height;
        } else {
            self.tableViewConstraintHeight.constant = self.tableView.contentSize.height - 1;
        }
    }];
}

- (CommentaireCustomCell *)prototypeCell
{
    static NSString *CellIdentifier = @"commentaireCell";
    
    if (!_prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _prototypeCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentairesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentaireCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CommentaireCustomCell class]])
    {
        CommentaireCustomCell *aCell = (CommentaireCustomCell *)cell;
        
        PFObject *tempObject = [self.commentairesArray objectAtIndex:indexPath.row];
        
        aCell.labelCell.text = [[tempObject objectForKey:@"auteur"] objectForKey:@"username"];
        
        PFImageView *imageCell = (PFImageView *) aCell.imageCell;
        imageCell.image              = [UIImage imageNamed:@"placeholder.png"];
        imageCell.file               = [[tempObject objectForKey:@"auteur"] objectForKey:@"imageFile"];
        imageCell.layer.cornerRadius = aCell.imageCell.frame.size.width/2;
        imageCell.clipsToBounds      = YES;
        [imageCell loadInBackground];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.5;
        
        aCell.textCell.font              = [UIFont fontWithName:@"Lato-Regular" size:16];
        aCell.textCell.attributedText    = [[NSAttributedString alloc] initWithString:[tempObject objectForKey:@"message"] attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        aCell.textCell.textColor         = [UIColor grayColor];
        
        NSDate *date = [tempObject createdAt];
        aCell.dateCell.text = [date formattedAsTimeAgo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell setNeedsUpdateConstraints];
    [self.prototypeCell updateConstraintsIfNeeded];
    
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height+1;
}

#pragma mark -
#pragma mark Ajouter un commentaire

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        return YES;
    }
    else {
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:loginVC animated:YES completion:nil];
        return NO;
    }
}

- (void)textViewDidBeginEditing:(GrowingTextView *)textView
{
    if ([textView.text isEqualToString:@"Ajouter un commentaire"]) {
        textView.text = @"";
        [textView setTextColor:[UIColor grayColor]];
        [textView setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
        
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(GrowingTextView *)textView
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:charSet];
    
    if ([textView.text isEqualToString:@""] || [trimmedString isEqualToString:@""]) {
        textView.text = @"Ajouter un commentaire";
        textView.textColor = [UIColor lightGrayColor];
        [textView setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [textView resignFirstResponder];
}

- (IBAction)addComment:(id)sender
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.growingTextView.text stringByTrimmingCharactersInSet:charSet];
    
    if (![self.growingTextView.text isEqualToString:@"Ajouter un commentaire"]) {
        if ([trimmedString isEqualToString:@""]) {
            self.growingTextView.text = @"Ajouter un commentaire";
            self.growingTextView.textColor = [UIColor lightGrayColor];
            [self.growingTextView setFont:[UIFont systemFontOfSize:14.0f]];
        } else {
            PFUser *user = [PFUser currentUser];
            if (user.username != nil) {
                
                [self.tableView beginUpdates];
                
                PFObject *newCommentaire = [PFObject objectWithClassName:@"Commentaire"];
                [newCommentaire setObject:[self.name text] forKey:@"definition"];
                [newCommentaire setObject:[self.growingTextView text] forKey:@"message"];
                [newCommentaire setObject:[PFUser currentUser] forKey:@"auteur"];
                
                [newCommentaire saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self.tableView endUpdates];
                        [self viewWillAppear:YES];
                        self.growingTextView.text = @"Ajouter un commentaire";
                        self.growingTextView.textColor = [UIColor lightGrayColor];
                        [self.growingTextView setFont:[UIFont systemFontOfSize:14.0f]];
                    }
                }];
            }
        }
        [self dismissKeyboard];
    }
}

- (void)dismissKeyboard {
    [self textViewDidEndEditing:self.growingTextView];
}

@end
