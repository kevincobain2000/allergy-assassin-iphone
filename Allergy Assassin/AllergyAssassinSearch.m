//
//  AllergyAssassinSearch.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 04/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AllergyAssassinSearch.h"
#import "Allergies.h"
#import "NSArray+AAAdditions.h"

@interface AllergyAssassinSearch ()

@property Allergies *allergies;

@end


@implementation AllergyAssassinSearch

@synthesize allergies;

const NSString *aaSearchPath = @"http://api.allergyassassin.com/search";

- (id) init {
    return [self initWithAllergies:[[Allergies alloc] init]];
}

- (id) initWithAllergies: (Allergies *) theAllergies {
    self = [super init];
    if (self != nil) {
        self.allergies = theAllergies;
    }
    
    return self;
}

+ (NSString *) disclaimer {
    return @"The ratings provided by Allergy Assassin are meant as a general guide, NOT a rock-solid indicator. If you are concerned about the contents of a dish, be sure to consult the chef or avoid the food entirely.";
}

- (void) searchForDish:(NSString *)dishName
          andOnResults:(void(^)(AllergyAssassinResults *results))successBlock
          andOnFailure:(void(^)(NSError *))errorBlock {
    
    NSString *aaQueryArgs = [[NSString
     stringWithFormat:@"?q=%@&allergies=%@&client=iphone",
     dishName,
     [[[allergies getAllergies] allObjects] componentsJoinedByString:@","]]
                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *aaSearchUrl = [NSURL URLWithString:[aaSearchPath stringByAppendingString:aaQueryArgs]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:aaSearchUrl];
    [NSURLConnection sendAsynchronousRequest:req
        queue:[NSOperationQueue currentQueue]
        completionHandler: ^(NSURLResponse *response, NSData *responseData, NSError *error) {
            if (error == nil) {
                AllergyAssassinResults *aaResults = [[AllergyAssassinResults alloc] initWithResultData:responseData];
                if ([aaResults error]) {
                    errorBlock([aaResults error]);
                } else {
                    successBlock(aaResults);
                }
            } else {
                errorBlock(error);
            }
    }];
    
}

@end

@interface AllergyAssassinResults()

@property NSDictionary *resultsByRating;

@property NSNumber *unknownRating;
@property NSArray *unsafeRatings;
@property NSArray *safeRatings;
@property NSArray *warningRatings;

@end

@implementation AllergyAssassinResults

@synthesize results;
@synthesize apiVersion;
@synthesize resultsByRating;
@synthesize searchString;
@synthesize error;

@synthesize  unknownRating;
@synthesize  unsafeRatings;
@synthesize  safeRatings;
@synthesize  warningRatings;

const NSUInteger numRatings = 6;  //number of different rating numbers

- (id) initWithResultString:(NSString *)resultString {
    return [self initWithResultData:[resultString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (id) initWithResultData:(NSData *) resultData {
    self = [self init];
    if (self != nil) {
        NSError *jsonParsingError = nil;
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&jsonParsingError];
        error = jsonParsingError;
        
        if (!error) {
            
            //ratings grouped by wording similarity - this must be changed if verboseStrings change!
            unknownRating = @0;
            unsafeRatings = @[@5];
            warningRatings = @[@4, @3];
            safeRatings = @[@2, @1];
            
            apiVersion = [jsonResults objectForKey:@"version"];
            searchString = [[[jsonResults objectForKey:@"arguments"] objectForKey:@"q"] objectAtIndex:0];
            results = [[NSMutableDictionary alloc] init];
            resultsByRating = @{@0: [[NSMutableArray alloc] init],
                                @1: [[NSMutableArray alloc] init],
                                @2: [[NSMutableArray alloc] init],
                                @3: [[NSMutableArray alloc] init],
                                @4: [[NSMutableArray alloc] init],
                                @5: [[NSMutableArray alloc] init] };
                            
            for (NSDictionary *allergyResult in [jsonResults objectForKey:@"results"]) {
                [results setObject:[allergyResult objectForKey:@"rating"]
                            forKey:[allergyResult objectForKey:@"allergy"]];
                
                [[resultsByRating objectForKey:[allergyResult objectForKey:@"rating"]]
                    addObject:[allergyResult objectForKey:@"allergy"]];
            }
        }
    }
    return self;
}

- (NSNumber *) highestRating {
    for (NSNumber *rating in @[@5, @4, @3, @2, @1, @0]) {
        if ([[resultsByRating objectForKey:rating] count] > 0) {
            return rating;
        }
    }
}

- (UIImage *) highestRatingImage {
    NSNumber *highestRating = [self highestRating];
    if (highestRating == unknownRating) {
        return [UIImage imageNamed:@"question mark.png"];
    } else if ([safeRatings containsObject:highestRating]) {
        return [UIImage imageNamed:@"check mark.png"];
    } else if ([warningRatings containsObject:highestRating]) {
        return [UIImage imageNamed:@"caution.png"];
    } else if ([unsafeRatings containsObject:highestRating]) {
        return [UIImage imageNamed:@"stop.png"];
    } else return nil;
}

+ (NSString *) verboseResultForDish: (NSString *) dish
                      withAllergies: (NSArray *) allergies
                      andRating:(NSNumber *) rating
                      inSuccinctFormat: (BOOL) succinct {
    
    NSDictionary *verboseStrings =
              @{@0: @"No record of this dish found!",
                @1: @[@"usually does not contain your allergens and is probably safe to eat."],
                @2: @[@"usually does not contain your allergens and is probably safe to eat."],
                @3: @[@"may be safe to eat, but it", @"occasionally contains"],
                @4: @[@"may be safe to eat, but it", @"sometimes contains"],
                @5: @[@"is probably NOT safe to eat, because it", @"usually does contain"]};

    NSMutableString *verboseResult = [[NSMutableString alloc] init];
    
    if ([rating isEqualToNumber:@0]) {
        verboseResult = verboseStrings[@0];
    } else if ([@[@2,@1] containsObject:rating]) {
        [verboseResult appendString:[@[dish, verboseStrings[rating][0]] componentsJoinedByString:@" "]];
    } else {
        if (succinct) {
            [verboseResult appendString: [@[dish,
                               verboseStrings[rating][0],
                               verboseStrings[rating][1],
                               [allergies verboseJoin]] componentsJoinedByString:@" "]];
        } else {
            [verboseResult appendString: [@[dish,
                               verboseStrings[rating][1],
                               [allergies verboseJoin]] componentsJoinedByString:@" "]];
        }
    }
    
    return verboseResult;

}

- (NSString *) verboseResults {
    NSMutableString *resultString = [[NSMutableString alloc] init];

    if ([resultsByRating[unknownRating] count] > 0) {
        // no record of searched recipe
        [resultString appendString: [[self class] verboseResultForDish:searchString withAllergies:resultsByRating[@0] andRating:@0 inSuccinctFormat:NO]];
    } else {
        
        // the first statement on safety should be verbose,
        // after which additional comments should be succinct.
        BOOL succinctOutput = NO;
        
        for (NSArray *group in @[unsafeRatings, warningRatings, safeRatings]) {
            for (NSNumber *rating in group) {
                if ([resultsByRating[rating] count] > 0) {
                    if (succinctOutput && [safeRatings containsObject:rating]) {
                        //we've had output already, and this rating is safe, so no more!
                    } else {
                        if (succinctOutput) {
                            [resultString appendString:@"\nAdditionally, "];
                        }
                        [resultString appendString:[[self class] verboseResultForDish:searchString withAllergies:resultsByRating[rating] andRating:rating inSuccinctFormat:!succinctOutput]];
                        succinctOutput = YES;
                    }
                }
            }
        }
    }
    
    //return str with capitalised first letter
    return [resultString stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                        withString:[[resultString substringToIndex:1] capitalizedString]];    
}

@end