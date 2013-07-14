//
//  AllergyAssassinSearch.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 04/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AllergyAssassinSearch.h"
#import "Allergies.h"

@interface AllergyAssassinSearch ()

@property Allergies *allergies;

@end

@implementation AllergyAssassinSearch

@synthesize allergies;

const NSString *aaSearchPath = @"http://api.allergyassassin.com/search/";

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

@implementation AllergyAssassinResults

@synthesize results;
@synthesize apiVersion;

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
        for (NSDictionary *allergyResult in [jsonResults objectForKey:@"results"]) {
            [results setObject:[allergyResult objectForKey:@"rating"]
                        forKey:[allergyResult objectForKey:@"allergy"]];
        }
    }
    return self;
}

- (NSMutableDictionary *) resultsByRating {
    NSMutableDictionary *resultsByRating = [[NSMutableDictionary alloc] initWithCapacity:numRatings];
    
    [resultsByRating enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *resultsForRating = [resultsByRating objectForKey:obj];
        if (resultsForRating == nil) {
            resultsForRating = [[NSMutableArray alloc] init];
        }
        [resultsForRating arrayByAddingObject:key];
        [resultsByRating setObject:resultsForRating forKey:key];
    }];
    
    return resultsByRating;
    
}

- (NSString *) verboseResults {
    return @"TEXTUAL REPRESENTATION";
}

@end