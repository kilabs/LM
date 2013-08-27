//
//  MelonPlayer.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 3/22/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>

@class NewSongs;
@class StreamingBrief;
@class AudioStreamer;
@class AVAudioPlayer;

@interface MelonPlayer : NSObject <AVAudioPlayerDelegate>
{
    NewSongs        * songs;
    StreamingBrief  * streamingMetadata;
    AudioStreamer   * streamer;
    AVAudioPlayer   * localStreamer;
    NSInteger       songType;
    NSTimer         * progressUpdateTimer;
}

+ (MelonPlayer*) sharedInstance;

@property(nonatomic, strong) AudioStreamer * streamer;
@property(nonatomic,strong)NSString *singer;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *real_songId;
- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId;
- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId songtitle:(NSString* ) songtitle singer:(NSString* ) singer;
- (void) playSongWithURL: (NSURL *) url;
- (void) stop;
- (void) pause;
- (void) play;
- (BOOL) isPaused;
- (BOOL) isWaiting;
- (BOOL) isPlaying;
- (BOOL) isIdle;
- (BOOL) isGettingNewSong;
- (BOOL) isProdukBasi;
- (void) sendStreamingNotify;
- (void) setSongType: (NSInteger) iSongType;
- (NSInteger) getSongType;
- (NSString *) checkLocalSong: (NSString *) songId;
- (NSString *) checkLocalSong: (NSString *) songId forUserId: (NSString *) userId;
- (double) getSongDuration;
- (double) getSongPlayProgress;
- (void) doNext;
- (void) doPrev;

- (void) playbackStateChanged: (NSNotification *) aNotification;
- (void) setGettingNewSong: (NSNumber *) value;
- (BOOL) periksaProdukBasi;
- (void) periksaLagudanStream: (NSString *) songId;


@end
