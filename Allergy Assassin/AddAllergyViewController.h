//
//  AddAllergyViewController.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 04/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Allergies.h"

@interface AddAllergyViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
}

- (id) initWithAllergies:(Allergies *) allergies;

@end
