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
#import "AboutViewController.h"
#import "Allergies.h"

@interface SearchViewController ()

@end


@interface SearchInternalViewController: UITableViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
}
@property (retain) AllergyAssassinSearch *aaSearch;
@property (retain) Allergies *allergies;
@property (retain) NSArray *warningControls;
@property (retain) NSArray *autocompleteSearch;


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
@synthesize autocompleteSearch;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.title = @"Search";
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Enter Dish Name";
        
        [self.tableView setTableHeaderView:searchBar];
                
    }
    
    return self;
}

- (void) viewDidLoad {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // info button in pad interface
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [infoButton addTarget:self action:@selector(infoButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showInfo];
    UISearchBar *searchBar = (UISearchBar *) [self.tableView tableHeaderView];
    [searchBar setText:@""];
    autocompleteSearch = @[];
    [self.tableView reloadData];
}

- (void) showInfo {
    UIImageView *infoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    
    infoImage.frame = CGRectMake(0,0, 35, 35);
    infoImage.center = CGPointMake([[self view] center].x, [self.tableView frame].origin.y + infoImage.frame.size.height+28);
    
    UITextView *infoText = [[UITextView alloc] initWithFrame:CGRectMake(0,0,[[self tableView] frame].size.width, 90)];
    infoText.center = CGPointMake(infoImage.center.x, infoImage.center.y + 70);
        
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

- (void) infoButtonWasPressed {
    UIViewController *aboutViewController = [[AboutViewController alloc] init];

    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    [toolBar setItems:@[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeModalView)]]];
    [aboutViewController.view addSubview:toolBar];
                        
    [[[[self view] window] rootViewController] presentViewController:aboutViewController animated:YES completion:nil];
}

- (void) closeModalView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark UISearchBarDelegate methods
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self hideInfo];
    [searchBar setShowsCancelButton:YES animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        autocompleteSearch = [ [Allergies recipeList] filteredArrayUsingPredicate:
                         [NSPredicate predicateWithBlock:^BOOL(id recipeString, NSDictionary *bindings) {
            NSRange rangeResult = [(NSString *) recipeString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            return rangeResult.location != NSNotFound;
        }
                          ]];
        autocompleteSearch = [autocompleteSearch arrayByAddingObject:searchText];
    } else {
        autocompleteSearch = @[];
    }
    
    [self.tableView reloadData];
    
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

#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autocompleteSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [autocompleteSearch objectAtIndex:[indexPath item]];
    
    return cell;
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UISearchBar *searchBar = (UISearchBar *) [tableView tableHeaderView];
    
    [searchBar resignFirstResponder];
    [self searchForDish:[searchBar text]];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:@""];
}

@end