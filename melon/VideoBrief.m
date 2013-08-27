//
//  VideoBrief.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/23/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "VideoBrief.h"
#import "Netra.h"

@implementation VideoBrief

@synthesize albumName;
@synthesize artistId;
@synthesize artistName;
@synthesize opposeCnt;
@synthesize recommendCnt;
@synthesize songId;
@synthesize songName;
@synthesize songVodId;
@synthesize vodAdultYN;
@synthesize vodIssueDate;
@synthesize vodLImgPath;
@synthesize vodMImgPath;
@synthesize vodSImgPath;
@synthesize vodOrderIssueDate;
@synthesize vodTitle;

static VideoBrief * instance = nil;

+ (VideoBrief *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[VideoBrief alloc] init];
        }
    }
    
    return  instance;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.albumName          = [dictionary objectForKey:@"albumName"];
        self.artistId           = [dictionary objectForKey:@"artistId"];
        self.artistName         = [dictionary objectForKey:@"artistName"];
        self.opposeCnt          = [dictionary objectForKey:@"opposeCnt"];
        self.recommendCnt       = [dictionary objectForKey:@"recommendCnt"];
        self.songId             = [dictionary objectForKey:@"songId"];
        self.songName           = [dictionary objectForKey:@"songName"];
        self.songVodId          = [dictionary objectForKey:@"songVodId"];
        self.vodAdultYN         = [dictionary objectForKey:@"vodAdultYN"];
        self.vodIssueDate       = [dictionary objectForKey:@"vodIssueDate"];
        self.vodLImgPath        = [dictionary objectForKey:@"vodLImgPath"];
        self.vodMImgPath        = [dictionary objectForKey:@"vodMImgPath"];
        self.vodSImgPath        = [dictionary objectForKey:@"vodSImgPath"];
        self.vodOrderIssueDate  = [dictionary objectForKey:@"vodOrderIssueDate"];
        self.vodTitle           = [dictionary objectForKey:@"vodTitle"];
    }
    
    return self;
}

@end
