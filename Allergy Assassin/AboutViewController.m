//
//  AboutViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 18/08/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AboutViewController.h"
#import "AllergyAssassinSearch.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void) viewDidLoad {
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*  not the ideal method to use for laying stuff out, but before this point
     * UI dimensions seem to be incorrectly reported in portrait instead of landscape?
     * Copious googling didn't glean any results, investigate further in future. */
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    CGRect viewFrame = [[self view] frame];
    
    
    //deal with overlapping status bar in iOS7 - this is really annoying & there must be a better way!
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f &&
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewFrame.origin.y = viewFrame.origin.y + 20;
    }
    
    CGPoint frameCentre = [[self view] center];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"applogo.png"]];
    [logo setFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y,
                              MIN(viewFrame.size.width*0.75, [logo frame].size.width),
                              MIN(viewFrame.size.width*0.75, [logo frame].size.width))];
    [logo setCenter:CGPointMake(viewFrame.size.width/2, logo.center.y)];

    
    UITextView *url = [[UITextView alloc] initWithFrame:
        CGRectMake(viewFrame.origin.x, [logo frame].origin.y + [logo frame].size.height,
                   viewFrame.size.width, 80)];
    [url setText:@"http://allergyassassin.com"];
    [url setTextAlignment:NSTextAlignmentCenter];
    url.editable = NO;
    [url setDataDetectorTypes:UIDataDetectorTypeLink];
    
    UITextView *description = [[UITextView alloc]
        initWithFrame:CGRectMake(0,
                                 [url frame].origin.y + 25,
                                 viewFrame.size.width,
                                 30)];
    [description setTextAlignment:NSTextAlignmentCenter];
    [description setText:[NSString stringWithFormat:@" v%@ by Matt Jackson",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    description.editable = NO;
    
    
    UIImageView *infoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    [infoIcon setFrame:CGRectMake(0, [description frame].origin.y + 35,
                                  viewFrame.size.width , 30)];
    [infoIcon setContentMode:UIViewContentModeScaleAspectFit];
    
    UITextView *infoText = [[UITextView alloc]
        initWithFrame:CGRectMake(0,[infoIcon frame].origin.y + 30,
                                 viewFrame.size.width, 120)];
    [infoText setText:[AllergyAssassinSearch disclaimer]];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    infoText.editable = NO;
    
    [[self view] addSubview:logo];
    [[self view] addSubview:url];
    [[self view] addSubview:description];
    [[self view] addSubview:infoIcon];
    [[self view] addSubview:infoText];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for(UIView *view in [[self view] subviews]) {
        [view removeFromSuperview];
    }
}

@end
