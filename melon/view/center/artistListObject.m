//
//  artistListObject.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "artistListObject.h"
#import "Netra.h"
@implementation artistListObject

@synthesize genreId;
@synthesize genre;
@synthesize domesticYN;
@synthesize artistLImgPath;
@synthesize artistSImgPath;
@synthesize artistId;
@synthesize artistName;
@synthesize groupYN;
@synthesize nationalityCd;
@synthesize gender;
@synthesize artistMImgPath;
@synthesize nationality;

-(id) initWithDictionary:(NSDictionary *) dictionary
{
	self=[super init];
    
	if(self){
		
        self.genreId                =[dictionary objectForKey:@"genreId"];
        self.genre                  =[dictionary objectForKey:@"genre"];
        self.domesticYN             =[dictionary objectForKey:@"domesticYN"];;
        self.artistLImgPath         =[dictionary objectForKey:@"artistLImgPath"];;
        self.artistSImgPath         =[dictionary objectForKey:@"artistSImgPath"];;
        self.artistId               =[dictionary objectForKey:@"artistId"];;
        self.artistName             =[dictionary objectForKey:@"artistName"];;
        self.groupYN                =[dictionary objectForKey:@"groupYN"];;
        self.nationalityCd          =[dictionary objectForKey:@"nationalityCd"];;
        self.gender                 =[dictionary objectForKey:@"gender"];;
        self.artistMImgPath         =[dictionary objectForKey:@"artistMImgPath"];;
        self.nationality            =[dictionary objectForKey:@"nationality"];;
        
	}
	return self;
}
@end
