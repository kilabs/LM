//
//  playerLocalViewController.h
//  melon
//
//  Created by Arie on 5/2/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DCKnob.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>

//#import "mokletdevSearchMusicController.h"

@class MHRotaryKnob;
@class MelonPlayer;
@interface playerLocalViewController : UIViewController<AVAudioPlayerDelegate>
{
	UIButton *backtoBefore;
	UIButton *search;
	
	UIImageView *picture;//gambar
	
	
    
    NSString * sSongTitle;
    NSString * sSongId;
	NSString * sArtistId;
	NSString * sArtistName;
	NSString * sAlbumId;
    NSString * sAlbumName;
    
    UIButton * btnPlayPause;
	UIButton * btnNext;
    UIButton * btnPrev;
    UIButton * btnRepeat;
    UIButton * btnShuffle;
    UIButton * btnLyric;
    UIButton * btnDownload;
    
    UIButton * btnShare;
    UIButton * btnFb;
    UIButton * btnTt;
    
    UIButton * backButton;
    UIButton * searchButton;
    
	UILabel * songTitle;
    
	UILabel * songArtistName;
    UILabel * songAlbumName;
    
    UILabel * playingTime;
    
    UISlider * songProgress;
    UIImageView * albumImageView;
    UIImageView * space;
    UIView * albumImagePlaceholderView;
    UIView * playerControlArea;
    UIView * knobContainer;
    UIView * shareItemView;
    DCKnob * knob;
    MPVolumeView * volumeView;
	
    
    NSTimer * progressUpdateTimer;
    
    MelonPlayer * myPlayer;
}
@property(nonatomic,strong)	NSString * sSongTitle;
@property(nonatomic,strong)	NSString * sSongId;
@property(nonatomic,strong)	NSString * sArtistId;
@property(nonatomic,strong)	NSString * sArtistName;
@property(nonatomic,strong)	NSString * sAlbumId;
@property(nonatomic,strong)	NSString * sAlbumName;
@property(nonatomic,strong)	NSString * filePath;
@property (nonatomic, strong) MHRotaryKnob *rotaryKnob;
@property (nonatomic, strong) AVAudioPlayer *playerdatalocal;

@end
