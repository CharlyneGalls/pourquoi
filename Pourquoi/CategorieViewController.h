//
//  CategorieViewController.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categorie.h"

@interface CategorieViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *definitions;

- (void)loadInitialData;

@end
