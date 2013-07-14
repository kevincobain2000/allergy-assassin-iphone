//
//  SearchViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 24/06/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"
#import "AllergyAssassinSearch.h"

@interface SearchViewController ()

@end


@interface SearchInternalViewController: UITableViewController <UISearchBarDelegate> {
}
@property (retain) AllergyAssassinSearch *aaSearch;
@property (retain) Allergies *allergies;


- (id) init;
- (void) searchForDish:(NSString *) dish;

@end


@implementation SearchViewController

- (id) init {
    self = [super init];

    _internalViewController = [[SearchInternalViewController alloc] init];
    [self pushViewController:_internalViewController animated:NO];
    
    [self setToolbarHidden:YES];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation SearchInternalViewController

@synthesize aaSearch;
@synthesize allergies;

- (id) init {
    self = [super init];
    self.title = @"Search";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Enter Dish Name";
    
    [self.tableView setTableHeaderView:searchBar];
    return self;
}

- (void) searchForDish: (NSString *) dish {
    aaSearch = [[AllergyAssassinSearch alloc] init];
    ResultsViewController *resultsView = [[ResultsViewController alloc] init];
    [self.navigationController pushViewController:resultsView animated:YES];
    
    [aaSearch searchForDish:dish andOnResults: ^(AllergyAssassinResults *results) {
        [resultsView receiveResults:results];
    } andOnFailure:^(NSError *error) {
        [resultsView receiveError:error];
    }];
    
}

# pragma mark UISearchBarDelegate methods
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchForDish:[searchBar text]];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:@""];
}

@end