//
//  MelonPlayer.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 3/22/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "MelonPlayer.h"
#import "AFNetworking.h"
#include "Encryption.h"
#include "GlobalDefine.h"
#include "NewSongs.h"
#include "StreamingBrief.h"
#import "mokletdevAppDelegate.h"
#import "LocalPlaylist1.h"
#import "AFNetworking.h"


#import <CommonCrypto/CommonCrypto.h>

@implementation MelonPlayer

@synthesize streamer;

mokletdevAppDelegate * appDelegate;

BOOL isGettingNewSong = NO;
BOOL isNotificationInstalled = NO;
BOOL isProdukBasi = NO;
BOOL bTimerON = NO;

int isCallConnect = 0;

static MelonPlayer * instance = nil;
NSString * sessionId;
double     songPlayProgress;
double     playtime;

+ (MelonPlayer*) sharedInstance
{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[MelonPlayer alloc] init];
            appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            //            [[NSNotificationCenter defaultCenter]
            //                      addObserver:self
            //                      selector:@selector(playbackStateChanged:)
            //                      name:ASStatusChangedNotification
            //                      object:streamer];
            songPlayProgress = (double) 0.0;
            playtime         = (double) 0.0;
        }
    }
    return  instance;
}

- (void) installNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:self.streamer];
    isNotificationInstalled = YES;
}
- (void) removeInstance
{
    if (instance != nil)
    {
        [instance release];
        instance = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ASStatusChangedNotification
                                                      object:nil];
        isNotificationInstalled = NO;
    }
}

- (void) registerCalls
{
    self.callCenter = [[CTCallCenter alloc] init];
    NSLog(@"registering for call center events");
    [self.callCenter setCallEventHandler: ^(CTCall* call) {
        
        if ([call.callState isEqualToString: CTCallStateConnected]) {
            
            isCallConnect = 1;
            
        } else if ([call.callState isEqualToString: CTCallStateDialing]) {
            
            isCallConnect = 1;
            
        } else if ([call.callState isEqualToString: CTCallStateDisconnected]) {
            
            isCallConnect = 0;
            
        } else if ([call.callState isEqualToString: CTCallStateIncoming]) {
            
            isCallConnect = 1;
            
        }
        NSLog(@"\n\n callEventHandler: %@ \n\n", call.callState);
    }];
}

- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId
{
    NSLog(@"playThisSong: (NSString *) userId andSongId:(NSString* ) songId");
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self registerCalls];
    
    if (!isNotificationInstalled)
    {
        [self installNotification];
    }
    if (userId == nil)
        userId = @"";
    
    // periksa perizinan lagu.
    [self periksaProdukBasi];
    
    NSString * user_id = userId;
    NSString * song_id = songId;
    time_t timestamp = (time_t) [[NSDate date] timeIntervalSince1970];
    NSString * param = [[[NSString alloc] initWithFormat:@"songId=%@&userId=%@&timestamp=%ld333", song_id, user_id, timestamp] autorelease];
    
    NSString * eparam = [Encryption encryptParam:param];
    NSString * sURL = [NSString stringWithFormat:@"%@drm/download/streaming.jsp?param=%@", [NSString stringWithUTF8String:STREAMING_SERVER], eparam];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:sURL]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"Indonesia Melon Download Agent"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSLog(@"Stream this song: %@.", sURL);
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:nil];
    
    AFHTTPRequestOperation * operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * header = [[operation response] allHeaderFields];
        streamingMetadata = [StreamingBrief getInstance];
        
        NSLog(@"StreamingMetadata.errorCode: %@.", streamingMetadata.errorCode);
        streamingMetadata.errorCode = [header valueForKey:@"errorCode"];
        if ([streamingMetadata.errorCode isEqualToString:@"DRM000200"])
        {
            streamingMetadata.bitRateCd = [header valueForKey:@"bitRateCd"];
            streamingMetadata.codecTypeCd = [header valueForKey:@"codecTypeCd"];
            streamingMetadata.contentId = [header valueForKey:@"contentId"];
            streamingMetadata.fullTrack = [header valueForKey:@"fullTrack"];
            streamingMetadata.playtime = [header valueForKey:@"playtime"];
            streamingMetadata.sampling = [header valueForKey:@"sampling"];
            streamingMetadata.sessionId = [header valueForKey:@"sessionId"];
            sessionId = streamingMetadata.sessionId;
            playtime  = [streamingMetadata.playtime doubleValue];
            [self doStreaming: streamingMetadata.sessionId];
        }
        else
        {
            NSString *errorMessage = @"Maaf, terdapat kesalahan ketika meminta data untuk streaming.";
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:
             NSLocalizedString(@"Streaming",
                               @"Kesalahan streaming")
                                       message:errorMessage
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alertView show];
            isGettingNewSong = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAndStop" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissWaitMessage" object:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error while request streaming");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAndGoNext" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissWaitMessage" object:nil];
        isGettingNewSong = NO;
        
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
    
}

- (void) playThisSong: (NSString *) userId andSongId:(NSString* ) songId songtitle:(NSString* ) songtitle singer:(NSString* ) singer
{
    NSLog(@"playThisSong: (NSString *) userId andSongId:(NSString* ) songId songtitle:(NSString* ) songtitle singer:(NSString* ) singer");
    
    [self registerCalls];
    
	NSLog(@"song Id-->%@",songId);
	self.singer=singer;
	self.title=songtitle;
	self.real_songId=songId;
    if (userId == nil)
        userId = @"";
    NSString * user_id = userId;
    NSString * song_id = songId;
    time_t timestamp = (time_t) [[NSDate date] timeIntervalSince1970];
    NSString * param = [[[NSString alloc] initWithFormat:@"songId=%@&userId=%@&timestamp=%ld333", song_id, user_id, timestamp] autorelease];
    
    NSString * eparam = [Encryption encryptParam:param];
    NSString * sURL = [NSString stringWithFormat:@"%@drm/download/streaming.jsp?param=%@", [NSString stringWithUTF8String:STREAMING_SERVER], eparam];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:sURL]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"Indonesia Melon Download Agent"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:nil];
    
    AFHTTPRequestOperation * operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"responseObject--->%@",responseObject);
        NSDictionary * header = [[operation response] allHeaderFields];
        streamingMetadata = [StreamingBrief getInstance];
		
		
        streamingMetadata.errorCode = [header valueForKey:@"errorCode"];
        if ([streamingMetadata.errorCode isEqualToString:@"DRM000200"])
        {
			
			
            streamingMetadata.bitRateCd = [header valueForKey:@"bitRateCd"];
            streamingMetadata.codecTypeCd = [header valueForKey:@"codecTypeCd"];
            streamingMetadata.contentId = [header valueForKey:@"contentId"];
            streamingMetadata.fullTrack = [header valueForKey:@"fullTrack"];
            streamingMetadata.playtime = [header valueForKey:@"playtime"];
            streamingMetadata.sampling = [header valueForKey:@"sampling"];
            streamingMetadata.sessionId = [header valueForKey:@"sessionId"];
            [self doStreaming: streamingMetadata.sessionId];
        }
        else
        {
			//[self performSelector:@selector(playmini) withObject:nil afterDelay:0.5];
            NSString *errorMessage = @"Maaf, terdapat kesalahan ketika meminta data untuk streaming.";
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:
             NSLocalizedString(@"Streaming",
                               @"Kesalahan streaming")
                                       message:errorMessage
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alertView show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAndStop" object:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error while request streaming");
		//[self performSelector:@selector(playmini) withObject:nil afterDelay:0.5];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAndGoNext" object:nil];
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
	
}

- (void) doStreaming: (NSString*) sessionID
{
    [self registerCalls];
    
    NSString * strUrl = [[NSString alloc] initWithFormat:@"%@drm/download/streaming.jsp?sessionId=%@", [NSString stringWithUTF8String:STREAMING_SERVER], sessionID];
    
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef) strUrl,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
    NSURL * sUrl = [NSURL URLWithString:escapedValue];
    
	NSLog(@"sUrl-->%@",sUrl);
    [self playSongWithURL:sUrl];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayNewSong" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPlayer" object:nil];
    //isGettingNewSong = NO;
    BOOL myBool = NO;
    NSNumber *myObject = [NSNumber numberWithBool:myBool];
    [self performSelector:@selector(setGettingNewSong:) withObject:myObject afterDelay:2];
    
}

-(void)playmini{
	NSMutableArray *a=[[NSMutableArray alloc]init];
	[a addObject:[NSString stringWithFormat:@"1"]];///stream
    if (self.title != nil)
    {
        [a addObject:self.title];
    }
    else
    {
        [a addObject:@""];
    }

    if (self.singer != nil)
    {
        [a addObject:self.singer];
    }
    else
    {
        [a addObject:@""];
    }
    
    if (self.real_songId != nil)
    {
        [a addObject:self.real_songId];
    }
    else
    {
        [a addObject:@""];
    }
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"playingmini" object:a];
	[a removeAllObjects];
}
- (void) playSongWithURL: (NSURL *) url
{
    [self stop];
    [self destroyStreamer];
    sleep(1.5);
    if ([self isPlaying])
    {
        return;
    }
    switch (songType) {
        case 0:
            {
                NSLog(@"play song from server.");
                streamer = [[AudioStreamer alloc] initWithURL:url];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: NO error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [streamer start];
            }
            break;
            
        case 1:
            NSLog(@"play song from local storage. %@", url);
            localStreamer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
            [localStreamer setDelegate: self];
            
            [[AVAudioSession sharedInstance] setDelegate: self];
            NSError *setCategoryError = nil;
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
            if (setCategoryError)
                NSLog(@"Error setting category! %@", setCategoryError);
            [localStreamer prepareToPlay];
            [localStreamer play];
            
            break;
            
        default:
            break;
    }
    
    isGettingNewSong = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayNewSong" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPlayer" object:nil];
    [self performSelector:@selector(playmini) withObject:nil afterDelay:0.5];
    BOOL myBool = NO;
    NSNumber *myObject = [NSNumber numberWithBool:myBool];
    [self performSelector:@selector(setGettingNewSong:) withObject:myObject afterDelay:2];
	
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotifPlayNewSong object:nil];
	//[self performSelector:@selector(playmini) withObject:nil afterDelay:0.5];
	
}

- (void)destroyStreamer
{
	
	if (streamer)
	{
		[streamer stop];
		[streamer release];
		NSLog(@"selesai mainnnn");
		streamer = nil;
	}
}

- (void) stop
{
    if (bTimerON)
    {
        if (progressUpdateTimer != nil)
        {
            [progressUpdateTimer invalidate];
            progressUpdateTimer = nil;
        }
        bTimerON = NO;
    }
    [streamer stop];
    [localStreamer stop];
	
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void) pause
{
    switch (songType) {
        case 0:
            [streamer pause];
            break;
            
        case 1:
            [localStreamer pause];
            break;
            
        default:
            break;
    }
	
}

- (void) play
{
    switch (songType) {
        case 0:
            [streamer start];
            break;
            
        case 1:
            [localStreamer play];
            break;
            
        default:
            break;
    }
    
    //[streamer start];
    
}

- (BOOL) isWaiting
{
    BOOL retVal = NO;
    switch (songType) {
        case 0:
            retVal = streamer.isWaiting;
            break;
            
        case 1:
            retVal = localStreamer.prepareToPlay;
            break;
            
        default:
            break;
    }
    return retVal;
}

- (BOOL) isPaused
{
    BOOL retVal = NO;
    switch (songType) {
        case 0:
            retVal = streamer.isPaused;
            break;
            
        case 1:
            retVal = !localStreamer.isPlaying;
            break;
            
        default:
            break;
    }
    return retVal;
}

- (BOOL) isPlaying
{
    BOOL retVal = NO;
    switch (songType) {
        case 0:
            retVal = streamer.isPlaying;
            break;
            
        case 1:
            if (localStreamer != Nil)
            {
                retVal = localStreamer.isPlaying;
            }
            break;
            
        default:
            break;
    }
    return retVal;
}

- (BOOL) isIdle
{
    BOOL retVal = NO;
    switch (songType) {
        case 0:
            retVal = streamer.isIdle;
            break;
            
        case 1:
            retVal = !localStreamer.isPlaying;
            break;
            
        default:
            break;
    }
    return retVal;
}

- (BOOL) isGettingNewSong
{
    if (isGettingNewSong)
    {
        NSLog(@"isGettingNewSong : YES.");
    }
    else
    {
        NSLog(@"isGettingNewSong : NO.");
    }
    return isGettingNewSong;
}

- (BOOL) isProdukBasi
{
    return isProdukBasi;
}

- (void) sendStreamingNotify
{
    NSLog(@"sendStreamingNotify");
    
    int lr = 0;
    if (playtime <= 0 || [sessionId isEqualToString:@""])
        return;
    
    lr = (int) (songPlayProgress * 100 / playtime);
    NSString * listeningRate = [NSString stringWithFormat:@"%d",lr ];
    NSString * channelCd     = [NSString stringWithUTF8String:CHANNEL_CODE];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              sessionId, @"sessionId",
                              listeningRate, @"listeningRate",
							  channelCd,@"channelCd",
                              nil]
                             autorelease];
    
    NSString * sURL = [NSString stringWithFormat:@"%@drm/download/streamingNotify.jsp", [NSString stringWithUTF8String:STREAMING_SERVER]];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:sURL]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"Indonesia Melon Download Agent"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    
    AFHTTPRequestOperation * operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Send streaming notify succeed.");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Send streaming notify failed.");
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}

- (void) setSongType:(NSInteger)iSongType
{
    songType = iSongType;
}

- (NSInteger) getSongType
{
    return songType;
}

- (NSString *) checkLocalSong: (NSString *) songId
{
    NSString * ret = @"";
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", songId]];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileExist)
    {
        ret = [NSString stringWithString:filepath];
    }
    return  ret;
}

- (NSString *) checkLocalSong: (NSString *) songId forUserId: (NSString *) userId
{
    NSString * ret = @"";
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.m4a", userId, songId]];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileExist)
    {
        ret = [NSString stringWithString:filepath];
    }
    return  ret;
}

- (double) getSongDuration
{
    double retVal = -1.0;
    switch (songType) {
        case 0:
            if (streamer.bitRate != 0.0)
            {
                retVal = streamer.duration;
            }
            break;
            
        case 1:
            retVal = [localStreamer duration];
            break;
            
        default:
            break;
    }
    
    return retVal;
}

- (double) getSongPlayProgress
{
    double retVal = -1.0;
    switch (songType) {
        case 0:
            if (streamer.bitRate != 0.0)
            {
                retVal = streamer.progress;
            }
            break;
            
        case 1:
            @try {
                retVal = [localStreamer currentTime];
            }
            @catch (NSException *exception) {
                NSLog(@"error [localStreamer currentTime].");
            }
            //retVal = [localStreamer currentTime];
            break;
            
        default:
            break;
    }
    
    songPlayProgress = songPlayProgress < retVal ? retVal : songPlayProgress;
    
    return retVal;
}

- (void) doNext
{
    isGettingNewSong = YES;
    //NSInteger prevNowPlayingSongIndex = appDelegate.nowPlayingSongIndex;
    NSInteger prevNowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex;
    
    if (REPEAT_NO == (appDelegate.playOption & REPEAT_NO))
    {
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex +1 >= [appDelegate.nowPlayingPlayOrder count] ? appDelegate.nowPlayingPlayOrderIndex : ++appDelegate.nowPlayingPlayOrderIndex;
        
        if (appDelegate.nowPlayingPlayOrderIndex == prevNowPlayingPlayOrderIndex || appDelegate.nowPlayingPlayOrderIndex >= [appDelegate.nowPlayingPlayOrder count])
        {
            isGettingNewSong = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifFullStop] object:nil];
            return;
        }
    }
    else if (REPEAT_THIS == (appDelegate.playOption & REPEAT_THIS))
    {
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex;
    }
    else if (REPEAT_ALL == (appDelegate.playOption & REPEAT_ALL))
    {
        /*
        appDelegate.nowPlayingSongIndex = appDelegate.nowPlayingSongIndex +1 >= [appDelegate.nowPlayingPlayOrder count] ? 0 : ++appDelegate.nowPlayingSongIndex;
         */
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex +1 >= [appDelegate.nowPlayingPlayOrder count] ? 0 : ++appDelegate.nowPlayingPlayOrderIndex;
    }
    
    NSNumber * nextSongIndex = [appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex];
    
    appDelegate.nowPlayingSongIndex = nextSongIndex.integerValue;
    LocalPlaylist1 * nextSong = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:nextSongIndex.integerValue];
    
    if ([nextSong.songId isEqualToString:(NSString *)[NSNull null]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifFullStop] object:nil];
        isGettingNewSong = NO;
        return;
    }
    
    NSLog(@"nextSong.songPath: %@", nextSong.songPath);
    [self stop];
    sleep(1);
    // Play song by streaming
    if ([nextSong.songPath isEqualToString:@""])
    {
        
        
        //NSArray * myObject = [NSArray arrayWithObjects:appDelegate.eUserId, nextSong.songId, nil];
        //[self performSelector:@selector(playThisSong:andSongId:) withObject:myObject afterDelay:
        //1.0];
        [self setSongType:0];
        [self playThisSong:appDelegate.eUserId andSongId:nextSong.songId];
    }
    
    else
    {
        [self setSongType:1];
        NSLog(@"index: songTitle, songId, songArtist: %d, %@, %@, %@", appDelegate.nowPlayingPlayOrderIndex, nextSong.songTitle, nextSong.songId, nextSong.artistName);
        [self playSongWithURL:[NSURL fileURLWithPath:nextSong.songPath]];
        isGettingNewSong = NO;
    }
}

- (void) doPrev
{
    isGettingNewSong = YES;
    NSInteger prevNowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex;


    if (REPEAT_NO == (appDelegate.playOption & REPEAT_NO))
    {
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex -1 < 0 ? appDelegate.nowPlayingPlayOrderIndex : --appDelegate.nowPlayingPlayOrderIndex;
        
        if (appDelegate.nowPlayingPlayOrderIndex == prevNowPlayingPlayOrderIndex || appDelegate.nowPlayingPlayOrderIndex < 0)
        {
            isGettingNewSong = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifFullStop] object:nil];
            return;
        }
    }
    else if (REPEAT_THIS == (appDelegate.playOption & REPEAT_THIS))
    {
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex;
    }
    else if (REPEAT_ALL == (appDelegate.playOption & REPEAT_ALL))
    {
        appDelegate.nowPlayingPlayOrderIndex = appDelegate.nowPlayingPlayOrderIndex -1 < 0 ? [appDelegate.nowPlayingPlayOrder count] -1 : --appDelegate.nowPlayingPlayOrderIndex;
    }

    NSNumber * prevSongIndex = [appDelegate.nowPlayingPlayOrder objectAtIndex:appDelegate.nowPlayingPlayOrderIndex];
    
    appDelegate.nowPlayingSongIndex = prevSongIndex.integerValue;
    LocalPlaylist1 * prevSong = [appDelegate.nowPlayingPlaylistDefault objectAtIndex:prevSongIndex.integerValue];

    if ([prevSong.songId isEqualToString:(NSString*)[NSNull null]])
    {
        isGettingNewSong = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifFullStop] object:nil];
        return;
    }

    [self stop];
    sleep(1);
    //NSLog(@"nextSong song id filePath: %@, %@", prevSong.songId, prevSong.songPath);
    if ([prevSong.songPath isEqualToString:@""])
    {
        [self setSongType:0];
        //NSArray * myObject = [NSArray arrayWithObjects:appDelegate.eUserId, prevSong.songId, nil];
        [self playThisSong:appDelegate.eUserId andSongId:prevSong.songId];
        //[self performSelector:@selector(playThisSong:andSongId:) withObject:myObject afterDelay:1.0];
        
    }
    else
    {
        [self setSongType:1];
        [self playSongWithURL:[NSURL fileURLWithPath:prevSong.songPath]];
        isGettingNewSong = NO;
    }
}

- (void) playbackStateChanged: (NSNotification *) aNotification
{
    NSLog(@"isCallConnect %i", isCallConnect);
    if(isCallConnect==1) {
        if ([self isPaused]==NO) {
            NSLog(@"PAUSE PLAYER");
            [self pause];
        }
        return;
    }
    
    if ([self isWaiting])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifWaiting] object:nil];
    }
    
    if ([self isPlaying])
    {
        //isGettingNewSong = NO;
        BOOL myBool = NO;
        NSNumber *myObject = [NSNumber numberWithBool:myBool];
        [self performSelector:@selector(setGettingNewSong:) withObject:myObject afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifPlay] object:nil];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
    
    if ([self isIdle])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifIdle] object:nil];
        
        sleep(1);
        if (![self isGettingNewSong])
        {
            [self performSelector:@selector(doNext) withObject:nil afterDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"toNextSong" object:nil];
        }
    
        [self sendStreamingNotify];
        sessionId = @"";
        songPlayProgress = (double) 0.0;
    }
    
    if ([self isPaused])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifPause] object:nil];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithUTF8String:kNotifIdle] object:nil];
    
    if (![self isGettingNewSong])
    {
        [localStreamer release];
        localStreamer = Nil;
        [self performSelector:@selector(doNext) withObject:nil afterDelay:1.2];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void) setGettingNewSong: (NSNumber *) value
{
    if(isCallConnect==1) {
        if ([self isPaused]==NO) {
            NSLog(@"PAUSE PLAYER IN setGettingNewSong");
            [self pause];
        }
        return;
    }
    
    isGettingNewSong = (BOOL) value.integerValue;
    NSLog(@"setting new song flag.");
    NSLog(@"iscallconn %i",isCallConnect);
    if (!bTimerON)
    {
        [self createPlayerTimer];
        bTimerON = YES;
    }
    [self isGettingNewSong];
}

- (BOOL) periksaProdukBasi
{
    BOOL retVal = YES;
    isProdukBasi = YES;
    
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    int tanggal = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    //Layanan * eLayanan = [[Layanan alloc] init];
    NSMutableArray * lyn = [NSMutableArray arrayWithArray:[Layanan MR_findAll]];
    if ([lyn count] > 0)
    //if (appDelegate.isGetLayanan)
    {
        //eLayanan = [lyn objectAtIndex:0];
        Layanan * eLayanan = (Layanan *) [lyn objectAtIndex:0];       // ekachan 20130625
        int akhir = [eLayanan.useEndDate intValue];
        int tenggang = [eLayanan.gracePeriodStream intValue];
    
        if (tanggal - (akhir + tenggang) <= 0)
        {
            retVal = NO;
            isProdukBasi = NO;
        }
    }
    
    return retVal;
}

- (void) createPlayerTimer
{
    progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(songProgress:)
                                                         userInfo:nil
                                                          repeats:YES];
    bTimerON = YES;
}

- (void) songProgress: (NSTimer *) updateTimer
{
    double progress = [self getSongPlayProgress];
    
    int pp = (int) (progress);
    if (!isProdukBasi)
    {
        return;
    }
    else
    {
        if (songType == 0)
        {
            if (pp > 60 )
            {
                [self stop];
                if (progressUpdateTimer != nil)
                {
                    [progressUpdateTimer invalidate];
                    progressUpdateTimer = nil;
                }
                bTimerON = NO;
                [self doNext];
            }
        }
    }
}

- (void) periksaLagudanStream: (NSString *) songId
{
    NSLog(@"periksaLagudanStream");
    
    NSString * sURL = [NSString stringWithFormat:@"%@songs/set", [NSString stringWithUTF8String:MAPI_SERVER]];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              songId, @"songIdList",
                              @"c", @"_DIR",
                              [NSString stringWithUTF8String:CNAME], @"_CNAME",
                              [NSString stringWithUTF8String:CPASS], @"_CPASS",
                              nil] autorelease];
    
    NSURL * URL = [NSURL URLWithString:sURL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // get songbrief and should be only one for the result.
        NSString * streamingYN = @"";
        NSLog(@"responseObject: %@", [responseObject description]);
        NSLog(@"request: %@", [request description]);
        @try {
            if ([[responseObject objectAtIndex:0] objectForKey:@"sellStreamYN"] != (NSString *) [NSNull null])
            {
                streamingYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"sellStreamYN"] ];
            }
            
            if ([streamingYN isEqualToString:@"Y"])
            {
                [self playThisSong:appDelegate.eUserId andSongId:songId];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
                                             message:@"Maaf, lagu yang diminta tidak diizinkan untuk didengar langsung dari server. Silahkan coba lagu yang lainnya, atau pastikan paket langganan Anda betul."
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] autorelease] show];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"galat di waktu mengambil data di periksaLagudanStream.");
            [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
										 message:@"Terjadi masalah ketika mengambil data dari server. Maaf atas ketidaknyamanan ini."
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissWaitMessage" object:nil];
            isGettingNewSong = NO;
        }

		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			[[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
										 message:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
			
		}
        NSLog(@"error: %@", [error description]);
       
        isGettingNewSong = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissWaitMessage" object:nil];
		
	}];
    
    // pertontonkan pesan tunggu.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWaitMessage" object:nil];
    
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}

@end
