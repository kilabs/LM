//
//  LocalPlaylist1.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 6/3/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocalPlaylist1 : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * downId;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * genreName;
@property (nonatomic, retain) NSString * hitSongYN;
@property (nonatomic, retain) NSString * playTime;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * songPath;
@property (nonatomic, retain) NSString * songTitle;
@property (nonatomic, retain) NSDate * tanggal;
@property (nonatomic, retain) NSString * userId;

@end
