//
//  topChartSongs.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topChartSongs : NSObject
{
@private
    NSString * albumId;
    NSString * albumName;
    NSString * artistId;
    NSString * artistName;
    NSString * availableYN;
    NSString * modYN;
	NSString * genreId;
    NSString * playtime;
    NSString * previousRanking;
    NSString * ranking;
    NSString * rbtYN;
    NSString * rtYN;
    NSString * sellAlacarteYN;
    NSString * sellDrmYN;
    NSString * sellNonDrmYN;
    NSString * sellStreamYN;
    NSString * slfLyricYN;
    NSString * songId;
    NSString * songName;
    NSString * textLyricYN;
    NSString * vodYN;
}

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * availableYN;
@property (nonatomic, retain) NSString * modYN;
@property (nonatomic, retain) NSString * playtime;
@property (nonatomic, retain) NSString *genreId;
@property (nonatomic, retain) NSString * previousRanking;
@property (nonatomic, retain) NSString * ranking;
@property (nonatomic, retain) NSString * rbtYN;
@property (nonatomic, retain) NSString * rtYN;
@property (nonatomic, retain) NSString * sellAlacarteYN;
@property (nonatomic, retain) NSString * sellDrmYN;
@property (nonatomic, retain) NSString * sellNonDrmYN;
@property (nonatomic, retain) NSString * sellStreamYN;
@property (nonatomic, retain) NSString * slfLyricYN;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * textLyricYN;
@property (nonatomic, retain) NSString * vodYN;

+ (topChartSongs *) getInstance;
-(id) initWithDictionary:(NSDictionary *) dictionary;

@end
