//
//  UserViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 13/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "UserViewController.h"
#import "UserEditViewController.h"
#import "Commentaire.h"

@interface UserViewController ()

@property (nonatomic, strong) NSArray *commentairesArray;
@property (nonatomic, strong) UILabel *noResult;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.noResult = [[UILabel alloc] initWithFrame:CGRectMake(15, 380, 290, 30)];
    self.noResult.font = [UIFont systemFontOfSize:16.0f];
    self.noResult.textColor = [UIColor grayColor];
    self.noResult.text = @"0 Commentaire";
    [self.scrollView addSubview:self.noResult];
    self.noResult.hidden = YES;
    
    [self performSelector:@selector(retrieveFromParse)];
}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        self.image.image = [UIImage imageNamed:@"placeholder.png"];
        self.image.file = [object objectForKey:@"imageFile"];
        [self.image loadInBackground];
        
        self.name.text = [object objectForKey:@"username"];
        [self.name setFont:[UIFont fontWithName:@"Lora" size:20]];
    }];
}

#pragma mark -
#pragma mark UITableView Datasource

- (void)retrieveFromParse
{
    PFQuery *retrieveCommentaire = [PFQuery queryWithClassName:@"Commentaire"];
    [retrieveCommentaire whereKey:@"auteur" equalTo:[PFUser currentUser]];
    [retrieveCommentaire orderByDescending:@"createdAt"];
    retrieveCommentaire.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [retrieveCommentaire findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0) {
                self.noResult.hidden = NO;
            } else {
                self.noResult.hidden = YES;
            }
            self.commentairesArray = [[NSArray alloc] initWithArray:objects];
        }
        [self.tableView reloadData];
        
        self.tableViewConstraintHeight.constant = self.tableView.contentSize.height;
    }];
}

- (UserCustomCell *)prototypeCell
{
    static NSString *CellIdentifier = @"userCell";
    
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
    static NSString *CellIdentifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[UserCustomCell class]])
    {
        UserCustomCell *aCell = (UserCustomCell *)cell;
        
        PFObject *tempObject = [self.commentairesArray objectAtIndex:indexPath.row];
        
        aCell.definitionCell.text = [tempObject objectForKey:@"definition"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.5;
        
        aCell.textCell.font              = [UIFont fontWithName:@"Lato-Regular" size:16];
        aCell.textCell.attributedText    = [[NSAttributedString alloc] initWithString:[tempObject objectForKey:@"message"] attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        aCell.textCell.textColor         = [UIColor grayColor];
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

@end
