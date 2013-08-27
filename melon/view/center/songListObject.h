//
//  songListObject.h
//  melon
//
//  Created by Arie on 3/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface songListObject : NSObject
{
    NSString * adultYN;
    NSString * albumId;
    NSString * albumName;
    NSString * artistId;
    NSString * artistName;
    NSString * availableYN;
    NSString * diskNo;
    NSString * drmPrice;
    NSString * genreId;
    NSString * genreName;
    
    
    NSString * hitSongYN;
    NSString * modYN;
    NSString * nonDrmPrice;
    
    NSString * playtime;
    NSString * rbtYN;
    NSString * rtYN;
    NSString * sellAlacarteYN;
    NSString * sellNonDrmYN;
    NSString * sellDrmYN;
    NSString * sellStreamYN;
    NSString * slfLyricYN;
    
    NSString * songId;
    NSString * songName;
    NSString * textLyricYN;
    NSString * titleSongYN;
    NSString * vodYN;
}


@property(nonatomic,strong) NSString * adultYN;
@property(nonatomic,strong) NSString * albumId;
@property(nonatomic,strong) NSString * albumName;
@property(nonatomic,strong) NSString * artistId;
@property(nonatomic,strong) NSString * artistName;
@property(nonatomic,strong) NSString * availableYN;
@property(nonatomic,strong) NSString * diskNo;
@property(nonatomic,strong) NSString * drmPrice;
@property(nonatomic,strong) NSString * genreId;
@property(nonatomic,strong) NSString * genreName;


@property(nonatomic,strong) NSString * hitSongYN;
@property(nonatomic,strong) NSString * modYN;
@property(nonatomic,strong) NSString * nonDrmPrice;

@property(nonatomic,strong) NSString * playtime;
@property(nonatomic,strong) NSString * rbtYN;
@property(nonatomic,strong) NSString * rtYN;
@property(nonatomic,strong) NSString * sellAlacarteYN;
@property(nonatomic,strong) NSString * sellNonDrmYN;
@property(nonatomic,strong) NSString * sellDrmYN;
@property(nonatomic,strong) NSString * sellStreamYN;
@property(nonatomic,strong) NSString * slfLyricYN;

@property(nonatomic,strong) NSString * songId;
@property(nonatomic,strong) NSString * songName;
@property(nonatomic,strong) NSString * textLyricYN;
@property(nonatomic,strong) NSString * titleSongYN;
@property(nonatomic,strong) NSString * vodYN;



-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
