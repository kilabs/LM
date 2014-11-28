//
//  localplayer.h
//  melon
//
//  Created by Arie on 5/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>
@class Mplayer;
@interface localplayer : NSObject<AVAudioPlayerDelegate>
{

}
+(localplayer *)sharedInstance;
- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId songtitle:(NSString* ) songtitle singer:(NSString* ) singer;
- (void) stop;
- (void) pause;
- (void) setVolume:(float)level;
- (float) getVolume;
- (void) play;
- (void)destroyStreamer;
- (NSString *) songnow;
- (BOOL) isPlaying;
-(NSTimeInterval)timeInterval;
-(NSTimeInterval)duration;
@property (nonatomic, retain) AVAudioPlayer *playerdatalocal;
@property (nonatomic, retain) Mplayer *myPlayer;
@property (nonatomic, strong) NSString *songnowNow;
@property(nonatomic,strong)NSString *singer;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *real_songId;
@end
