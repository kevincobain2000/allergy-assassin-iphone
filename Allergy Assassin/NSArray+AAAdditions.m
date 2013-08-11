//
//  NSArray+NSArray_AAAdditions.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 07/07/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "NSArray+AAAdditions.h"

@implementation NSArray (AAAdditions)

- (NSString *) verboseJoin {
    
    if ([self count] > 1) {
        NSArray *head = [self subarrayWithRange:(NSMakeRange(0, [self count]-1))];
        NSString *last = [NSString stringWithFormat: @"%@.", [self lastObject]];
        
        return [@[[head componentsJoinedByString:@", "], @"and", last] componentsJoinedByString:@" "];
    } else {
        return [NSString stringWithFormat: @"%@.", self[0]];
    }
}

@end
