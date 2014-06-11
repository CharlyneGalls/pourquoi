//
//  ListeTableViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definition.h"
#import <Parse/Parse.h>

@interface ListeTableViewController : PFQueryTableViewController

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) NSArray *definitions;
@property (strong, nonatomic) NSString *categoriePressed;
@property (nonatomic, assign) BOOL favoris;

@end
