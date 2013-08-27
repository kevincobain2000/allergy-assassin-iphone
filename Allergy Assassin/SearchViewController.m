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
@property (retain) NSArray *warningControls;


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

@end


@implementation SearchInternalViewController

@synthesize aaSearch;
@synthesize allergies;
@synthesize warningControls;

- (id) init {
    self = [super init];
    
    if (self != nil) {
        self.title = @"Search";
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Enter Dish Name";
        
        [self.tableView setTableHeaderView:searchBar];
        
        [self showInfo];
    }
    return self;
}

- (void) showInfo {
    UIImageView *infoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    
    infoImage.frame = CGRectMake(0,0, 35, 35);
    infoImage.center = CGPointMake([[self view] center].x, [[self view] frame].origin.y + infoImage.frame.size.width+10);
    
    UITextView *infoText = [[UITextView alloc] initWithFrame:CGRectMake(0,0,[[self view] frame].size.width, 90)];
    infoText.center = CGPointMake(infoImage.center.x, infoImage.center.y + 70);
    [infoText setBackgroundColor:[UIColor whiteColor]];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    [infoText setText:[AllergyAssassinSearch disclaimer]];
    
    warningControls = @[infoImage, infoText];
    [[self view] addSubview:infoImage];
    [[self view] addSubview:infoText];
}

- (void) hideInfo {
    for (UIView *control in warningControls) {
        [control removeFromSuperview];
    }
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
    [self hideInfo];
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