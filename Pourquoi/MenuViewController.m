//
//  MenuViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 07/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "MenuViewController.h"
#import "CategorieViewController.h"
#import "ListeTableViewController.h"
#import "DefinitionViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialData];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark ViewController LoadInitialData

- (void)loadInitialData
{
    if (!self.menuBoutons)
    {
    self.menuBoutons = [[NSArray alloc] initWithObjects:@"PROFIL", @"CATEGORIES", @"LISTE", @"ALEATOIRE", @"FAVORIS", @"DEMANDER", nil];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
            PFUser *user = [PFUser currentUser];
            if (user.username != nil) {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"userViewController"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }
            else {
                LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                
                [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            break;
        }
        case 1:
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"categorieViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 2:
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"listeTableViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 3:
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Definition"];
        
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                int randomIndex = arc4random() % objects.count;
                
                DefinitionViewController * definitionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"definitionViewController"];
            
                Definition *definition = [[Definition alloc] init];
                
                PFObject *object = [objects objectAtIndex:randomIndex];
                
                PFImageView *image = [[PFImageView alloc] init];
                image.image = [UIImage imageNamed:@"placeholder.png"];
                image.file = [object objectForKey:@"imageFile"];
                [image loadInBackground];
                
                definition.name = [object objectForKey:@"name"];
                definition.imageFile = image.file;
                definition.categorie = [object objectForKey:@"categorie"];
                definition.explications = [object objectForKey:@"explications"];
                definition.commentaires = [object objectForKey:@"commentaires"];
                
                definitionVC.definition = definition;
                definitionVC.aleatoire = YES;
                
                self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:definitionVC];
            }];
            
            [self.sideMenuViewController hideMenuViewController];
            
            break;
        }
        case 4:
        {
            PFUser *user = [PFUser currentUser];
            if (user.username != nil) {
                ListeTableViewController *listeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"listeTableViewController"];
                listeVC.favoris = YES;
                
                self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:listeVC];
                [self.sideMenuViewController hideMenuViewController];
            }
            else {
                LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                
                [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            break;

        }
        case 5:
        {
            PFUser *user = [PFUser currentUser];
            if (user.username != nil) {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"demandeViewController"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }
            else {
                LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                
                [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.menuBoutons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuBoutons[indexPath.row];
    
    return cell;
}

@end
