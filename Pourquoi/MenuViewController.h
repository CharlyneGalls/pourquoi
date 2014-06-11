//
//  MenuViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 07/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RESideMenu.h"
#import "Definition.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * menuBoutons;
@property (strong, nonatomic) NSMutableArray * definitions;

@end
