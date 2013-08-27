//
//  AlbumBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AlbumBrief : NSManagedObject

@property (nonatomic, retain) NSString * adultYN;
@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumLImgPath;
@property (nonatomic, retain) NSString * albumMImgPath;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * albumSImgPath;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * issueDate;
@property (nonatomic, retain) NSString * mainArtistId;
@property (nonatomic, retain) NSString * mainArtistName;
@property (nonatomic, retain) NSString * mainSongId;
@property (nonatomic, retain) NSString * mainSongName;
@property (nonatomic, retain) NSString * seriesNo;

@end
