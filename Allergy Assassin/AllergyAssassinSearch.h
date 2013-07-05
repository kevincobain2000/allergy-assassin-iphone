//
//  AllergyAssassinSearch.h
//  Allergy Assassin
//
//  Created by Matt Jackson on 04/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Allergies.h"

@interface AllergyAssassinResults : NSObject

@property NSMutableDictionary *results;
@property NSString *apiVersion;

- (id) initWithResultString:(NSString *)resultString;
- (id) initWithResultData:(NSData *)resultData;


@end

@interface AllergyAssassinSearch : NSObject

- (id) initWithAllergies:(Allergies *) theAllergies;
- (void) searchForDish:(NSString *)dishName andOnResults:(void(^)(AllergyAssassinResults *results))successBlock andOnFailure:(void(^) (NSError *error)) errorBlock;

@end