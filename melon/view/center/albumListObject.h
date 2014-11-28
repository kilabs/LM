//
//  albumListObject.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface albumListObject : NSObject
{
    NSString * albumId;
    NSString * albumName;
    NSString * seriesNo;
    NSString * issueDate;
    NSString * adultYN;
    NSString * genreId;
    NSString * mainArtistId;
    NSString * mainSongId;
    NSString * albumLImgPath;
    NSString * albumSImgPath;
    NSString * albumMImgPath;
    NSString * mainArtistName;
    NSString * mainSongName;
    NSString * genre;
}


@property(nonatomic,strong) NSString * albumId;
@property(nonatomic,strong) NSString * albumName;
@property(nonatomic,strong) NSString * seriesNo;
@property(nonatomic,strong) NSString * issueDate;
@property(nonatomic,strong) NSString * adultYN;
@property(nonatomic,strong) NSString * genreId;
@property(nonatomic,strong) NSString * mainArtistId;
@property(nonatomic,strong) NSString * mainSongId;
@property(nonatomic,strong) NSString * albumLImgPath;
@property(nonatomic,strong) NSString * albumSImgPath;
@property(nonatomic,strong) NSString * albumMImgPath;
@property(nonatomic,strong) NSString * mainArtistName;
@property(nonatomic,strong) NSString * mainSongName;
@property(nonatomic,strong) NSString * genre;



-(id)initWithDictionary:(NSDictionary *)dictionary;
@end