//
//  NewSongs.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/18/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewSongs : NSObject
{
@private
    NSString * adultYN;
    NSString * albumId;
    NSString * albumName;
    NSString * artistId;
    NSString * artistName;
    NSString * availableYN;
    NSString * diskNo;
    NSString * drmPaymentProdId;
    NSString * drmPrice;
    NSString * genreId;
    NSString * hitSongYN;
    NSString * issueDate;
    NSString * lcdStatusCd;
    NSString * modYN;
    NSString * nonDrmPaymentProdId;
    NSString * nonDrmPrice;
    NSString * playTime;
    NSString * rbtYN;
    NSString * rtYN;
    NSString * sellAlaCarteYN;
    NSString * sellDrmYN;
    NSString * sellNonDrmYN;
    NSString * sellStreamYN;
    NSString * songId;
    NSString * slfLyricYN;
    NSString * songName;
    NSString * songNameOrigin;
    NSString * textLyricYN;
    NSString * titleSongYN;
    NSString * trackNo;
    NSString * vodYN;
    UIImage  * albumImage;
}

@property (nonatomic, retain) NSString * adultYN;
@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * availableYN;
@property (nonatomic, retain) NSString * diskNo;
@property (nonatomic, retain) NSString * drmPaymentProdId;
@property (nonatomic, retain) NSString * drmPrice;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * hitSongYN;
@property (nonatomic, retain) NSString * issueDate;
@property (nonatomic, retain) NSString * lcdStatusCd;
@property (nonatomic, retain) NSString * modYN;
@property (nonatomic, retain) NSString * nonDrmPaymentProdId;
@property (nonatomic, retain) NSString * nonDrmPrice;
@property (nonatomic, retain) NSString * playTime;
@property (nonatomic, retain) NSString * rbtYN;
@property (nonatomic, retain) NSString * rtYN;
@property (nonatomic, retain) NSString * sellAlaCarteYN;
@property (nonatomic, retain) NSString * sellDrmYN;
@property (nonatomic, retain) NSString * sellNonDrmYN;
@property (nonatomic, retain) NSString * sellStreamYN;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * slfLyricYN;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songNameOrigin;
@property (nonatomic, retain) NSString * textLyricYN;
@property (nonatomic, retain) NSString * titleSongYN;
@property (nonatomic, retain) NSString * trackNo;
@property (nonatomic, retain) NSString * vodYN;
@property (nonatomic, retain) UIImage  * albumImage;


+ (NewSongs *) getInstance;
-(id) initWithDictionary:(NSDictionary *) dictionary;

@end
