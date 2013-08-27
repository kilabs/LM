//
//  songListObject.m
//  melon
//
//  Created by Arie on 3/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "songListObject.h"
#import "Netra.h"
@implementation songListObject

@synthesize adultYN;
@synthesize albumId;
@synthesize albumName;
@synthesize artistId;
@synthesize artistName;
@synthesize availableYN;
@synthesize diskNo;
@synthesize drmPrice;
@synthesize genreId;
@synthesize genreName;
@synthesize hitSongYN;
@synthesize modYN;
@synthesize nonDrmPrice;
@synthesize playtime;
@synthesize rbtYN;
@synthesize rtYN;
@synthesize sellAlacarteYN;
@synthesize sellNonDrmYN;
@synthesize sellDrmYN;
@synthesize sellStreamYN;
@synthesize slfLyricYN;
@synthesize songId;
@synthesize songName;
@synthesize textLyricYN;
@synthesize titleSongYN;
@synthesize vodYN;

-(id) initWithDictionary:(NSDictionary *) dictionary
{
	self=[super init];
    
	if(self){
		
        self.adultYN        =[dictionary objectForKey:@"adultYN"];
        self.albumId        =[dictionary objectForKey:@"albumId"];
        self.albumName      =[dictionary objectForKey:@"albumName"];;
        self.artistId       =[dictionary objectForKey:@"artistId"];;
        self.artistName     =[dictionary objectForKey:@"artistName"];;
        self.availableYN    =[dictionary objectForKey:@"availableYN"];;
        self.diskNo         =[dictionary objectForKey:@"diskNo"];;
        self.drmPrice       =[dictionary objectForKey:@"drmPrice"];;
        self.genreId        =[dictionary objectForKey:@"genreId"];;
        self.genreName      =[dictionary objectForKey:@"genreName"];;
        self.hitSongYN      =[dictionary objectForKey:@"hitSongYN"];;
        self.modYN          =[dictionary objectForKey:@"modYN"];;
        self.nonDrmPrice    =[dictionary objectForKey:@"nonDrmPrice"];;
        self.playtime       =[dictionary objectForKey:@"playtime"];;
        self.rbtYN          =[dictionary objectForKey:@"rbtYN"];;
        self.rtYN           =[dictionary objectForKey:@"rtYN"];;
        self.sellAlacarteYN =[dictionary objectForKey:@"sellAlacarteYN"];;
        self.sellNonDrmYN   =[dictionary objectForKey:@"sellNonDrmYN"];;
        self.sellDrmYN      =[dictionary objectForKey:@"sellDrmYN"];;
        self.sellStreamYN   =[dictionary objectForKey:@"sellStreamYN"];;
        self.slfLyricYN     =[dictionary objectForKey:@"slfLyricYN"];;
        self.songId         =[dictionary objectForKey:@"songId"];;
        self.songName       =[dictionary objectForKey:@"songName"];;
        self.textLyricYN    =[dictionary objectForKey:@"textLyricYN"];;
        self.titleSongYN    =[dictionary objectForKey:@"titleSongYN"];;
        self.vodYN          =[dictionary objectForKey:@"vodYN"];;

	}
	return self;
}
@end
