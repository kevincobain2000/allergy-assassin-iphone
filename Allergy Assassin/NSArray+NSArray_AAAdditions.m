//
//  NSArray+NSArray_AAAdditions.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 07/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "NSArray+NSArray_AAAdditions.h"

@implementation NSArray (NSArray_AAAdditions)

- (NSString *) asNaturalLanguageString {
    NSArray *head = [self subarrayWithRange:(NSMakeRange(0, [self count]-1))];
    NSString *last = [self lastObject];
    
    return [@[[head componentsJoinedByString:@", "], @" and", last] componentsJoinedByString:@" "];
    
}

@end
