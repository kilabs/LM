//
//  LocalPlaylist.h
//  melon
//
//  Created by Arie on 5/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocalPlaylist : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * downId;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * genreName;
@property (nonatomic, retain) NSString * hitSongYN;
@property (nonatomic, retain) NSString * playTime;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * songPath;
@property (nonatomic, retain) NSString * songTitle;
@property (nonatomic, retain) NSDate * tanggal;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * realSongid;

@end
