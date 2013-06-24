//
//  SearchViewController.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 24/06/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchInternalViewController;

@interface SearchViewController : UINavigationController {
    SearchInternalViewController *_internalViewController;
}

@end
