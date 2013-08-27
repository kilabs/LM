//
//  topChartSongs.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "topChartSongs.h"

@implementation topChartSongs

@synthesize albumId;
@synthesize albumName;
@synthesize artistId;
@synthesize artistName;
@synthesize availableYN;
@synthesize modYN;
@synthesize playtime;
@synthesize previousRanking;
@synthesize ranking;
@synthesize rbtYN;
@synthesize rtYN;
@synthesize sellAlacarteYN;
@synthesize sellDrmYN;
@synthesize sellNonDrmYN;
@synthesize sellStreamYN;
@synthesize slfLyricYN;
@synthesize songId;
@synthesize songName;
@synthesize textLyricYN;
@synthesize vodYN;

static topChartSongs * instance = nil;

+ (topChartSongs *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[topChartSongs alloc] init];
        }
    }
    
    return  instance;
}

-(id) initWithDictionary:(NSDictionary *) dictionary
{
	self=[super init];
    
	if(self){

        self.albumId        = [dictionary objectForKey:@"albumId"];
        self.albumName      = [dictionary objectForKey:@"albumName"];
        self.artistId       = [dictionary objectForKey:@"artistId"];
        self.artistName     = [dictionary objectForKey:@"artistName"];
        self.availableYN    = [dictionary objectForKey:@"availableYN"];
        self.modYN          = [dictionary objectForKey:@"modYN"];
        self.playtime       = [dictionary objectForKey:@"playtime"];
        self.previousRanking = [dictionary objectForKey:@"previousRanking"];
        self.ranking        = [dictionary objectForKey:@"ranking"];
        self.rbtYN          = [dictionary objectForKey:@"genreId"];
		self.genreId          = [dictionary objectForKey:@"rbtYN"];
        self.rtYN           = [dictionary objectForKey:@"rtYN"];
        self.sellAlacarteYN = [dictionary objectForKey:@"sellAlacarteYN"];
        self.sellDrmYN      = [dictionary objectForKey:@"sellDrmYN"];
        self.sellNonDrmYN   = [dictionary objectForKey:@"sellNonDrmYN"];
        self.sellStreamYN   = [dictionary objectForKey:@"sellStreamYN"];
        self.slfLyricYN     = [dictionary objectForKey:@"slfLyricYN"];
        self.songId         = [dictionary objectForKey:@"songId"];
        self.songName       = [dictionary objectForKey:@"songName"];
        self.textLyricYN    = [dictionary objectForKey:@"textLyricYN"];
        self.vodYN          = [dictionary objectForKey:@"vodYN"];
    
	}
	return self;
}

@end
