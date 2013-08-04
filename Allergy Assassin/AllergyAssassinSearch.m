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
                successBlock(aaResults);
            } else {
                errorBlock(error);
            }
    }];
    
}

@end

@interface AllergyAssassinResults()

@property NSDictionary *resultsByRating;

@end

@implementation AllergyAssassinResults

@synthesize results;
@synthesize apiVersion;
@synthesize resultsByRating;
@synthesize searchString;

const NSUInteger numRatings = 6;  //number of different rating numbers

- (id) initWithResultString:(NSString *)resultString {
    return [self initWithResultData:[resultString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (id) initWithResultData:(NSData *) resultData {
    self = [super init];
    if (self != nil) {
        NSError *jsonParsingError = nil;
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&jsonParsingError];
        
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
    //TODO
    return nil;
}

- (NSString *) verboseResults {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *verboseRatings = @{
                         @1: [NSString stringWithFormat:@"%@ is probably safe to eat because it usually does not contain ", searchString],
                         @2: [NSString stringWithFormat:@"%@ is probably safe to eat because it usually does not contain ", searchString],
                         @3: [NSString stringWithFormat:@"%@ may be safe to eat, but sometimes contains ", searchString],
                         @4: [NSString stringWithFormat:@"%@ may be safe to eat, sometimes contains ", searchString],
                         @5: [NSString stringWithFormat:@"%@ is probably NOT safe to eat, because it usually does contain ", searchString],
                         @0: @" No record of this dish found!"};
    
    NSNumber *unknownRating = @0;
    NSArray *unsafeRatings = @[@3, @4, @5];
    NSArray *safeRatings = @[@1, @2];

    if ([[resultsByRating objectForKey:unknownRating] count] > 0) {
        // no record of searched recipe
        resultString = [verboseRatings objectForKey:unknownRating];
    } else {
        
        BOOL unsafeOutput = NO;
        
        for (NSNumber *rating in unsafeRatings) {
            if ([[resultsByRating objectForKey:rating] count] > 0) {
                if (unsafeOutput) {
                    [resultString appendString:@"\nAdditionally, "];
                }
                
                [resultString appendString:[verboseRatings objectForKey:rating ]];
                [resultString appendString: [(NSArray *)[resultsByRating objectForKey:rating] verboseJoin]];
                unsafeOutput = YES;
            }
        }
        
        
        if (!unsafeOutput) {
            // only show something is safe if not previously described as unsafe
            BOOL safeOutput = NO;
                                    
            for (NSNumber *rating in safeRatings) {
                if ([[resultsByRating objectForKey:rating] count] > 0) {
                    if (safeOutput) {
                        [resultString appendString:@"\nAdditionally, "];
                    }
                
                    [resultString appendString:[verboseRatings objectForKey:rating]];
                    [resultString appendString:[(NSArray *) [resultsByRating objectForKey:rating] verboseJoin]];
                    safeOutput = YES;
                }
            }
        }
    }
    
    return resultString;
}

@end