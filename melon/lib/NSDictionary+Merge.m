//
//  NSDictionary+Merge.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/10/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "NSDictionary+Merge.h"

@implementation NSDictionary (Merge)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self];
    [result addEntriesFromDictionary:dictionary];
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
