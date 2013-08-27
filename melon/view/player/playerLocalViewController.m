//
//  mokletdevPlayerViewController.m
//  melon
//
//  Created by Arie on 3/23/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "playerLocalViewController.h"
#import "MHRotaryKnob.h"
#import <QuartzCore/QuartzCore.h>
#import "MelonPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioToolbox/AudioToolbox.h"
#import "mokletdevAppDelegate.h"
#import "AFNetworking.h"
@interface playerLocalViewController ()

@end
@implementation UINavigationBar (custom)
- (void)drawRect:(CGRect)rect {}
AVAudioPlayer *audioPlayer;
@end
@implementation playerLocalViewController

@synthesize sSongTitle;
@synthesize sSongId;
@synthesize sArtistId;
@synthesize sArtistName;
@synthesize sAlbumId;
@synthesize sAlbumName;

@synthesize rotaryKnob;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title=@"Player";
		 
    }
    return self;
}

- (void) doPlayPause
{
    btnPlayPause.selected = !btnPlayPause.selected;
    if (audioPlayer.isPlaying)
    {
		//[myPlayer pause];
		[audioPlayer pause];
    }
    else
    {
		// [myPlayer play];
		[audioPlayer play];
    }
}

- (void) doNext
{
    
}

- (void) doPrev
{
    
}

- (void) doDownload
{/*
  // periksa login
  mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate*) [[UIApplication sharedApplication] delegate];
  if ([appDelegate eUserId] == nil)
  {
  NSString *errorMessage = @"Silahkan login terlebih dahulu untuk dapat mengambil lagu.";
  UIAlertView *alertView =
  [[[UIAlertView alloc] initWithTitle:
  NSLocalizedString(@"Download",
  @"Kesalahan login")
  message:errorMessage
  delegate:nil
  cancelButtonTitle:@"OK"
  otherButtonTitles:nil] autorelease];
  [alertView show];
  
  return;
  }
  
  NSString * songId = sSongId;
  NSString * tipe = @"D";
  NSString * bitRate = @"128";
  
  //[appDelegate getSongDownloadID:userId ofSong:songId withType:tipe andBitRate:bitRate];
  // [appDelegate doDownloadSong:songId withType:tipe andBitRate:bitRate];
  */
}
-(void)playing{
	NSLog(@"is playing");
	[audioPlayer stop];
	NSURL *url = [[NSURL alloc] initFileURLWithPath:self.filePath];
	myPlayer = [MelonPlayer sharedInstance];
	[myPlayer.streamer stop];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	audioPlayer.delegate = self;
	audioPlayer.volume=1;

		[audioPlayer stop];
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		[[AVAudioSession sharedInstance] setActive: YES error: nil];
		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

		[audioPlayer prepareToPlay];
		[audioPlayer play];
	[self createTimer];
			
	}
-(void)stop{
[audioPlayer stop];
}
- (void) repeatToggle
{
    audioPlayer.numberOfLoops=1;
}

- (void) shuffleToggle
{
    
}

- (void) lyricToggle
{
    
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"] forBarMetrics:UIBarMetricsDefault];
}

- (void) doSearch
{
    //searchWindow=[[[mokletdevSearchMusicController alloc]init] autorelease];
	//UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchWindow];
    
    //[self presentModalViewController:navigationController animated:YES];
    
}

-(void)rotaryKnobDidChange{
	
}

-(void)balik{
    [self.navigationController dismissModalViewControllerAnimated:YES];
	
	
	
}
-(void)viewWillAppear:(BOOL)animated{
//	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	//change back button image
	backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlEventTouchDown];
	[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
	searchButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
	[searchButton setBackgroundImage:[UIImage imageNamed:@"playersearch"] forState:UIControlStateNormal];
	[searchButton setBackgroundImage:[UIImage imageNamed:@"playersearchhl"] forState:UIControlEventTouchDown];
	[searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
	
	//UIBarButtonItem * searchButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
	self.navigationItem.leftBarButtonItem = backButtonItem;
	

	 
	
	

	
    
	
	
}
-(void)viewWillDisappear:(BOOL)animated{
	self.navigationItem.hidesBackButton = YES;
	self.navigationController.navigationBar.hidden=NO;
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-lain"] forBarMetrics:UIBarMetricsDefault];
	animated=YES;

	
}
-(void)viewDidLayoutSubviews{
	
	[self initLayout];
}

-(void)initLayout{
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",self.sSongId];
	[albumImageView setImageWithURL:[NSURL URLWithString:baseUrls] placeholderImage:[UIImage imageNamed:@"placeholder"]];
	[songTitle setText:self.sSongTitle];
	[songAlbumName setText:self.sAlbumName];
	[songArtistName setText:self.sArtistName];
    
}
- (void)viewDidLoad
{
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stop)
												name:@"stop"
											  object:nil];

    [super viewDidLoad];
    
    CGFloat eWidth = CGRectGetWidth(self.view.bounds);
    CGFloat eHeight = CGRectGetHeight(self.view.bounds);
	
    playerControlArea = [[[UIView alloc] initWithFrame:CGRectMake(0.0, eHeight - 244.0, eWidth, 200)] autorelease];
    playerControlArea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:playerControlArea];
    
    UIImageView * playerControlAreaBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, eWidth, 200)] autorelease];
    [playerControlAreaBg setImage:[UIImage imageNamed:@"latarbawah"]];
    [playerControlArea addSubview:playerControlAreaBg];
    
    btnPlayPause = [[[UIButton alloc] initWithFrame:CGRectMake(125.0, 150.0, 69.0, 47.0)] autorelease];
    [btnPlayPause setBackgroundImage:[UIImage imageNamed:@"playerplaybtn"] forState:UIControlStateNormal];
    [btnPlayPause setBackgroundImage:[UIImage imageNamed:@"playerpausebtn"] forState:UIControlStateSelected];
    [btnPlayPause addTarget:self action:@selector(doPlayPause) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnPlayPause];
    
    btnNext = [[[UIButton alloc] initWithFrame:CGRectMake(195.0, 157.0, 40.0, 40.0)] autorelease];
    [btnNext setBackgroundImage:[UIImage imageNamed:@"playernextbtn"] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [playerControlAreaBg addSubview:btnNext];
    
    btnPrev = [[[UIButton alloc] initWithFrame:CGRectMake(80.0, 157.0, 40.0, 40.0)] autorelease];
    [btnPrev setBackgroundImage:[UIImage imageNamed:@"playerprevbtn"] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(doPrev) forControlEvents:UIControlEventTouchUpInside];
    [playerControlAreaBg addSubview:btnPrev];
    
    CGFloat eLeft = 20.0;
    CGFloat eTop = 31.0;
    songTitle = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop, 212.0, 30.0)] autorelease];
    songTitle.text = @"eka tampan, EKA TAMPAN, eka tampan, eka tampan";
    songTitle.textColor = [UIColor whiteColor];
    songTitle.backgroundColor = [UIColor clearColor];
    [songTitle setFont:[UIFont fontWithName:@"OpenSans" size:24]];
    [playerControlArea addSubview:songTitle];
    
    UIImageView * divider = [[[UIImageView alloc] initWithFrame:CGRectMake(eLeft + 216.0, eTop + 6.0, 2.0, 20.0)] autorelease];
    [divider setImage:[UIImage imageNamed:@"playerdivider"]];
    [playerControlArea addSubview:divider];
    
    playingTime = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft + 216.0 + 4.0, eTop, 80.0, 30.0)] autorelease];
    playingTime.text = @"00:00";
    playingTime.textColor = [UIColor whiteColor];
    playingTime.backgroundColor = [UIColor clearColor];
    [playingTime setFont:[UIFont fontWithName:@"OpenSans" size:24]];
    [playerControlArea addSubview:playingTime];
    
    
    eTop += 28.0;
    songArtistName = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop, 200.0, 14.0)] autorelease];
    
    songArtistName.textColor = [UIColor whiteColor];
    songArtistName.backgroundColor = [UIColor clearColor];
    [songArtistName setFont:[UIFont fontWithName:@"OpenSans" size:12]];
    [playerControlArea addSubview:songArtistName];
    
    eTop += 14.0;
    songAlbumName = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop, 200.0, 14.0)] autorelease];
    songAlbumName.text = @"eka tampan, EKA TAMPAN, eka tampan, eka tampan";
    songAlbumName.textColor = [UIColor whiteColor];
    songAlbumName.backgroundColor = [UIColor clearColor];
    [songAlbumName setFont:[UIFont fontWithName:@"OpenSans" size:12]];
    [playerControlArea addSubview:songAlbumName];
    
    eTop += 24.0;
    btnRepeat = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 22.0, 22.0)] autorelease];
    [btnRepeat setBackgroundImage:[UIImage imageNamed:@"playerrepeatalloffbtn"] forState:UIControlStateNormal];
    [btnRepeat setBackgroundImage:[UIImage imageNamed:@"playerrepeatallonbtn"] forState:UIControlStateSelected];
    [btnRepeat addTarget:self action:@selector(repeatToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnRepeat];
    
    eLeft += 34;
    btnShuffle = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 22.0, 22.0)] autorelease];
    [btnShuffle setBackgroundImage:[UIImage imageNamed:@"playershuffleoffbtn"] forState:UIControlStateNormal];
    [btnShuffle setBackgroundImage:[UIImage imageNamed:@"playershuffleonbtn"] forState:UIControlStateSelected];
    [btnShuffle addTarget:self action:@selector(shuffleToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnShuffle];
    
    eLeft += 34;
    btnLyric = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 22.0, 22.0)] autorelease];
    [btnLyric setBackgroundImage:[UIImage imageNamed:@"playerlyricoffbtn"] forState:UIControlStateNormal];
    [btnLyric setBackgroundImage:[UIImage imageNamed:@"playerlyriconbtn"] forState:UIControlStateSelected];
    [btnLyric addTarget:self action:@selector(lyricToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnLyric];
    
    eLeft += 34;
    btnDownload = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 22.0, 22.0)] autorelease];
    [btnDownload setBackgroundImage:[UIImage imageNamed:@"playerdownloadbtn"] forState:UIControlStateNormal];
    [btnDownload setBackgroundImage:[UIImage imageNamed:@"playerdownloadhlbtn"] forState:UIControlStateSelected];
    [btnDownload addTarget:self action:@selector(doDownload) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnDownload];
    
    songProgress = [[[UISlider alloc] initWithFrame:CGRectMake(50.0, 3.0, 230.0, 22)] autorelease];
    
    [songProgress setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlStateNormal];
    [songProgress setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlEventTouchUpInside];
    [songProgress setMinimumTrackImage: [UIImage imageNamed:@"playerprogressprogress"] forState: UIControlStateNormal];
    [songProgress setMaximumTrackImage: [UIImage imageNamed:@"playerprogressbg"] forState: UIControlStateNormal];
    songProgress.minimumValue=0;
    songProgress.value=0;
    [playerControlArea addSubview:songProgress];
    
    knobContainer = [[[UIView alloc] initWithFrame:CGRectMake(playerControlArea.bounds.size.width - 90.0, eTop -24.0, 80.0, 80.0)] autorelease];
    knobContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    knobContainer.layer.shadowOffset = CGSizeZero;
    knobContainer.layer.shadowRadius = 9.0;
    knobContainer.layer.shadowOpacity = 1.0;
    knobContainer.backgroundColor = [UIColor clearColor];
    [playerControlArea addSubview:knobContainer];
    
    
    
    knob = [[[DCKnob alloc] initWithDelegate:self] autorelease];
    CGFloat initialKnobSize = 80.0;
    knob.frame = CGRectMake(floorf((knobContainer.frame.size.width - initialKnobSize) / 2),
                            floorf((knobContainer.frame.size.height - initialKnobSize) / 2),
                            initialKnobSize,
                            initialKnobSize);
    knob.labelFont = [UIFont boldSystemFontOfSize:1.0];
    knob.color = [UIColor colorWithRed:0.0 green:80.0 blue:0.0 alpha:0.50];
    knob.backgroundColor = knobContainer.backgroundColor;
    knob.min = 0.0;
    knob.max = 1.0;
    knob.doubleTapValue = 0.50;
    knob.tripleTapValue = 1.0;
    //knob.value = 0.0;
    knob.value = [[MPMusicPlayerController applicationMusicPlayer] volume];
    knob.displaysValue = NO;
    knob.valueArcWidth = 1.50;
    [knobContainer addSubview:knob];
    
    volumeView = [[[MPVolumeView alloc] initWithFrame:knobContainer.bounds] autorelease];
    volumeView.hidden = YES;
    [knobContainer addSubview:volumeView];
    
    UIView * albumArtContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, -44.0, eWidth, eHeight - playerControlArea.bounds.size.height)] autorelease];
    albumArtContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    albumArtContainer.layer.shadowOffset = CGSizeZero;
    albumArtContainer.layer.shadowRadius = 9.0;
    albumArtContainer.layer.shadowOpacity = 1.0;
    albumArtContainer.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:albumArtContainer aboveSubview:playerControlArea];
    
    UIImageView * latarAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, albumArtContainer.bounds.size.width, albumArtContainer.bounds.size.height + 22)];
    [latarAlbum setImage:[UIImage imageNamed:@"playerlatargambar"]];
    [albumArtContainer addSubview:latarAlbum];
    
    CGFloat oX, oY, sisi;
    //CGFloat eL = albumArtContainer.bounds.size.width;
    //CGFloat eT = albumArtContainer.bounds.size.height - 50;
    CGFloat eL = latarAlbum.bounds.size.width;
    CGFloat eT = latarAlbum.bounds.size.height - 50;
    if (eL > eT)
    {
        sisi = eT - 30.0;
        oX = (eL - sisi) /2;
        oY = (eT -sisi) /2 + 38;
    }
    else
    {
        sisi = eL - 30.0;
        oX = (eL -sisi) /2;
        oY = (eT - sisi) /2 +38;
    }
    
    UIView * albumCoverPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(oX, oY, sisi, sisi)] autorelease];
    albumCoverPlaceholder.layer.shadowColor = [UIColor blackColor].CGColor;
    albumCoverPlaceholder.layer.shadowOffset = CGSizeZero;
    albumCoverPlaceholder.layer.shadowRadius = 9.0;
    albumCoverPlaceholder.layer.shadowOpacity = 1.0;
    [albumArtContainer addSubview:albumCoverPlaceholder];
    
    albumImageView = [[UIImageView alloc] initWithFrame:albumCoverPlaceholder.bounds];
    [albumImageView setImage:[UIImage imageNamed:@"playeralbumcover"]];
    [albumCoverPlaceholder addSubview:albumImageView];
    
    
    
    UIView * shareView = [[[UIView alloc] initWithFrame:CGRectMake(oX + sisi - 90.0, oY + sisi -90, 90.0, 90.0)] autorelease];
    //[shareView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:shareView];
    
    oX = shareView.bounds.origin.x + shareView.bounds.size.width - 40.0;
    oY = shareView.bounds.origin.y + shareView.bounds.size.height - 84.0;
    btnShare = [[[UIButton alloc] initWithFrame:CGRectMake(oX, oY, 45.0, 45.0)] autorelease];
    [btnShare setImage:[UIImage imageNamed:@"bagihijau"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"bagihijauhl"] forState:UIControlStateSelected];
    [btnShare addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:btnShare];
    
    shareItemView = [[[UIView alloc] initWithFrame:CGRectMake(oX -40, oY + 45, 85.0, 33.0)] autorelease];
    //shareItemView.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:shareItemView];
    
    UIImageView * shareItemImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, shareItemView.bounds.size.width, shareItemView.bounds.size.height)];
    [shareItemImageBg setImage:[UIImage imageNamed:@"bagilatar"]];
    [shareItemView addSubview:shareItemImageBg];
    
    btnFb = [[[UIButton alloc] initWithFrame:CGRectMake(4.0, 2.0, 33.0, 33.0)] autorelease];
    [btnFb setImage:[UIImage imageNamed:@"bagifb"] forState:UIControlStateNormal];
    [btnFb setImage:[UIImage imageNamed:@"bagifbhl"] forState:UIControlStateHighlighted];
    [btnFb addTarget:self action:@selector(fbShareClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareItemView addSubview:btnFb];
    
    btnTt = [[[UIButton alloc] initWithFrame:CGRectMake(45.0, 2.0, 33.0, 33.0)] autorelease];
    [btnTt setImage:[UIImage imageNamed:@"bagitt"] forState:UIControlStateNormal];
    [btnTt setImage:[UIImage imageNamed:@"bagitthl"] forState:UIControlStateHighlighted];
    [btnTt addTarget:self action:@selector(ttShareClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareItemView addSubview:btnTt];
    
    shareItemView.hidden = YES;
    [self playing];
}

- (void) shareClicked
{
    shareItemView.hidden = !shareItemView.hidden;
    btnShare.selected = !btnShare.selected;
}

- (void) fbShareClicked
{
    
}

- (void) ttShareClicked
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controlValueDidChange:(float)value sender:(id)sender
{
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:value];

   // [myPlayer.streamer setVolume:value];
	[audioPlayer setVolume:value];
    //AudioQueue audioQueue;
    //AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 0.5);
    
}

- (void) createTimer
{
    if (myPlayer)
    {
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateProgress:)
                                                             userInfo:nil
                                                              repeats:YES];
        
    }
}
-(NSString*)formatTime:(float)time{
    int minutes = time / 60;
    int seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%@%d:%@%d", minutes / 10 ? [NSString stringWithFormat:@"%d", minutes / 10] : @"", minutes % 10, [NSString stringWithFormat:@"%d", seconds / 10], seconds % 10];
}

- (void) updateProgress: (NSTimer *) updateTimer
{
	NSLog(@"updateTimer->%@",updateTimer);
    if (audioPlayer.isPlaying)
    {
        btnPlayPause.selected = YES;
		[songProgress setValue:[audioPlayer currentTime] / [audioPlayer duration]];
		[playingTime setText:[NSString stringWithFormat:@"%@", [self formatTime:[audioPlayer currentTime]]]];
		//[playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
		//[songProgress setValue:(progress/duration) animated:YES];
    }
    else
    {
        btnPlayPause.selected = NO;
    }
    
    if (myPlayer.streamer.bitRate != 0.0)
    {
        double progress = myPlayer.streamer.progress;
        double duration = myPlayer.streamer.duration;
        int mm = (int) (progress / 60);
        int ss = (int) fmod(progress, 60);
    
        
        if (duration > 0)
        {
            [playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
            [songProgress setValue:(progress/duration) animated:YES];
        }
    }
}

@end
