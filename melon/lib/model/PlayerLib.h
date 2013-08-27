//
//  PlayerLib.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/17/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "songListObject.h"
#import "NewSongs.h"
#import "topChartSongs.h"
#import "LocalPlaylist.h"

@interface PlayerLib : NSObject

+ (void) addToPlaylistofSong:(songListObject *) song;
+ (void) addToPlaylistofNewSong:(NewSongs *) song;
+ (void) addToPlaylistofTopChart:(topChartSongs *) song;
+ (void) addToPlaylistofPlaylistSongItem: (LocalPlaylist *) song;
+ (void) clearPlaylist;
+ (void) shufflePlaylist: (NSInteger) flag;
+ (BOOL) isLocalSongAvailable: (NSString *) songId;
+ (NSInteger) getSongListIndexofSongId: (NSString *) songId;
+ (NSInteger) getSongPlayOrderofSongId: (NSString *) songId;

@end
