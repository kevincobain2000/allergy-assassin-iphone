//
//  AllergiesViewController.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllergiesInternalViewController;

@interface AllergiesViewController : UINavigationController <UISplitViewControllerDelegate> {
    AllergiesInternalViewController *_internalViewController;
}

@end
