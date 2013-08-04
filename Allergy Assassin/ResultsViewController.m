//
//  ResultsViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 07/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "ResultsViewController.h"
#import "AllergyAssassinSearch.h"
#import "NSArray+AAAdditions.h"

@interface ResultsViewController ()

@property AllergyAssassinResults *results;
@property NSMutableDictionary *ratings;

@end

@implementation ResultsViewController

@synthesize results;

- (id) initWithResults: (AllergyAssassinResults *) theResults {
    self = [self init];
    if (self != nil) {
        results = theResults;
    }
    return self;
}


- (void) receiveResults:(AllergyAssassinResults *)theResults {
    results = theResults;
    [self processResults];
}

- (void) receiveError:(NSError *) error {
    NSLog(@"It's all gone Pete Tong.");
}

- (void) processResults {
    NSString *caption = [results verboseResults];
    UILabel *label = [[UILabel alloc] initWithFrame:[[self view] frame]];
    [label setText:caption];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor yellowColor]];
    [label setBackgroundColor:[UIColor redColor]];
    [[self view] addSubview:label];
    
}

@end
