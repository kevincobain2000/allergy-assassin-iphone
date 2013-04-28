//
//  Allergies.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* const allergiesKey;

@interface Allergies : NSObject

@property (nonatomic, retain) NSSet *allergies;


- (id) init;
- (id) initWithAllergies:(NSArray *) allergies;
- (void) setAllergies:(NSArray *)allergies;
- (NSSet *) getAllergies;
- (void) addAllergy:(NSString *)allergy;
- (void) removeAllergy:(NSString *) allergy;


@end
