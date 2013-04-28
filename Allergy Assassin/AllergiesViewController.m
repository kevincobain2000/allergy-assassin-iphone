//
//  AllergiesViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AllergiesViewController.h"
#import "Allergies.h"

@interface AllergiesViewController ()

@end

@interface AllergiesInternalViewController: UITableViewController {
    
}

- (id) init;
- (id) initWithAllergies: (Allergies *) allergies;

@end

@implementation AllergiesViewController

- (id)init
{
    AllergiesInternalViewController *internalViewController =
        [[AllergiesInternalViewController alloc]
            initWithAllergies:[Allergies init]];
    [self pushViewController:internalViewController animated:NO];
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

@implementation AllergiesInternalViewController

NSArray *allergiesList;
Allergies *allergies;

- (id) init {
    allergies = [Allergies init];
    return [self initWithAllergies:allergies];
}

- (id) initWithAllergies: (Allergies *)allergies {
    allergiesList = [[allergies getAllergies] allObjects];
    self = [self initWithStyle:UITableViewStylePlain];
    return self;
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
    return @"Allergies";
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell *cellToDelete = [tableView cellForRowAtIndexPath:indexPath];
        NSString *allergy = cellToDelete.textLabel.text;
        [allergies removeAllergy:allergy];
    }
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark UIViewController methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
@end
