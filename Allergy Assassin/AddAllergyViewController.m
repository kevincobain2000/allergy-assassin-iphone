//
//  AddAllergyViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 04/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AddAllergyViewController.h"
#import "Allergies.h"


@interface AddAllergyViewController ()

@property Allergies *allergies;
@property NSArray *someAllergies;
@property UISearchBar *searchBar;

@end

@implementation AddAllergyViewController

@synthesize allergies;
@synthesize someAllergies;
@synthesize searchBar;

- (id) initWithAllergies:(Allergies *) theAllergies {
    self = [super init];
    if (self != nil) {
        self.allergies = theAllergies;
        self.someAllergies = [Allergies typicalAllergiesList];
        self.title = @"Add Allergy";
        
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 72)];
        searchBar.delegate = self;
        searchBar.prompt = @"Type your allergy or choose from one below.";
        searchBar.placeholder = @"e.g. wheat, shellfish, oats etc...";
        
        // weird hack to set return key type on UISearchBar
        for(UIView *subView in searchBar.subviews) {
            if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
                [(UITextField *)subView setReturnKeyType:UIReturnKeyDone];
                
            }
        }
        
        
        [self.tableView setTableHeaderView:searchBar];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [searchBar becomeFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [someAllergies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [someAllergies objectAtIndex:[indexPath item]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *allergy = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [allergies addAllergy:allergy];
    [self.navigationController popViewControllerAnimated:YES];
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
    [allergies addAllergy:searchBar.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
