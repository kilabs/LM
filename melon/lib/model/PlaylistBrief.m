//
//  PlaylistBrief.m
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import "PlaylistBrief.h"


@implementation PlaylistBrief

@synthesize accessCount;
@synthesize creatorId;
@synthesize creatorNickname;
@synthesize introduce;
@synthesize nickname;
@synthesize openDate;
@synthesize playlistName;
@synthesize playlistId;
@synthesize playlistLImgPath;
@synthesize playlistMImgPath;
@synthesize playlistSImgPath;
@synthesize recommendCount;
@synthesize regDate;
@synthesize scrapCount;
@synthesize scrapPlaylistYN;
@synthesize sharedPlaylistYN;
@synthesize status;
@synthesize titleSongName;
@synthesize totalSongCount;
@synthesize userId;

static PlaylistBrief * instance;

+ (PlaylistBrief *) getInstance
{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[PlaylistBrief alloc] init];
        }
    }
    
    return instance;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.accessCount        = [dictionary objectForKey:@"accessCount"];
        self.creatorId          = [dictionary objectForKey:@"creatorId"];
        self.creatorNickname    = [dictionary objectForKey:@"creatorNickname"];
        self.introduce          = [dictionary objectForKey:@"introduce"];
        self.nickname           = [dictionary objectForKey:@"nickName"];
        self.openDate           = [dictionary objectForKey:@"openDate"];
        self.playlistName       = [dictionary objectForKey:@"playlistName"];
        self.playlistId         = [dictionary objectForKey:@"playlistId"];
        self.playlistLImgPath   = [dictionary objectForKey:@"playlistLImgPath"];
        self.playlistMImgPath   = [dictionary objectForKey:@"playlistMImgPath"];
        
        self.playlistSImgPath   = [dictionary objectForKey:@"playlistSImgPath"];
        self.recommendCount     = [dictionary objectForKey:@"recommendCnt"];
        self.regDate            = [dictionary objectForKey:@"regDate"];
        self.scrapCount         = [dictionary objectForKey:@"scrapCnt"];
        self.scrapPlaylistYN    = [dictionary objectForKey:@"scrapPlaylistYN"];
        self.sharedPlaylistYN   = [dictionary objectForKey:@"sharedPlaylistYN"];
        self.status             = [dictionary objectForKey:@"status"];
        self.titleSongName      = [dictionary objectForKey:@"titleSongName"];
        self.totalSongCount     = [dictionary objectForKey:@"totalSongCnt"];
        self.userId             = [dictionary objectForKey:@"userId"];
    }
    
    instance = self;
    return  self;
}

@end
