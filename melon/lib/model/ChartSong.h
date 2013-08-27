//
//  ChartSong.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/8/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartSong : NSObject
{
    @private
    NSString * albumId;
    NSString * albumName;
    NSString * artistId;
    NSString * artistName;
    NSString * modYN;
    NSString * playTime;
    NSString * previousRanking;
    NSString * purchaseDownId;
    NSString * ranking;
    NSString * rbtYN;
    NSString * rtYN;
    NSString * sellAlaCartYN;
    NSString * sellDrmYN;
    NSString * sellNonDrmYN;
    NSString * sellStreamYN;
    NSString * slfLyricYN;
    NSString * songId;
    NSString * songName;
    NSString * textLyricYN;
    NSString * vodYN;
    NSString * availableYN;
    UIImage  * albumImage;
}

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * modYN;
@property (nonatomic, retain) NSString * playTime;
@property (nonatomic, retain) NSString * previousRanking;
@property (nonatomic, retain) NSString * purchaseDownId;
@property (nonatomic, retain) NSString * ranking;
@property (nonatomic, retain) NSString * rbtYN;
@property (nonatomic, retain) NSString * rtYN;
@property (nonatomic, retain) NSString * sellAlaCartYN;
@property (nonatomic, retain) NSString * sellDrmYN;
@property (nonatomic, retain) NSString * sellNonDrmYN;
@property (nonatomic, retain) NSString * sellStreamYN;
@property (nonatomic, retain) NSString * slfLyricYN;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * textLyricYN;
@property (nonatomic, retain) NSString * vodYN;
@property (nonatomic, retain) NSString * availableYN;
@property (nonatomic, retain) UIImage  * albumImage;

+ (ChartSong *) getInstance;

@end
