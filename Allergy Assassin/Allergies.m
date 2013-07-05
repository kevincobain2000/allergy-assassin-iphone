//
//  Allergies.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "Allergies.h"

NSString* const allergiesKey = @"allergies";

@interface Allergies ()

@property NSUserDefaults *defaults;
@property NSMutableArray *allergies;

@end

@implementation Allergies

@synthesize allergies;
@synthesize defaults;


- (id) init {
    return [self initWithAllergies:[NSArray arrayWithObjects:nil]];
}

- (id) initWithAllergies: (NSArray *) providedAllergies {
    self  = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([providedAllergies count] > 0) {
        allergies = [[NSMutableArray alloc] initWithArray:providedAllergies];
    } else {
        allergies = [[NSMutableArray alloc] init];
    }
    
    [self saveAllergies];
    return self;
}

- (NSSet *) getAllergies {
    return [[NSSet alloc] initWithArray:(NSArray *)allergies];
}

- (void) saveAllergies {
    [defaults removeObjectForKey:allergiesKey];
    [defaults setObject:(NSArray *)allergies forKey:allergiesKey];
}

- (void) addAllergy:(NSString *)allergy {
    [allergies addObject:allergy];
    [self saveAllergies];
}

- (void) removeAllergy:(NSString *) allergy {
    [allergies removeObject:allergy];
    [self saveAllergies];
}

+ (NSArray *) typicalAllergiesList {
    //TODO: pull from http://api.allergyassassin.com/autocomplete/allergy and store locally
    
    return @[
             @"barley",
             @"egg",
             @"garlic",
             @"gluten",
             @"kidney beans",
             @"lime",
             @"milk",
             @"nut",
             @"peanut",
             @"shellfish",
             @"soy",
             @"wheat",
             @"seafood",
             @"dairy",
             @"kidney bean"
        ];
}



@end
