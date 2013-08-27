//
//  ChartSong.m
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/8/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import "ChartSong.h"

@implementation ChartSong

@synthesize albumId;
@synthesize albumName;
@synthesize artistId;
@synthesize artistName;
@synthesize modYN;
@synthesize playTime;
@synthesize previousRanking;
@synthesize purchaseDownId;
@synthesize ranking;
@synthesize rbtYN;
@synthesize rtYN;
@synthesize sellAlaCartYN;
@synthesize sellDrmYN;
@synthesize sellNonDrmYN;
@synthesize sellStreamYN;
@synthesize slfLyricYN;
@synthesize songId;
@synthesize songName;
@synthesize textLyricYN;
@synthesize vodYN;
@synthesize availableYN;
@synthesize albumImage;



static ChartSong * instance = nil;

+ (ChartSong *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[ChartSong alloc] init];
        }
    }
    
    return  instance;
}

@end
