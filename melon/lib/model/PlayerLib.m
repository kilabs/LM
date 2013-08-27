//
//  PlayerLib.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/17/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "PlayerLib.h"
#import "mokletdevAppDelegate.h"
#import "PlaylistBrief.h"
#import "LocalPlaylist1.h"
#import "GlobalDefine.h"

@interface PlayerLib ()

@end

@implementation PlayerLib

+ (void) addToPlaylistofSong:(songListObject *) song
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    BOOL isSongExist = NO;
    for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; i++)
    {
        LocalPlaylist1 * lp = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:i];
        if ([lp.songId isEqualToString: song.songId])
        {
            appDelegate.nowPlayingSongIndex = i;
            NSLog(@"appDelegate.nowPlayingSongIndex: %d", appDelegate.nowPlayingSongIndex);
            for (int j = 0; j < [appDelegate.nowPlayingPlayOrder count]; ++j)
            {
                NSNumber * urutan = [appDelegate.nowPlayingPlayOrder objectAtIndex:j];
                if (urutan.integerValue == appDelegate.nowPlayingSongIndex)
                {
                    appDelegate.nowPlayingPlayOrderIndex = j;
                    break;
                }
            }
            isSongExist = YES;
            break;
        }
    }
    if (isSongExist)
        return;
    
    LocalPlaylist1 * localplaylist = [LocalPlaylist1 MR_createInContext:localContext];
    
    localplaylist.albumId = [NSString stringWithFormat:@"%@", song.albumId];
    localplaylist.albumName = song.albumName;
    localplaylist.artistId = [NSString stringWithFormat:@"%@", song.artistId];
    localplaylist.artistName = song.artistName;
    localplaylist.downId = @"";
    localplaylist.genreId = [NSString stringWithFormat:@"%@", song.genreId];
    localplaylist.genreName = @"";
    localplaylist.hitSongYN = song.hitSongYN;
    localplaylist.playTime = [NSString stringWithFormat:@"%@", song.playtime];
    localplaylist.songId = [NSString stringWithFormat:@"%@", song.songId];
    
    localplaylist.songPath = @"";
    localplaylist.songTitle = song.songName;
    localplaylist.tanggal = [NSDate date];
    localplaylist.userId = appDelegate.eUserId;
    //localplaylist.userId = @"";
    
    [localContext MR_save];
    
    // update list.
    [self updatePlaylistDefault];
    NSNumber * urutan = [NSNumber numberWithInt:[appDelegate.nowPlayingPlayOrder count]];
    [appDelegate.nowPlayingPlayOrder addObject:urutan];
    appDelegate.nowPlayingPlayOrderIndex = [appDelegate.nowPlayingPlayOrder count] -1;
    appDelegate.nowPlayingSongIndex = [[appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex] integerValue];
    if ((appDelegate.playOption & SHUFFLE_ON) == SHUFFLE_ON)
    {
        [self shufflePlaylist: 1];
    }

}

+ (void) addToPlaylistofNewSong:(NewSongs *) song
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSLog(@"Masukkan lagu : %@.", song.songName);
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    BOOL isSongExist = NO;
    for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; i++)
    {
        LocalPlaylist1 * lp = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:i];
        if ([lp.songId isEqualToString: song.songId])
        {
            appDelegate.nowPlayingSongIndex = i;
            NSLog(@"appDelegate.nowPlayingSongIndex: %d", appDelegate.nowPlayingSongIndex);
            isSongExist = YES;
            for (int j = 0; j < [appDelegate.nowPlayingPlayOrder count]; ++j)
            {
                NSNumber * urutan = [appDelegate.nowPlayingPlayOrder objectAtIndex:j];
                if (urutan.integerValue == appDelegate.nowPlayingSongIndex)
                {
                    appDelegate.nowPlayingPlayOrderIndex = j;
                    break;
                }
            }
            break;
        }
    }
    if (isSongExist)
        return;
    
    LocalPlaylist1 * localplaylist = [LocalPlaylist1 MR_createInContext:localContext];
    
    localplaylist.albumId = [NSString stringWithFormat:@"%@", song.albumId];
    localplaylist.albumName = song.albumName;
    localplaylist.artistId = [NSString stringWithFormat:@"%@", song.artistId];
    localplaylist.artistName = song.artistName;
    localplaylist.downId = @"";
    localplaylist.genreId = [NSString stringWithFormat:@"%@", song.genreId];
    localplaylist.genreName = @"";
    localplaylist.hitSongYN = song.hitSongYN;
    localplaylist.playTime = [NSString stringWithFormat:@"%@", song.playTime];
    localplaylist.songId = [NSString stringWithFormat:@"%@", song.songId];
    
    localplaylist.songPath = @"";
    localplaylist.songTitle = song.songName;
    localplaylist.tanggal = [NSDate date];
    localplaylist.userId = appDelegate.eUserId;
    //localplaylist.userId = @"";
    
    [localContext MR_save];
    
    // update list.
    [self updatePlaylistDefault];
    NSNumber * urutan = [NSNumber numberWithInt:[appDelegate.nowPlayingPlayOrder count]];
    [appDelegate.nowPlayingPlayOrder addObject:urutan];
    appDelegate.nowPlayingPlayOrderIndex = [appDelegate.nowPlayingPlayOrder count] -1;
    appDelegate.nowPlayingSongIndex = [[appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex] integerValue];
    if (appDelegate.playOption & SHUFFLE_ON)
    {
        [self shufflePlaylist: 1];
    }
    
    NSLog(@"Masukkan lagu : %@ selesai.", song.songName);
}

+ (void) addToPlaylistofTopChart:(topChartSongs *) song
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    BOOL isSongExist = NO;
    for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; i++)
    {
        LocalPlaylist1 * lp = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:i];
        if ([lp.songId isEqualToString: song.songId])
        {
            appDelegate.nowPlayingSongIndex = i;
            NSLog(@"appDelegate.nowPlayingSongIndex: %d", appDelegate.nowPlayingSongIndex);
            isSongExist = YES;
            for (int j = 0; j < [appDelegate.nowPlayingPlayOrder count]; ++j)
            {
                NSNumber * urutan = [appDelegate.nowPlayingPlayOrder objectAtIndex:j];
                if (urutan.integerValue == appDelegate.nowPlayingSongIndex)
                {
                    appDelegate.nowPlayingPlayOrderIndex = j;
                    break;
                }
            }
            break;
        }
    }
    if (isSongExist)
        return;
    
    LocalPlaylist1 * localplaylist = [LocalPlaylist1 MR_createInContext:localContext];
    
    localplaylist.albumId = [NSString stringWithFormat:@"%@", song.albumId];
    localplaylist.albumName = song.albumName;
    localplaylist.artistId = [NSString stringWithFormat:@"%@", song.songId];
    localplaylist.artistName = song.artistName;
    localplaylist.downId = @"";
    localplaylist.genreId = @"";
    localplaylist.genreName = @"";
    localplaylist.hitSongYN = @"";
    localplaylist.playTime = [NSString stringWithFormat:@"%@", song.playtime];
    localplaylist.songId = [NSString stringWithFormat:@"%@", song.songId];
    
    localplaylist.songPath = @"";
    localplaylist.songTitle = song.songName;
    localplaylist.tanggal = [NSDate date];
    localplaylist.userId = appDelegate.eUserId;
    //localplaylist.userId = @"";
    
    [localContext MR_save];
    
    // update list.
    [self updatePlaylistDefault];
    NSNumber * urutan = [NSNumber numberWithInt:[appDelegate.nowPlayingPlayOrder count]];
    [appDelegate.nowPlayingPlayOrder addObject:urutan];
    appDelegate.nowPlayingPlayOrderIndex = [appDelegate.nowPlayingPlayOrder count] -1;
    appDelegate.nowPlayingSongIndex = [[appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex] integerValue];
    
    
    if (appDelegate.playOption & SHUFFLE_ON)
    {
        [self shufflePlaylist: 1];
    }
}

+ (void) addToPlaylistofPlaylistSongItem: (LocalPlaylist *) song
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    BOOL isSongExist = NO;
    for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; i++)
    {
        LocalPlaylist1 * lp = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:i];
        if ([lp.songId isEqualToString: song.songId])
        {
            appDelegate.nowPlayingSongIndex = i;
            NSLog(@"appDelegate.nowPlayingSongIndex: %d", appDelegate.nowPlayingSongIndex);
            isSongExist = YES;
            for (int j = 0; j < [appDelegate.nowPlayingPlayOrder count]; ++j)
            {
                NSNumber * urutan = [appDelegate.nowPlayingPlayOrder objectAtIndex:j];
                if (urutan.integerValue == appDelegate.nowPlayingSongIndex)
                {
                    appDelegate.nowPlayingPlayOrderIndex = j;
                    NSLog(@"appDelegate.nowPlayingSongIndex: %d", appDelegate.nowPlayingPlayOrderIndex);
                    break;
                }
            }
            break;
        }
    }
    if (isSongExist)
        return;
    
    LocalPlaylist1 * localplaylist = [LocalPlaylist1 MR_createInContext:localContext];
    
    localplaylist.albumId = [NSString stringWithFormat:@"%@", song.albumId];
    localplaylist.albumName = song.albumName;
    localplaylist.artistId = [NSString stringWithFormat:@"%@", song.songId];
    localplaylist.artistName = song.artistName;
    localplaylist.downId = [NSString stringWithFormat:@"%@", song.downId];
    localplaylist.genreId = [NSString stringWithFormat:@"%@", song.genreId];
    localplaylist.genreName = song.genreName;
    localplaylist.hitSongYN = song.hitSongYN;
    localplaylist.playTime = [NSString stringWithFormat:@"%@", song.playTime];
    localplaylist.songId = [NSString stringWithFormat:@"%@", song.songId];
    
    localplaylist.songPath = song.filePath;
    localplaylist.songTitle = song.songTitle;
    localplaylist.tanggal = [NSDate date];
    //localplaylist.userId = appDelegate.eUserId;
    localplaylist.userId = [NSString stringWithFormat:@"%@", song.userId];
    
    [localContext MR_save];
    
    // update list.
    [self updatePlaylistDefault];
    NSNumber * urutan = [NSNumber numberWithInt:[appDelegate.nowPlayingPlayOrder count]];
    [appDelegate.nowPlayingPlayOrder addObject:urutan];
    appDelegate.nowPlayingPlayOrderIndex = [appDelegate.nowPlayingPlayOrder count] -1;
    appDelegate.nowPlayingSongIndex = [[appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex] integerValue];
    
    
    if (appDelegate.playOption & SHUFFLE_ON)
    {
        [self shufflePlaylist: 1];
    }
}

+ (void) updatePlaylistDefault
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.nowPlayingPlaylistDefault removeAllObjects];
    
    appDelegate.nowPlayingPlaylistDefault = [NSMutableArray arrayWithArray:[LocalPlaylist1 MR_findAllSortedBy:@"tanggal" ascending:YES]];
}

+ (void) clearPlaylist
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self updatePlaylistDefault];
    for (LocalPlaylist1 * pl in appDelegate.nowPlayingPlaylistDefault)
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"songId contains [cd] %@", pl.songId];
        [LocalPlaylist1 MR_deleteAllMatchingPredicate:predicate];
    }
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId contains [cd] %@", appDelegate.eUserId];
    //[LocalPlaylist1 MR_deleteAllMatchingPredicate:predicate];
    [self updatePlaylistDefault];
    [appDelegate.nowPlayingPlayOrder removeAllObjects];
    NSLog(@"appDelegate.nowPlayingPlaylistDefault jumlah: %d", [appDelegate.nowPlayingPlaylistDefault count]);
}

+ (void) shufflePlaylist: (NSInteger) flag
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"appDelegate.nowPlayingPlayOrder count: %lu - %lu.", (unsigned long)[appDelegate.nowPlayingPlayOrder count], (unsigned long)[appDelegate.nowPlayingPlaylistDefault count]);
    //[appDelegate.nowPlayingPlayOrder addObject:appDelegate.nowPlayingSongIndex];
    
    [appDelegate.nowPlayingPlayOrder removeAllObjects];
    if (flag == 0)
    {
        for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; ++i)
        {
            NSNumber * urutan = [NSNumber numberWithInt:i];
            [appDelegate.nowPlayingPlayOrder addObject:urutan];
        }
    }
    
    else if (flag == 1)
    {
        
        NSMutableArray * tempOrder = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; ++i)
        {
            [tempOrder addObject:[NSNumber numberWithInt:i]];
        }
    
        
        while ([tempOrder count] > 0)
        {
            int idx = rand() % [tempOrder count];
            NSInteger Idx = idx;
            if (Idx != appDelegate.nowPlayingSongIndex)
                [appDelegate.nowPlayingPlayOrder addObject:[tempOrder objectAtIndex:idx]];
            
            [tempOrder removeObjectAtIndex:idx];
        }
    }
    
    for (int i = 0; i < [appDelegate.nowPlayingPlayOrder count]; ++i)
    {
        NSNumber * urutan = [appDelegate.nowPlayingPlayOrder objectAtIndex:i];
        if (urutan.integerValue == appDelegate.nowPlayingSongIndex)
        {
            appDelegate.nowPlayingPlayOrderIndex = i;
            break;
        }
    }
    
    NSLog(@"appDelegate.nowPlayingPlayOrder count: %lu - %lu.", (unsigned long)[appDelegate.nowPlayingPlayOrder count], (unsigned long)[appDelegate.nowPlayingPlaylistDefault count]);
}

+ (BOOL) isLocalSongAvailable:(NSString *)songId
{
    BOOL ret = NO;
    LocalPlaylist1 * pl = [LocalPlaylist1 MR_findFirstByAttribute:@"songId" withValue:songId];
    if (pl)
    {
        if (!([pl.songPath isEqualToString:@""]))
        {
            ret = YES;
        }
    }
    return ret;
}

+ (NSInteger) getSongListIndexofSongId: (NSString *) songId
{
    NSInteger ret = 0;
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];

    for (int i = 0; i < [appDelegate.nowPlayingPlaylistDefault count]; i++)
    {
        LocalPlaylist1 * lp = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:i];
        if ([lp.songId isEqualToString: songId])
        {
            appDelegate.nowPlayingSongIndex = i;
            NSLog(@"appDelegate.nowPlayingSongIndex: %d of %d", appDelegate.nowPlayingSongIndex, [appDelegate.nowPlayingPlaylistDefault count]);
            ret = i;
            break;
        }
    }
    
    return ret;
}

+ (NSInteger) getSongPlayOrderofSongId: (NSString *) songId
{
    NSInteger ret = 0;
    NSNumber * songIdx = [NSNumber numberWithInteger:[self getSongListIndexofSongId:songId]];
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < [appDelegate.nowPlayingPlayOrder count]; ++i)
    {
        if ([songIdx isEqualToNumber:[appDelegate.nowPlayingPlayOrder objectAtIndex:i]])
        {
            ret = i +1;
            break;
        }
    }
    
    return  ret;
}

@end
