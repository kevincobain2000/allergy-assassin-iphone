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
@property (retain) UIViewController *delegate;
@property (nonatomic, copy) void(^timeoutBlock)(void);

@end

@implementation MJFancyOverlayView

@synthesize overlayText;
@synthesize overlayShown;
@synthesize delegate;
@synthesize timeoutBlock;

- (id) initWithFrame:(CGRect) frame andDelegate:(UIViewController *) theDelegate {
    self = [super initWithFrame:frame];
    delegate = theDelegate;
    [self loadControls];
    [self addTarget:self action:@selector(receiveTapEvent:) forControlEvents:UIControlEventTouchDown];
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
             [messageFrame frame].size.height * (5.0f/8.0f));
    UILabel *exclaim = [[UILabel alloc] initWithFrame:exclaimFrame];
    [exclaim setBackgroundColor:[UIColor clearColor]];
    [exclaim setTextColor:[UIColor whiteColor]];
    [exclaim setText:@"!"];
    [exclaim setTextAlignment:NSTextAlignmentCenter];
    [exclaim setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:102]];
    [self addSubview:exclaim];  
    
    CGRect overlayTextFrame = CGRectMake(
            [messageFrame frame].origin.x+3,
            [messageFrame frame].origin.y + [messageFrame frame].size.height * (5.0f/8.0f),
            [messageFrame frame].size.width-6,
            [messageFrame frame].size.height * (3.0f/8.0f));
    
    overlayText = [[UILabel alloc] initWithFrame:overlayTextFrame];
    [overlayText setBackgroundColor:[UIColor clearColor]];
    [overlayText setTextColor:[UIColor whiteColor]];
    [overlayText setTextAlignment:NSTextAlignmentCenter];
    [overlayText setAdjustsFontSizeToFitWidth:YES];
    [overlayText setNumberOfLines:3];
    [self addSubview:overlayText];
}

- (void) showOverlayWithMessage: (NSString *) message {
    [[delegate view] bringSubviewToFront:self];
    [overlayText setText:message];
    [UIView animateWithDuration:0.7f animations:^{ [self setAlpha:1.0f]; }];
    overlayShown = YES;
}

- (void) showOverlayWithMessage:(NSString *)message andTimeout: (NSTimeInterval) timeout performBlockOnTimeout: (void(^) (void)) block {
    [self showOverlayWithMessage:message];
    timeoutBlock = block;
    [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(executeTimeout) userInfo:nil repeats:NO];
    
}

- (void) receiveTapEvent: (UIEvent *) event {
    if (timeoutBlock) {
        [self executeTimeout];
    } else {
        [self hideOverlay];
    }
}

- (void) hideOverlay {
    [UIView animateWithDuration:0.7f animations:^{ [self setAlpha:0.0f]; }];
    overlayShown = NO;
}

- (void) executeTimeout {
    if(timeoutBlock) {
        timeoutBlock();
        timeoutBlock = nil;
    }
}


@end
