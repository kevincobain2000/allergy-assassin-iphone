//
//  Allergies.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "Allergies.h"

NSString* const allergiesKey = @"allergies";

@implementation Allergies

@synthesize allergies;
NSUserDefaults *defaults;


- (id) init {
    return [self initWithAllergies:[NSArray arrayWithObjects:nil]];
}

- (id) initWithAllergies: (NSArray *) providedAllergies {
    self  = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([providedAllergies count] > 0) {
        allergies = [NSSet setWithArray:providedAllergies];
        [self saveAllergies];
    } else {
        allergies = [self getAllergies];
    }
        
    return self;
}

- (void)setAllergies:(NSArray *)providedAllergies {
    [self setAllergiesWithSet:[NSSet setWithArray:providedAllergies]];
}

- (void)setAllergiesWithSet: (NSSet *) providedAllergies {
    allergies = providedAllergies;
    [self saveAllergies];
}

- (NSSet *) getAllergies {
    NSSet *storedAllergies = [defaults objectForKey:allergiesKey];
    if (storedAllergies == nil)
        storedAllergies = [[NSSet alloc] init];
    return storedAllergies;
}

- (void) saveAllergies {
    [defaults removeObjectForKey:allergiesKey];
    [defaults setObject:self.allergies forKey:allergiesKey];
}

- (void) addAllergy:(NSString *)allergy {
    NSMutableArray *newAllergies = [NSMutableArray arrayWithObjects: [self.allergies allObjects]];
    [newAllergies addObject:allergy];
    [self setAllergies:newAllergies];
}

- (void) removeAllergy:(NSString *) allergy {
    NSSet  *newAllergies = [self.allergies filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings)
            { return [evaluatedObject isEqualToString:allergy]; }]];
    
    [self setAllergiesWithSet:newAllergies];
}



@end
