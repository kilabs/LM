//
//  PlaylistBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaylistBrief : NSObject
{
    NSString * accessCount;
    NSString * creatorId;
    NSString * creatorNickname;
    NSString * introduce;
    NSString * nickname;
    NSString * openDate;
    NSString * playlistName;
    NSString * playlistId;
    NSString * playlistLImgPath;
    NSString * playlistMImgPath;
    NSString * playlistSImgPath;
    NSString * recommendCount;
    NSString * regDate;
    NSString * scrapCount;
    NSString * scrapPlaylistYN;
    NSString * sharedPlaylistYN;
    NSString * status;
    NSString * titleSongName;
    NSString * totalSongCount;
    NSString * userId;
}

@property (nonatomic, retain) NSString * accessCount;
@property (nonatomic, retain) NSString * creatorId;
@property (nonatomic, retain) NSString * creatorNickname;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * openDate;
@property (nonatomic, retain) NSString * playlistName;
@property (nonatomic, retain) NSString * playlistId;
@property (nonatomic, retain) NSString * playlistLImgPath;
@property (nonatomic, retain) NSString * playlistMImgPath;
@property (nonatomic, retain) NSString * playlistSImgPath;
@property (nonatomic, retain) NSString * recommendCount;
@property (nonatomic, retain) NSString * regDate;
@property (nonatomic, retain) NSString * scrapCount;
@property (nonatomic, retain) NSString * scrapPlaylistYN;
@property (nonatomic, retain) NSString * sharedPlaylistYN;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * titleSongName;
@property (nonatomic, retain) NSString * totalSongCount;
@property (nonatomic, retain) NSString * userId;

-(id)initWithDictionary:(NSDictionary *)dictionary;
+ (PlaylistBrief *) getInstance;

@end
