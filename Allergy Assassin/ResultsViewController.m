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
#import "MJFancyOverlayView.h"

@interface ResultsViewController ()

@property AllergyAssassinResults *results;
@property NSMutableDictionary *ratings;
@property UIActivityIndicatorView *spinner;
@property MJFancyOverlayView *overlay;

@end

@implementation ResultsViewController

@synthesize results;
@synthesize spinner;
@synthesize overlay;

- (id) init {
    self = [super init];
    if (self != nil) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[self view] setBackgroundColor:[UIColor whiteColor]];
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
    if (overlay == nil) {
        overlay = [[MJFancyOverlayView alloc] initWithFrame: [[self view] frame] andDelegate:self];
        [[self view] addSubview:overlay];
    }
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
    [overlay showOverlayWithMessage:@"There is a problem with your connection." andTimeout:4.0f performBlockOnTimeout:^{
        [[self navigationController] popViewControllerAnimated:YES];
    }];
}

- (void) processResults {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[self view] frame]];
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;	
    
    NSString *caption = [results verboseResults];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 260, [[self view] frame].size.width, 60);
    [label setText:caption];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    label.textAlignment = NSTextAlignmentCenter;
    [label setNumberOfLines:0];
    [scrollView addSubview:label];

    UIImageView *image = [[UIImageView alloc] initWithImage:[results highestRatingImage]];
    image.frame = CGRectMake(10,10, 250, 250);
    image.center = CGPointMake([[self view] center].x, ([image bounds].size.height/2)+10);
    [scrollView addSubview:image];
    
    
    [[self view] addSubview:scrollView];
}

@end
