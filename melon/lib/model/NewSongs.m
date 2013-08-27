//
//  NewSongs.m
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/18/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import "NewSongs.h"

@implementation NewSongs

@synthesize adultYN;
@synthesize albumId;
@synthesize albumName;
@synthesize artistId;
@synthesize artistName;
@synthesize availableYN;
@synthesize diskNo;
@synthesize drmPaymentProdId;
@synthesize drmPrice;
@synthesize genreId;
@synthesize hitSongYN;
@synthesize issueDate;
@synthesize lcdStatusCd;
@synthesize modYN;
@synthesize nonDrmPaymentProdId;
@synthesize nonDrmPrice;
@synthesize playTime;
@synthesize rbtYN;
@synthesize rtYN;
@synthesize sellAlaCarteYN;
@synthesize sellDrmYN;
@synthesize sellNonDrmYN;
@synthesize sellStreamYN;
@synthesize songId;
@synthesize slfLyricYN;
@synthesize songName;
@synthesize songNameOrigin;
@synthesize textLyricYN;
@synthesize titleSongYN;
@synthesize trackNo;
@synthesize vodYN;
@synthesize albumImage;

static NewSongs * instance = nil;

+ (NewSongs *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[NewSongs alloc] init];
        }
    }
    
    return  instance;
}

-(id) initWithDictionary:(NSDictionary *) dictionary
{
    self=[super init];
    
	if(self){
        self.adultYN            = [dictionary objectForKey:@"adultYN"];
        self.albumId            = [dictionary objectForKey:@"albumId"];
        self.albumName          = [dictionary objectForKey:@"albumName"];
        self.artistId           = [dictionary objectForKey:@"artistId"];
        self.artistName         = [dictionary objectForKey:@"artistName"];
        self.availableYN        = [dictionary objectForKey:@"availableYN"];
        self.diskNo             = [dictionary objectForKey:@"diskNo"];
        self.drmPaymentProdId   = [dictionary objectForKey:@"drmPaymentProdId"];
        self.drmPrice           = [dictionary objectForKey:@"drmPrice"];
        self.genreId            = [dictionary objectForKey:@"genreId"];
        self.hitSongYN          = [dictionary objectForKey:@"hitSongYN"];
        self.issueDate          = [dictionary objectForKey:@"issueDate"];
        self.lcdStatusCd        = [dictionary objectForKey:@"lcdStatusCd"];
        self.modYN              = [dictionary objectForKey:@"modYN"];
        self.nonDrmPaymentProdId    = [dictionary objectForKey:@"nonDrmPaymentProdId"];
        self.nonDrmPrice        = [dictionary objectForKey:@"nonDrmPrice"];
        self.playTime           = [dictionary objectForKey:@"playTime"];
        self.rbtYN              = [dictionary objectForKey:@"rbtYN"];
        self.rtYN               = [dictionary objectForKey:@"rtYN"];
        self.sellAlaCarteYN     = [dictionary objectForKey:@"sellAlaCarteYN"];
        self.sellDrmYN          = [dictionary objectForKey:@"sellDrmYN"];
        self.sellNonDrmYN       = [dictionary objectForKey:@"sellNonDrmYN"];
        self.sellStreamYN       = [dictionary objectForKey:@"sellStreamYN"];
        self.slfLyricYN         = [dictionary objectForKey:@"slfLyricYN"];
        self.songId             = [dictionary objectForKey:@"songId"];
        self.songName           = [dictionary objectForKey:@"songName"];
        self.songNameOrigin     = [dictionary objectForKey:@"songNameOrigin"];
        self.textLyricYN        = [dictionary objectForKey:@"textLyricYN"];
        self.titleSongYN        = [dictionary objectForKey:@"titleSongYN"];
        self.trackNo            = [dictionary objectForKey:@"trackNo"];
        self.albumImage         = [dictionary objectForKey:@"albumImage"];
        self.vodYN              = [dictionary objectForKey:@"vodYN"];
        
	}
	return self;
}

@end
