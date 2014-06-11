//
//  CategorieViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "CategorieViewController.h"
#import "CategorieCustomCell.h"

#import "ListeTableViewController.h"
#import "RESideMenu.h"

#import "Definition.h"
#import "Commentaire.h"


@interface CategorieViewController ()

@end

@implementation CategorieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadInitialData];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.collectionView setScrollEnabled:NO];
    
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self.menuButton setImage:[UIImage imageNamed:@"button-menu-grey.png"] forState:UIControlStateNormal];
    [self.menuButton setImage:[UIImage imageNamed:@"button-menu-grey.png"] forState:UIControlStateHighlighted];
    [self.menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView addSubview:self.menuButton];
}

#pragma mark -
#pragma mark ViewController LoadInitialData

- (void)loadInitialData
{
    Categorie *categorieHistoire = [[Categorie alloc] initWithName:@"L'HISTOIRE" initWithImage:@"categorie-histoire.png"];
    Categorie *categorieCorps = [[Categorie alloc] initWithName:@"LE CORPS" initWithImage:@"categorie-corps.png"];
    Categorie *categorieTerre = [[Categorie alloc] initWithName:@"LA TERRE" initWithImage:@"categorie-terre.png"];
    Categorie *categorieCiel = [[Categorie alloc] initWithName:@"LE CIEL" initWithImage:@"categorie-ciel.png"];
    Categorie *categorieAnimaux = [[Categorie alloc] initWithName:@"LES ANIMAUX" initWithImage:@"categorie-animaux.png"];
    Categorie *categorieQuotidien = [[Categorie alloc] initWithName:@"LE QUOTIDIEN" initWithImage:@"categorie-quotidien.png"];
    
    self.categories = [[NSArray alloc] initWithObjects:categorieHistoire, categorieCorps, categorieTerre, categorieCiel, categorieAnimaux, categorieQuotidien, nil];
}

#pragma mark -
#pragma mark UICollectionView Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"categorieCellPressed"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        ListeTableViewController *listeTableVC = [segue destinationViewController];
        listeTableVC.categoriePressed = [self.categories[indexPath.row] name];
    }
}

#pragma mark -
#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categorieCell";
    CategorieCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    Categorie *aCategorie = self.categories[indexPath.row];
    
    cell.imageCell.image = [UIImage imageNamed:aCategorie.imageFile];
    cell.labelCell.text = aCategorie.name;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(159.5, (self.view.frame.size.height /3));
}

@end
