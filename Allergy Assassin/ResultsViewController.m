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
@property UIActivityIndicatorView *spinner;

@end

@implementation ResultsViewController

@synthesize results;
@synthesize spinner;

- (id) init {
    self = [super init];
    if (self != nil) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (id) initWithResults: (AllergyAssassinResults *) theResults {
    self = [self init];
    if (self != nil) {
        results = theResults;
    }
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self showThrobber];
} 

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] popToRootViewControllerAnimated:NO];
}

- (void) showThrobber {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [spinner startAnimating];
    spinner.center = [[self view] center];
    [[self view] addSubview:spinner];
}

- (void) hideThrobber {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [spinner removeFromSuperview];
}


- (void) receiveResults:(AllergyAssassinResults *)theResults {
    [self hideThrobber];
    results = theResults;
    [self processResults];
}

- (void) receiveError:(NSError *) error {
    [self hideThrobber];
    NSLog(@"It's all gone Pete Tong.");
}

- (void) processResults {
    //UIScrollView *scrollView = [[UIScrollView alloc] init];
    UIView *scrollView = [self view];
    
    NSString *caption = [results verboseResults];
    UILabel *label = [[UILabel alloc] initWithFrame:[[self view] frame]];
    [label setText:caption];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [scrollView addSubview: [[UIImageView alloc] initWithImage:[results highestRatingImage]]];
    [scrollView addSubview:label];
    
   // [[self view] addSubview:scrollView];
    
}

@end
