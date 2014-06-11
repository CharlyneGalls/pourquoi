//
//  ListeTableViewController.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "ListeTableViewController.h"
#import "ListeCustomCell.h"
#import "DefinitionViewController.h"
#import "RESideMenu.h"
#import "Definition.h"

@interface ListeTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UILabel *noResult;

@end

@implementation ListeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    self.searchResults = [NSMutableArray array];
    self.searchDisplayController.searchBar.hidden = YES;
    [self.tableView setTableHeaderView:nil];
    
    self.noResult = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 290, 30)];
    self.noResult.font = [UIFont boldSystemFontOfSize:20.0f];
    self.noResult.textColor = [UIColor lightGrayColor];
    self.noResult.text = @"0 Pourquoi";
    self.noResult.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noResult];
    
    self.noResult.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.searchDisplayController.active == YES) {
        self.menuButton = nil;
        self.searchButton = nil;
    } else {
        if ((!self.menuButton) || (!self.searchButton)) {
            self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateNormal];
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateHighlighted];
            [self.menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.menuButton];
            
            self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 45, 45)];
            [self.searchButton setImage:[UIImage imageNamed:@"button-search-white.png"] forState:UIControlStateNormal];
            [self.searchButton setImage:[UIImage imageNamed:@"button-search-white.pn"] forState:UIControlStateHighlighted];
            [self.searchButton addTarget:self action:@selector(displaySearchBar:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.searchButton];
        }
    }
    
    if (!self.tableView.tableHeaderView) {
        self.searchButton.hidden = NO;
        self.menuButton.hidden = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.menuButton.frame = CGRectMake(0, scrollView.contentOffset.y, 45, 45);
    self.searchButton.frame = CGRectMake(275, scrollView.contentOffset.y, 45, 45);

    [self.view bringSubviewToFront:self.menuButton];
    [self.view bringSubviewToFront:self.searchButton];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listeCellPressed"]) {
        DefinitionViewController *definitionVC = [segue destinationViewController];
        
        NSIndexPath *indexPath = nil;
        Definition *definition = [[Definition alloc] init];

        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            PFObject *object = [self.searchResults objectAtIndex:indexPath.row];
            definition.name = [object objectForKey:@"name"];
            definition.imageFile = [object objectForKey:@"imageFile"];
            definition.categorie = [object objectForKey:@"categorie"];
            definition.explications = [object objectForKey:@"explications"];
            definition.commentaires = [object objectForKey:@"commentaires"];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            
            PFObject *object = [self.objects objectAtIndex:indexPath.row];
            definition.name = [object objectForKey:@"name"];
            definition.imageFile = [object objectForKey:@"imageFile"];
            definition.categorie = [object objectForKey:@"categorie"];
            definition.explications = [object objectForKey:@"explications"];
            definition.commentaires = [object objectForKey:@"commentaires"];
        }
        
        definitionVC.definition = definition;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Definition";
        self.textKey = @"name";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    if (self.favoris) {
        PFQuery *query = [PFQuery queryWithClassName:@"Favoris"];
        [query whereKey:@"auteur" equalTo:[PFUser currentUser]];
        [query orderByDescending:@"createdAt"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        return query;
    }
    else {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        if (self.categoriePressed != nil) {
            [query whereKey:@"categorie" equalTo:self.categoriePressed];
        }
        [query orderByAscending:@"name"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        return query;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (self.objects.count == 0) {
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-grey.png"] forState:UIControlStateNormal];
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-grey.png"] forState:UIControlStateHighlighted];
            self.noResult.hidden = NO;
            self.searchButton.hidden = YES;
        } else {
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateNormal];
            [self.menuButton setImage:[UIImage imageNamed:@"button-menu-white.png"] forState:UIControlStateHighlighted];
            self.noResult.hidden = YES;
            self.searchButton.hidden = NO;
        }
        return self.objects.count;
    } else {
        return self.searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    static NSString *CellIdentifier = @"listeCell";
    ListeCustomCell *cell = (ListeCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ListeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        PFImageView *imageCell = (PFImageView *) cell.imageCell;
        
        imageCell.image = [UIImage imageNamed:@"placeholder.png"];
        imageCell.file = [object objectForKey:@"imageFile"];
        [imageCell loadInBackground];
        
        cell.labelCell.text = [object objectForKey:@"name"];
        [cell.labelCell setFont:[UIFont fontWithName:@"Lora" size:20]];
    }
    
    else if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        PFObject *searchedUser = [self.searchResults objectAtIndex:indexPath.row];
        
        PFImageView *imageCell = (PFImageView *) cell.imageCell;
        
        imageCell.image = [UIImage imageNamed:@"placeholder.png"];
        imageCell.file = [searchedUser objectForKey:@"imageFile"];
        [imageCell loadInBackground];

        
        cell.labelCell.text = [searchedUser objectForKey:@"name"];
        [cell.labelCell setFont:[UIFont fontWithName:@"Lora" size:20]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 251;
}

#pragma mark -
#pragma mark SearchBar implementation

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (void)callbackWithResult:(NSArray *)resultats error:(NSError *)error
{
    if(!error) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:resultats];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)filterResults:(NSString *)searchTerm
{
    if (self.categoriePressed != nil) {
        PFQuery *queryCapitalizedString = [PFQuery queryWithClassName:self.parseClassName];
        [queryCapitalizedString whereKey:@"name" containsString:[searchTerm capitalizedString]];
        [queryCapitalizedString whereKey:@"categorie" equalTo:self.categoriePressed];
        
        PFQuery *queryLowerCaseString = [PFQuery queryWithClassName:self.parseClassName];
        [queryLowerCaseString whereKey:@"name" containsString:[searchTerm lowercaseString]];
        [queryLowerCaseString whereKey:@"categorie" equalTo:self.categoriePressed];
        
        PFQuery *querySearchBarString = [PFQuery queryWithClassName:self.parseClassName];
        [querySearchBarString whereKey:@"categorie" equalTo:self.categoriePressed];
        [querySearchBarString whereKey:@"name" containsString:searchTerm];
        
        PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
        finalQuery.limit = 100;
        finalQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [finalQuery findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    }
    
    else if (self.favoris)
    {
        PFQuery *queryCapitalizedString = [PFQuery queryWithClassName:@"Favoris"];
        [queryCapitalizedString whereKey:@"name" containsString:[searchTerm capitalizedString]];
        [queryCapitalizedString whereKey:@"auteur" equalTo:[PFUser currentUser]];
        
        PFQuery *queryLowerCaseString = [PFQuery queryWithClassName:@"Favoris"];
        [queryLowerCaseString whereKey:@"name" containsString:[searchTerm lowercaseString]];
        [queryLowerCaseString whereKey:@"auteur" equalTo:[PFUser currentUser]];
        
        PFQuery *querySearchBarString = [PFQuery queryWithClassName:@"Favoris"];
        [querySearchBarString whereKey:@"auteur" equalTo:[PFUser currentUser]];
        [querySearchBarString whereKey:@"name" containsString:searchTerm];
        
        PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
        finalQuery.limit = 100;
        finalQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [finalQuery findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    }
    
    else {
        PFQuery *queryCapitalizedString = [PFQuery queryWithClassName:self.parseClassName];
        [queryCapitalizedString whereKey:@"name" containsString:[searchTerm capitalizedString]];
        
        PFQuery *queryLowerCaseString = [PFQuery queryWithClassName:self.parseClassName];
        [queryLowerCaseString whereKey:@"name" containsString:[searchTerm lowercaseString]];
        
        PFQuery *querySearchBarString = [PFQuery queryWithClassName:self.parseClassName];
        [querySearchBarString whereKey:@"name" containsString:searchTerm];
        
        PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
        finalQuery.limit = 100;
        finalQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [finalQuery findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchDisplayController setActive:YES];
}

- (IBAction)displaySearchBar:(id)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    NSTimeInterval delay;
    if (self.tableView.contentOffset.y >1000) delay = 0.4;
    else delay = 0.1;
    [self performSelector:@selector(activateSearch) withObject:nil afterDelay:delay];
    
    self.searchDisplayController.searchBar.hidden = NO;
    [self.tableView setTableHeaderView:self.searchDisplayController.searchBar];
    self.menuButton.hidden = YES;
    self.searchButton.hidden = YES;
}

- (void)activateSearch {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self viewWillAppear:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.hidden = YES;
    [self.tableView setTableHeaderView:nil];
    [self viewWillAppear:YES];
}

@end
