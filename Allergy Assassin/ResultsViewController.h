//
//  ResultsViewController.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 07/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllergyAssassinSearch.h"

@interface ResultsViewController : UIViewController

- (id) initWithResults:(AllergyAssassinResults *) theResults;
- (void) receiveResults:(AllergyAssassinResults *) theResults;
- (void) receiveError:(NSError *) error;

@end
