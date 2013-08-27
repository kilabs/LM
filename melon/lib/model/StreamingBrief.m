//
//  StreamingBrief.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "StreamingBrief.h"

@implementation StreamingBrief

@synthesize bitRateCd;
@synthesize codecTypeCd;
@synthesize contentId;
@synthesize errorCode;
@synthesize fullTrack;
@synthesize playtime;
@synthesize sampling;
@synthesize sessionId;

static StreamingBrief * instance = nil;

+ (StreamingBrief *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[StreamingBrief alloc] init];
        }
    }
    
    return  instance;
}

@end
