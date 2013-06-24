//
//  SearchViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 24/06/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end


@interface SearchInternalViewController: UITableViewController <UISearchBarDelegate> {
}

- (id) init;

@end


@implementation SearchViewController

- (id) init {
    self = [super init];

    _internalViewController = [[SearchInternalViewController alloc] init];
    [self pushViewController:_internalViewController animated:NO];
    
    [self setToolbarHidden:NO];
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

- (id) init {
    self = [super init];
    self.title = @"Search";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Enter Dish Name";
    
    [self.tableView setTableHeaderView:searchBar];
    return self;
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
}

@end