//
//  MJFancyOverlayViewController.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 10/09/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "MJFancyOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@interface MJFancyOverlayView ()

@property (retain) UILabel *overlayText;
@property (assign) UIViewController *delegate;

@end

@implementation MJFancyOverlayView

@synthesize overlayText;
@synthesize overlayShown;
@synthesize delegate;

- (id) initWithFrame:(CGRect) frame andDelegate:(UIViewController *) theDelegate {
    self = [super initWithFrame:frame];
    delegate = theDelegate;
    [self loadControls];
    return self;
}

- (void) loadControls {
    [self setAlpha:0.0f];
    
    UIView *overlayBg = [[UIView alloc] initWithFrame:[self frame]];
    [overlayBg setBackgroundColor:[UIColor blackColor]];
    [overlayBg setAlpha:0.7f];
    [self addSubview:overlayBg];
    
    UIView *messageFrame = [[UIView alloc] initWithFrame:CGRectMake(0,0,180,180)];
    [messageFrame setBackgroundColor:[UIColor blackColor]];
    [messageFrame setAlpha:0.9f];
    [messageFrame setCenter:[overlayBg center]];
    [[messageFrame layer] setCornerRadius:10.0f];
    [[messageFrame layer] setMasksToBounds:YES];
    [self addSubview:messageFrame];
    
    CGRect exclaimFrame = CGRectMake(
             [messageFrame frame].origin.x,
             [messageFrame frame].origin.y,
             [messageFrame frame].size.width,
             [messageFrame frame].size.height * (2.0f/3.0f));
    UILabel *exclaim = [[UILabel alloc] initWithFrame:exclaimFrame];
    [exclaim setBackgroundColor:[UIColor clearColor]];
    [exclaim setTextColor:[UIColor whiteColor]];
    [exclaim setText:@"!"];
    [exclaim setTextAlignment:NSTextAlignmentCenter];
    [exclaim setFont:[UIFont boldSystemFontOfSize:52]];
    [self addSubview:exclaim];  
    
    CGRect overlayTextFrame = CGRectMake(
            [messageFrame frame].origin.x,
            [messageFrame frame].origin.y + [messageFrame frame].size.height * (2.0f/3.0f),
            [messageFrame frame].size.width,
            [messageFrame frame].size.height * (1.0f/3.0f));
    
    overlayText = [[UILabel alloc] initWithFrame:overlayTextFrame];
    [overlayText setBackgroundColor:[UIColor clearColor]];
    [overlayText setTextColor:[UIColor whiteColor]];
    [overlayText setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:overlayText];
}

- (void) showOverlayWithMessage: (NSString *) message {
    [[delegate view] bringSubviewToFront:self];
    [overlayText setText:message];
    [UIView animateWithDuration:0.7f animations:^{ [self setAlpha:1.0f]; }];
    overlayShown = YES;
}

- (void) hideOverlay {
    [UIView animateWithDuration:0.7f animations:^{ [self setAlpha:0.0f]; }];
    overlayShown = NO;
}


@end
