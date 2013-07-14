//
//  AllergiesViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AllergiesViewController.h"
#import "Allergies.h"
#import "AddAllergyViewController.h"

@interface AllergiesViewController ()

@end

@interface AllergiesInternalViewController: UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property Allergies *allergies;
@property NSArray *allergiesList;


- (id) init;
- (id) initWithAllergies: (Allergies *) allergies;

@end

@implementation AllergiesViewController

- (id)init
{
    self = [super init];

    _internalViewController = [[AllergiesInternalViewController alloc]
            initWithAllergies:[[Allergies alloc] init]];
    [self pushViewController:_internalViewController animated:NO];
    
    [self setToolbarHidden:YES];
    return self;
}

@end

@implementation AllergiesInternalViewController

@synthesize allergies;
@synthesize allergiesList;

- (id) init {
    allergies = [[Allergies alloc] init];
    return [self initWithAllergies:allergies];
}

- (id) initWithAllergies: (Allergies *) theAllergies {
    self = [super init];
    if (self != nil) {
        allergies = theAllergies;
        
        self.title = @"Allergies";

        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target: self action: @selector(addAllergyButtonWasPressed)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [self setEditing:YES];

    allergiesList = [[allergies getAllergies] allObjects];
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void) addAllergyButtonWasPressed {
    UIViewController *addAllergyView = [[AddAllergyViewController alloc] initWithAllergies:allergies];
    [self.navigationController pushViewController:addAllergyView animated:YES];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [allergiesList count];
    } else {
        [NSException raise:@"Multiple sections in allergy list - should only be one" format:@""];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [allergiesList objectAtIndex:indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell *cellToDelete = [tableView cellForRowAtIndexPath:indexPath];
        NSString *allergy = cellToDelete.textLabel.text;
        [allergies removeAllergy:allergy];
        
        allergiesList = [[allergies getAllergies] allObjects];
        [self.tableView reloadData];
    }
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
