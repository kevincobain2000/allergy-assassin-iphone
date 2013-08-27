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
@property NSString *searchString;

- (id) initWithResultString:(NSString *)resultString;
- (id) initWithResultData:(NSData *)resultData;

- (NSString *) verboseResults;
- (NSNumber *) highestRating;
- (UIImage *) highestRatingImage;

@end

@interface AllergyAssassinSearch : NSObject

- (id) init;
- (id) initWithAllergies:(Allergies *) theAllergies;
- (void) searchForDish:(NSString *)dishName andOnResults:(void(^)(AllergyAssassinResults *results))successBlock andOnFailure:(void(^) (NSError *error)) errorBlock;

+ (NSString *) disclaimer;

@end
