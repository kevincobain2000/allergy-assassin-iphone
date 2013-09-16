//
//  MJFancyOverlayViewController.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 10/09/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJFancyOverlayView : UIControl

@property (assign) BOOL overlayShown;

- (id) initWithFrame:(CGRect) frame andDelegate:(UIViewController *) theDelegate;
- (void) showOverlayWithMessage: (NSString *) message;
- (void) showOverlayWithMessage:(NSString *)message andTimeout: (NSTimeInterval) timeout performBlockOnTimeout: (void(^) (void)) block;
- (void) hideOverlay;

@end
