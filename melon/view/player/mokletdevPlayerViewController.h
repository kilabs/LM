//
//  mokletdevPlayerViewController.h
//  melon
//
//  Created by Arie on 3/23/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DCKnob.h"
//#import "mokletdevSearchMusicController.h"

@class MHRotaryKnob;
@class MelonPlayer;
@class localplayer;
@interface mokletdevPlayerViewController : UIViewController<UIActionSheetDelegate>
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
	UIButton * btnPlayPause_local;
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
    NSTimer * checkTimer;
    
    MelonPlayer * myPlayer;
	localplayer * localPlayer;
	UIActionSheet *actionSheet;
	//mokletdevSearchMusicController *searchWindow;
    
    UIImageView * gTunggu;
}

@property(nonatomic,strong)	NSString * sSongTitle;
@property(nonatomic,strong)	NSString * sSongId;
@property(nonatomic,strong)	NSString * sArtistId;
@property(nonatomic,strong)	NSString * sArtistName;
@property(nonatomic,strong)	NSString * sAlbumId;
@property(nonatomic,strong)	NSString * sAlbumName;
@property(nonatomic,strong)	NSString * real_songid;
@property(nonatomic,strong)	NSString * status;
@property(nonatomic,strong)	NSString * playTime;

@property (nonatomic, strong) MHRotaryKnob *rotaryKnob;

@property (nonatomic, strong) UIImageView * gTunggu;

- (void) createTimer;

@end
