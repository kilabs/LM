//
//  localplayer.m
//  melon
//
//  Created by Arie on 5/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "localplayer.h"
#import "MelonPlayer.h"
#import "DownloadList.h"
#import "EUserBrief.h"
@implementation localplayer
@synthesize playerdatalocal=_playerdatalocal;
@synthesize myPlayer;
bool is_playing_now=NO;
static localplayer * instance = nil;

+ (localplayer*) sharedInstance
{
	
	
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[localplayer alloc] init];
        }
    }
    
    return  instance;
}

- (void) removeInstance
{
    if (instance != nil)
    {
        [instance release];
        instance = nil;
    }
}
- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId songtitle:(NSString* ) songtitle singer:(NSString* ) singer{
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
	self.real_songId=[userId stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-",user_now.userId] withString:@""];
	self.songnowNow=userId;
	self.singer=singer;
	self.title=songtitle;
	NSURL *url = [[NSURL alloc] initFileURLWithPath:songId];
	_playerdatalocal = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	_playerdatalocal.volume=1.0;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: NO error: nil];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	_playerdatalocal.delegate=self;
	[_playerdatalocal prepareToPlay];
	[_playerdatalocal play];
	[self performSelector:@selector(playmini) withObject:nil afterDelay:0.5];
	
	 
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	NSLog(@"audioPlayerDidFinishPlaying");
[[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
}
- (void)destroyStreamer
{
	if (_playerdatalocal)
	{
		[_playerdatalocal stop];
		[_playerdatalocal release];
		_playerdatalocal = nil;
	}
}

- (void) stop
{
	NSLog(@"stoppperd");
	[_playerdatalocal stop];
}

- (void) pause
{
	NSLog(@"paused");
    [_playerdatalocal pause];
	
}

- (void) play
{
	
	NSLog(@"play");
    [_playerdatalocal prepareToPlay];
	[_playerdatalocal play];
	
	
}
-(void)playmini{
	NSMutableArray *a=[[NSMutableArray alloc]init];
	[a addObject:[NSString stringWithFormat:@"0"]];///stream
	[a addObject:self.title];
	[a addObject:self.singer];
	[a addObject:self.real_songId];
	NSLog(@"self.real_songId-->%@",self.real_songId);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"playingmini" object:a];
	[a removeAllObjects];
}
-(NSTimeInterval)timeInterval{
	return [_playerdatalocal currentTime];
}
-(NSTimeInterval)duration{
	return [_playerdatalocal duration];
}

- (BOOL) isPlaying
{
	if([_playerdatalocal isPlaying]){
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"playingmini" object:nil];
		return true;
	}
	else{
		return false ;
	}
}
- (void) setVolume:(float)level
{
    _playerdatalocal.volume = level;
}
- (NSString *) songnow{
	return self.songnowNow;
}
@end
