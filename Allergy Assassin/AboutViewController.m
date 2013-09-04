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

- (void) loadView {
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"applogo.png"]];
    [logo setFrame:CGRectMake(0,0,
                              MIN([[self view] frame].size.width*0.75, [logo frame].size.width),
                              MIN([[self view] frame].size.width*0.75
                                  , [logo frame].size.width))];
    [logo setCenter:CGPointMake([[self view] frame].size.width/2, logo.center.y)];
    
    UITextView *url = [[UITextView alloc] initWithFrame:
        CGRectMake(0, 0,
                   [self view].frame.size.width, 80)];
    [url setText:@"http://allergyassassin.com"];
    [url setTextAlignment:NSTextAlignmentCenter];
    [url setCenter:CGPointMake([[self view] center].x, [logo frame].size.height+45)];
    url.editable = NO;
    [url setDataDetectorTypes:UIDataDetectorTypeLink];
    
    UITextView *description = [[UITextView alloc]
        initWithFrame:CGRectMake(0,
                                 [url frame].origin.y + 25,
                                 [self view].frame.size.width,
                                 30)];
    [description setTextAlignment:NSTextAlignmentCenter];
    [description setText:[NSString stringWithFormat:@" v%@ by Matt Jackson",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    description.editable = NO;
    
    
    UIImageView *infoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    [infoIcon setFrame:CGRectMake(0, [description frame].origin.y + 35,
                                  [[self view] frame].size.width , 30)];
    [infoIcon setContentMode:UIViewContentModeScaleAspectFit];
    
    UITextView *infoText = [[UITextView alloc]
        initWithFrame:CGRectMake(0,[infoIcon frame].origin.y + 30,
                                 [[self view] frame].size.width, 120)];
    [infoText setText:[AllergyAssassinSearch disclaimer]];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    infoText.editable = NO;
    
    [[self view] addSubview:logo];
    [[self view] addSubview:url];
    [[self view] addSubview:description];
    [[self view] addSubview:infoIcon];
    [[self view] addSubview:infoText];
}

@end
