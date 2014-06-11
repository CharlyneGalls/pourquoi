//
//  UserViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 13/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserCustomCell.h"
#import "User.h"

@interface UserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) User *user;
@property (nonatomic, strong) UserCustomCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraintHeight;

@end