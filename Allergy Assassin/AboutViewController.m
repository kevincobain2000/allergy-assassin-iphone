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
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"applogo.png"]];
    [logo setFrame:CGRectMake(0,0,
                              MIN([[self view] frame].size.width*0.75, [logo frame].size.width),
                              MIN([[self view] frame].size.width*0.75
                                  , [logo frame].size.width))];
    logo.center = CGPointMake([[self view] frame].size.width/2, logo.center.y);
    
    UITextView *url = [[UITextView alloc] initWithFrame:CGRectZero];
    [url setTextAlignment:NSTextAlignmentCenter];
    [url setText:@"http://allergyassassin.com"];
    [url setTextAlignment:NSTextAlignmentCenter];
    [url setCenter:CGPointMake([[self view] center].x, [logo frame].size.height+10)];
    url.editable = NO;
    
    UITextView *description = [[UITextView alloc]
        initWithFrame:CGRectMake([url frame].origin.x,
                                 [url frame].origin.y + 10,
                                 120, 30)];
    [description setTextAlignment:NSTextAlignmentRight];
    [description setText:@"by Matt Jackson"];
    description.editable = NO;
    
    UITextView *version = [[UITextView alloc]
        initWithFrame:CGRectMake([url frame].origin.y + [url frame].size.width-50,
                                 [description frame].origin.y,
                                 50,
                                 30)];
    [version setText:[NSString stringWithFormat:@"v%@",  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    version.editable = NO;
    
    
    UIImageView *infoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]];
    [infoIcon setFrame:CGRectMake(0, [description frame].origin.y + 30,
                                  [[self view] frame].size.width , 30)];
    [infoIcon setContentMode:UIViewContentModeScaleAspectFit];
    
    UITextView *infoText = [[UITextView alloc]
        initWithFrame:CGRectMake(0,[infoIcon frame].origin.y + 35,
                                 [[self view] frame].size.width, 120)];
    [infoText setText:[AllergyAssassinSearch disclaimer]];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    infoText.editable = NO;
    
    [[self view] addSubview:logo];
    [[self view] addSubview:url];
    [[self view] addSubview:description];
    [[self view] addSubview:version];
    [[self view] addSubview:infoIcon];
    [[self view] addSubview:infoText];
}

@end
