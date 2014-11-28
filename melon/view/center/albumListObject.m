//
//  albumListObject.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "albumListObject.h"
#import "Netra.h"
@implementation albumListObject

@synthesize albumId;
@synthesize albumName;
@synthesize seriesNo;
@synthesize issueDate;
@synthesize adultYN;
@synthesize genreId;
@synthesize mainArtistId;
@synthesize mainSongId;
@synthesize albumLImgPath;
@synthesize albumSImgPath;
@synthesize albumMImgPath;
@synthesize mainArtistName;
@synthesize mainSongName;
@synthesize genre;

-(id) initWithDictionary:(NSDictionary *) dictionary
{
	self=[super init];
    
	if(self){
		
        self.albumId                =[dictionary objectForKey:@"albumId"];
        self.albumName              =[dictionary objectForKey:@"albumName"];
        self.seriesNo               =[dictionary objectForKey:@"seriesNo"];;
        self.issueDate              =[dictionary objectForKey:@"issueDate"];;
        self.adultYN                =[dictionary objectForKey:@"adultYN"];;
        self.genreId                =[dictionary objectForKey:@"genreId"];;
        self.mainArtistId           =[dictionary objectForKey:@"mainArtistId"];;
        self.mainSongId             =[dictionary objectForKey:@"mainSongId"];;
        self.albumLImgPath          =[dictionary objectForKey:@"albumLImgPath"];;
        self.albumSImgPath          =[dictionary objectForKey:@"albumSImgPath"];;
        self.albumMImgPath          =[dictionary objectForKey:@"albumMImgPath"];;
        self.mainArtistName         =[dictionary objectForKey:@"mainArtistName"];;
        self.mainSongName           =[dictionary objectForKey:@"mainSongName"];;
        self.genre                  =[dictionary objectForKey:@"genre"];;
        
	}
	return self;
}
@end