//
//  mokletdevPlayerViewController.m
//  melon
//
//  Created by Arie on 3/23/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevPlayerViewController.h"
#import "MHRotaryKnob.h"
#import <QuartzCore/QuartzCore.h>
#import "MelonPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioToolbox/AudioToolbox.h"
#import "mokletdevAppDelegate.h"
#import "localplayer.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "DownloadList.h"
#import "YRDropdownView.h"
#import "songDownloader.h"
#import <social/Social.h>
#import <Twitter/Twitter.h>
#import "AFNetworking.h"
#include "GlobalDefine.h"

@interface mokletdevPlayerViewController ()

- (void) installPlayerNotificationObservers;
- (void) removePlayerNotificationObserver;

@end

@implementation UINavigationBar (custom)

- (void)drawRect:(CGRect)rect {};

@end

@implementation mokletdevPlayerViewController

@synthesize sSongTitle;
@synthesize sSongId;
@synthesize sArtistId;
@synthesize sArtistName;
@synthesize sAlbumId;
@synthesize sAlbumName;

@synthesize rotaryKnob;


@synthesize gTunggu = _gTunggu;

BOOL isTimerON = NO;
mokletdevAppDelegate * appDelegate;
int eProgress = 0;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title=@"Now Playing";
		self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"player-bawah"]];
        
        appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
		
    }
    return self;
}

- (void) doPlayPause
{
    if (![myPlayer isGettingNewSong])
    {
        if ([myPlayer isPlaying])
        {
            [myPlayer pause];
        }
        else
        {
            if (![myPlayer isPaused])
            {
                self.gTunggu.hidden = NO;
                [self.gTunggu setNeedsDisplay];
                
                [myPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
                [myPlayer playThisSong:appDelegate.eUserId andSongId:sSongId];
            }
            else
            {
                if ([myPlayer isIdle])
                {
                    [myPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
                    [myPlayer playThisSong:appDelegate.eUserId andSongId:sSongId];
                }
                else
                {
                   [myPlayer play]; 
                }
                
            }
        }
        
        if (!isTimerON)
        {
            [self createTimer];
            isTimerON = YES;
        }
    }
    else return;
}

- (void) doNext
{
    self.gTunggu.hidden = NO;
    [self.gTunggu setNeedsDisplay];
    
    [self performSelector:@selector(getNextSong) withObject:nil afterDelay:0];
    NSLog(@"Touch Next button.");
}

- (void) getNextSong
{
    if (![myPlayer isGettingNewSong])
    {

        if (isTimerON)
        {
            isTimerON = NO;
            [progressUpdateTimer invalidate];
            checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(checkPlay)
                                                        userInfo:nil
                                                         repeats:YES];
        }

        [myPlayer doNext];

    }
    else return;
}

- (void) doNext: (NSNotification *)notification
{
    [self performSelector:@selector(getNextSong) withObject:nil afterDelay:0];
    NSLog(@"Auto Next button.");
    
    self.gTunggu.hidden = NO;
    [self.gTunggu setNeedsDisplay];
}

- (void) lihatkanTunggu: (NSNotification *) notification
{
    self.gTunggu.hidden = NO;
    [self.gTunggu setNeedsDisplay];
}

- (void) doPrev
{
    self.gTunggu.hidden = NO;
    [self.gTunggu setNeedsDisplay];
    
    [self performSelector:@selector(getPrevSong) withObject:nil afterDelay:0];
    NSLog(@"Touch Prev button.");
}

- (void) getPrevSong
{
    if (![myPlayer isGettingNewSong])
    {
        //dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myPlayer doPrev];
        //});
    }
    else return;
}

- (void) doDownload
{
	if ([[myPlayer checkLocalSong:self.sSongId forUserId:appDelegate.eUserId] isEqualToString:@""])
    {
	//if([self.status isEqualToString:@"1"]){
		NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
		
	
		
		NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
		
		if([users_active count]>0){
			EUserBrief *usersss=[users_active objectAtIndex:0];
			
			LocalPlaylist *musicFound = [LocalPlaylist MR_findFirstByAttribute:@"songId" withValue:[NSString stringWithFormat:@"%@-%@",usersss.userId,self.sSongId]];
            NSLog(@"musicFound: %@", musicFound.songId);
			if (!musicFound){
				NSLog(@"musicFound---->%@",musicFound.songId);
				DownloadList *musicQ = [DownloadList MR_findFirstByAttribute:@"songId" withValue:self.sSongId];
				if (!musicQ){
					NSLog(@"songF---->%@",musicQ.songId);
					
					[YRDropdownView showDropdownInView:self.view
												 title:@"Informasi"
												detail:@"Musik Sedang Di tambahkan ke Antrian"
												 image:[UIImage imageNamed:@"dropdown-alert_success"]
									   backgroundImage:[UIImage imageNamed:@"allow"]
											  animated:YES
											 hideAfter:3];
					
					
					DownloadList *local = [DownloadList MR_createInContext:localContext];
					local.tanggal=[NSDate date];
					local.songId = self.sSongId;
					local.songTitle = self.sSongTitle;
					local.artistId = [NSString stringWithFormat:@"%@", self.sArtistId];
					local.artistName = self.sAlbumName;
					local.albumId = [NSString stringWithFormat:@"%@", self.sAlbumId];
					local.albumName = self.sAlbumName;
					local.downId = @"";
					local.userId = [NSString stringWithFormat:@"%@", usersss.userId];
					local.tanggal = [NSDate date];
					local.finished = [NSNumber numberWithInt:0];
					local.playTime = [NSString stringWithFormat:@"%@", self.playTime];
					local.status = [NSNumber numberWithInt:1];
					
					
					[localContext MR_save];
					
					
					[[songDownloader sharedInstance] doDownload:self.sSongId userid:usersss.userId password:usersss.webPassword email:usersss.email];
					
				}
				else{
					[YRDropdownView showDropdownInView:self.view
												 title:@"Galat"
												detail:@"Musik Sudah Di tambahkan ke Antrian"
												 image:[UIImage imageNamed:@"dropdown-alert_warning"]
									   backgroundImage:[UIImage imageNamed:@"warning"]
											  animated:YES
											 hideAfter:3];
				}
				
			}
			else{
				[YRDropdownView showDropdownInView:self.view
											 title:@"Galat"
											detail:@"Musik Sudah ada di Handset Anda"
											 image:[UIImage imageNamed:@"dropdown-alert_error"]
										  animated:YES
										 hideAfter:3];
			}
			
		}
		else{
			[YRDropdownView showDropdownInView:self.view
										 title:@"Galat"
										detail:@"Silahkan login terlebih dahulu untuk dapat mengambil lagu."
										 image:[UIImage imageNamed:@"dropdown-alert_error"]
									  animated:YES
									 hideAfter:3];
		}

	
	}
	else{
		[YRDropdownView showDropdownInView:self.view
									 title:@"Galat"
									detail:@"Musik Sudah ada di Handset Anda"
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
	}
	
	
}

- (void) repeatToggle
{
    
	NSLog(@"repeatToggle");
    if (REPEAT_NO == ( appDelegate.playOption & REPEAT_NO))
    {
        appDelegate.playOption ^= REPEAT_NO;
        appDelegate.playOption |= REPEAT_THIS;
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatone" ] forState:UIControlStateNormal];
    }
    
    else if (REPEAT_THIS == (appDelegate.playOption & REPEAT_THIS))
    {
        appDelegate.playOption ^= REPEAT_THIS;
        appDelegate.playOption |= REPEAT_ALL;
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatallonbtn" ] forState:UIControlStateNormal];
    }
    else if (REPEAT_ALL == (appDelegate.playOption & REPEAT_ALL))
    {
        appDelegate.playOption ^= REPEAT_ALL;
        appDelegate.playOption |= REPEAT_NO;
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatalloffbtn" ] forState:UIControlStateNormal];
    }
}

- (void) shuffleToggle
{
   NSLog(@"shuffleToggle");
    if (SHUFFLE_ON == (appDelegate.playOption & SHUFFLE_ON))
    {
        appDelegate.playOption ^= SHUFFLE_ON;
        [btnShuffle setImage:[UIImage imageNamed:@"playershuffleoffbtn" ] forState:UIControlStateNormal];
        [PlayerLib shufflePlaylist: 0];
        //btnShuffle.selected = NO;
    }
    else
    {
        appDelegate.playOption |= SHUFFLE_ON;
        [btnShuffle setImage:[UIImage imageNamed:@"playershuffleonbtn" ] forState:UIControlStateNormal];
        [PlayerLib shufflePlaylist: 1];
        //btnShuffle.selected = YES;
    }
}

- (void) lyricToggle
{
    NSLog(@"lyricToggle");
    if (LYRIC_ON == (appDelegate.playOption & LYRIC_ON))
    {
        appDelegate.playOption ^= LYRIC_ON;
        [btnLyric setImage:[UIImage imageNamed:@"playerlyricoffbtn" ] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.playOption |= LYRIC_ON;
        [btnLyric setImage:[UIImage imageNamed:@"playerlyriconbtn" ] forState:UIControlStateNormal];
    }
}

- (void) goBack
{
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
    
    [self removePlayerNotificationObserver];
    
    if (isTimerON)
    {
        @try {
            [progressUpdateTimer invalidate];
        }
        @catch (NSException *exception) {
            NSLog(@"error ketika [progressUpdateTimer invalidate].");
        }
        
        isTimerON = NO;
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) doSearch
{
	[actionSheet showInView:self.view];
	    //searchWindow=[[[mokletdevSearchMusicController alloc]init] autorelease];
	//UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchWindow];
    
    //[self presentModalViewController:navigationController animated:YES];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheets clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheets buttonTitleAtIndex:buttonIndex];
	if  ([buttonTitle isEqualToString:@"Facebook"]) {
		[self fbShareClicked];
		[actionSheets dismissWithClickedButtonIndex:0 animated:YES];
	}
	if ([buttonTitle isEqualToString:@"Twitter"]) {
		[self ttShareClicked];
		[actionSheets dismissWithClickedButtonIndex:0 animated:YES];
	}

}

-(void)rotaryKnobDidChange{
	
}

-(void)balik{
    [self.navigationController popViewControllerAnimated:YES];
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-lain"] forBarMetrics:UIBarMetricsDefault];
	
}
-(void)viewWillAppear:(BOOL)animated{
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	//change back button image
		
        
    backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
    UIBarButtonItem * backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
        
    searchButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"share_player"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"share_player"] forState:UIControlEventTouchDown];
    [searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * share = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    //UIBarButtonItem * searchButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
        
        
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationItem.rightBarButtonItem = share;
       
    
    //[self performSelector:@selector(checkPlay) withObject:nil afterDelay:1.0];
    //[self performSelector:@selector(checkProgress1) withObject:nil afterDelay:4.0];
    
    isTimerON = NO;
    
    checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(checkPlay)
                                                userInfo:nil
                                                 repeats:YES];

    
    if (REPEAT_NO == ( appDelegate.playOption & REPEAT_NO))
    {
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatalloffbtn" ] forState:UIControlStateNormal];
    }
    
    else if (REPEAT_THIS == (appDelegate.playOption & REPEAT_THIS))
    {
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatone" ] forState:UIControlStateNormal];
    }
    else if (REPEAT_ALL == (appDelegate.playOption & REPEAT_ALL))
    {
        [btnRepeat setImage:[UIImage imageNamed:@"playerrepeatallonbtn" ] forState:UIControlStateNormal];
    }
    
    if (SHUFFLE_ON == (appDelegate.playOption & SHUFFLE_ON))
    {
        [btnShuffle setImage:[UIImage imageNamed:@"playershuffleonbtn" ] forState:UIControlStateNormal];
    }
    else
    {
        [btnShuffle setImage:[UIImage imageNamed:@"playershuffleoffbtn" ] forState:UIControlStateNormal];
    }
}

- (void) checkPlay
{
    myPlayer = [MelonPlayer sharedInstance];
    if([myPlayer isPlaying]){
        btnPlayPause.selected = YES;
        if (!isTimerON)
        {
            //[self createTimer];
            [checkTimer invalidate];
            
            [self createTimer];

            self.gTunggu.hidden = YES;
        }
    }
    else{
        btnPlayPause.selected = NO;
    }
    //[self checkProgress1];
}

- (void) checkProgress1
{
//    if (!isTimerON)
//    {
//        checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                      target:self
//                                                    selector:@selector(checkProgress:)
//                                                    userInfo:nil
//                                                     repeats:YES];
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationController.navigationBar.hidden=NO;
	
	animated=YES;
	
}
-(void)viewDidLayoutSubviews{
	
	[self initLayout];
}
-(void)initLayout{

	 NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",self.sSongId];
	[albumImageView setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];

	[songTitle setText:self.sSongTitle];
	[songAlbumName setText:self.sAlbumName];
	[songArtistName setText:self.sArtistName];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSString *actionSheetTitle = @"Share To Social Media"; //Action Sheet Title

	NSString *other1 = @"Facebook";
	NSString *other2 = @"Twitter";
	NSString *cancelTitle = @"Batalkan";
	
	actionSheet = [[UIActionSheet alloc]
								  initWithTitle:actionSheetTitle
								  delegate:self
								  cancelButtonTitle:cancelTitle
								  destructiveButtonTitle:Nil
								  otherButtonTitles:other1, other2, nil];
	
	
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
    [playerControlArea addSubview:btnNext];
    
    btnPrev = [[[UIButton alloc] initWithFrame:CGRectMake(80.0, 157.0, 40.0, 40.0)] autorelease];
    [btnPrev setBackgroundImage:[UIImage imageNamed:@"playerprevbtn"] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(doPrev) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnPrev];
    
    CGFloat eLeft = 20.0;
    CGFloat eTop = 31.0;
    songTitle = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop, 212.0, 30.0)] autorelease];
    songTitle.textColor = [UIColor whiteColor];
    songTitle.backgroundColor = [UIColor clearColor];
    [songTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [playerControlArea addSubview:songTitle];
    
    playingTime = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft + 220.0 + 4.0, eTop+3, 80.0, 30.0)] autorelease];
    playingTime.text = @"00:00";
    playingTime.textColor = [UIColor whiteColor];
    playingTime.backgroundColor = [UIColor clearColor];
    [playingTime setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [playerControlArea addSubview:playingTime];
    
    
    eTop += 28.0;
    songArtistName = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop, 200.0, 14.0)] autorelease];
    songArtistName.textColor = [UIColor whiteColor];
    songArtistName.backgroundColor = [UIColor clearColor];
    [songArtistName setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [playerControlArea addSubview:songArtistName];
    
    eTop += 14.0;
    songAlbumName = [[[UILabel alloc] initWithFrame:CGRectMake(eLeft, eTop+5, 200.0, 14.0)] autorelease];
    songAlbumName.textColor = [UIColor whiteColor];
    songAlbumName.backgroundColor = [UIColor clearColor];
    [songAlbumName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [playerControlArea addSubview:songAlbumName];
    
    eTop += 28.0;
    btnRepeat = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 32.0, 32.0)] autorelease];
    [btnRepeat setBackgroundImage:[UIImage imageNamed:@"playerrepeatalloffbtn"] forState:UIControlStateNormal];
    [btnRepeat setBackgroundImage:[UIImage imageNamed:@"playerrepeatallonbtn"] forState:UIControlStateSelected];
    [btnRepeat addTarget:self action:@selector(repeatToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnRepeat];
    
    eLeft += 40;
    btnShuffle = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 32.0, 32.0)] autorelease];
    [btnShuffle setBackgroundImage:[UIImage imageNamed:@"playershuffleoffbtn"] forState:UIControlStateNormal];
    [btnShuffle setBackgroundImage:[UIImage imageNamed:@"playershuffleonbtn1"] forState:UIControlStateSelected];
    [btnShuffle addTarget:self action:@selector(shuffleToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnShuffle];
    
    eLeft += 40;
    btnLyric = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 32.0, 32.0)] autorelease];
    [btnLyric setBackgroundImage:[UIImage imageNamed:@"playerlyricoffbtn"] forState:UIControlStateNormal];
    [btnLyric setBackgroundImage:[UIImage imageNamed:@"playerlyriconbtn"] forState:UIControlStateSelected];
    [btnLyric addTarget:self action:@selector(lyricToggle) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnLyric];
    
    eLeft += 40;
    btnDownload = [[[UIButton alloc] initWithFrame:CGRectMake(eLeft, eTop, 32.0, 32.0)] autorelease];
    [btnDownload setBackgroundImage:[UIImage imageNamed:@"playerdownloadbtn"] forState:UIControlStateNormal];
    [btnDownload setBackgroundImage:[UIImage imageNamed:@"playerdownloadhlbtn"] forState:UIControlStateSelected];
    [btnDownload addTarget:self action:@selector(doDownload) forControlEvents:UIControlEventTouchUpInside];
    [playerControlArea addSubview:btnDownload];
    
   
    
    knobContainer = [[[UIView alloc] initWithFrame:CGRectMake(playerControlArea.bounds.size.width - 90.0, eTop -34.0, 70.0, 70.0)] autorelease];
    knobContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    knobContainer.layer.shadowOffset = CGSizeZero;
    knobContainer.layer.shadowRadius = 9.0;
    knobContainer.layer.shadowOpacity = 1.0;
    knobContainer.backgroundColor = [UIColor clearColor];
    [playerControlArea addSubview:knobContainer];
    
    
    
    knob = [[[DCKnob alloc] initWithDelegate:self] autorelease];
    CGFloat initialKnobSize = 70.0;
    knob.frame = CGRectMake(floorf((knobContainer.frame.size.width - initialKnobSize) / 2),
                            floorf((knobContainer.frame.size.height - initialKnobSize) / 2),
                            initialKnobSize,
                            initialKnobSize);
    knob.labelFont = [UIFont boldSystemFontOfSize:1.0];
    knob.color = [UIColor colorWithRed:0.0 green:80.0 blue:0.0 alpha:0.50];
    knob.backgroundColor = knobContainer.backgroundColor;
    knob.min = 0.0;
	knob.value=1.0;
    knob.max = 3.0;
    knob.doubleTapValue = 0.50;
    knob.tripleTapValue = 1.0;
 
   // knob.value = [[MPMusicPlayerController applicationMusicPlayer] volume];
	knob.value=1.0;
    knob.displaysValue = NO;
    knob.valueArcWidth = 1.50;
    [knobContainer addSubview:knob];
    
    volumeView = [[[MPVolumeView alloc] initWithFrame:knobContainer.bounds] autorelease];
    volumeView.hidden = YES;
    [knobContainer addSubview:volumeView];
    
    UIView * albumArtContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, -44.0, eWidth, eHeight - playerControlArea.bounds.size.height-20)] autorelease];
	/*
    albumArtContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    albumArtContainer.layer.shadowOffset = CGSizeZero;
    albumArtContainer.layer.shadowRadius = 9.0;
    albumArtContainer.layer.shadowOpacity = 1.0;
	 */
    albumArtContainer.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:albumArtContainer aboveSubview:playerControlArea];
    
    UIImageView * latarAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, albumArtContainer.bounds.size.width, albumArtContainer.bounds.size.height + 22)];
    [latarAlbum setImage:[UIImage imageNamed:@"player-bawah"]];
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
	songProgress = [[[UISlider alloc] initWithFrame:CGRectMake(50.0, 2, 230.0, 22)] autorelease];
    
    //[songProgress setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlStateNormal];
    //[songProgress setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlEventTouchUpInside];
    [songProgress setMinimumTrackImage: [UIImage imageNamed:@"playerprogressprogress"] forState: UIControlStateNormal];
    [songProgress setMaximumTrackImage: [UIImage imageNamed:@"playerprogressbg"] forState: UIControlStateNormal];
    songProgress.minimumValue=0;
    songProgress.value=0;
    [playerControlArea addSubview:songProgress];
    
    self.gTunggu = [[[UIImageView alloc] initWithFrame:CGRectMake((eWidth - 160.0)/2, (eHeight - 212)/2, 160.0, 106)] autorelease];
    [self.gTunggu setImage:[UIImage imageNamed:@"st"]];
    [self.view addSubview:self.gTunggu];
    self.gTunggu.hidden = NO;
    
    [self installPlayerNotificationObservers];
}

-(void)ttShareClicked{
		NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",self.sAlbumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *twitContent=[NSString stringWithFormat:@"#MelOnPlaying %@ by %@ %@ via MelOn for IOS", self.sSongTitle, self.sArtistName,shorturl];
	//Check if our weak library (Twitter.framework) is available
    Class TWTweetClass = NSClassFromString(@"TWTweetComposeViewController");
    if (TWTweetClass != nil)
    {
        //Create the tweet sheet
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        
        //Set initial text (optional)
        [tweetSheet setInitialText:twitContent];
        
        //Attach an image (optional)
		// [tweetSheet addImage:[UIImage imageNamed:@"anImage.png"]];
        
        //Add a link (optional)
		// [tweetSheet addURL:[NSURL URLWithString:@"http://www.pixelchild.com.au/"]];
        
        //Set our completion handler with a block
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
        //Present the tweet sheet
        [self presentModalViewController:tweetSheet animated:YES];
        
        //Release unless your one of the cool kids using ARC :)
        [tweetSheet release];
        
    }
    else
    {
        //TODO: Add a twitter composer fallback
    }
}

-(void)fbShareClicked{
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",self.sAlbumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *facebooContent=[NSString stringWithFormat:@"is listening to %@ by %@ %@ via MelOn for IOS", self.sSongTitle, self.sAlbumName,shorturl];
	//Check if our weak library (Twitter.framework) is available
	
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
				
                NSLog(@"Cancelled");
				
            } else
				
            {
                NSLog(@"Done");
            }
			
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
		
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:facebooContent];
		NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",self.sSongId];
		
		NSURL *url_image = [NSURL URLWithString:baseUrls];
		NSData *data = [NSData dataWithContentsOfURL:url_image];
		UIImage *images = [UIImage imageWithData:data];
        [controller addImage:images];
		
        [self presentViewController:controller animated:YES completion:Nil];
		
    }
    else{
        NSLog(@"UnAvailable");
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controlValueDidChange:(float)value sender:(id)sender
{
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:value];
    if(myPlayer){
		[myPlayer.streamer setVolume:value];
	}
	if(localPlayer){
		NSLog(@"value-->%f",value);
		//[localPlayer setvo]
		[localPlayer setVolume:value];
	}
    //AudioQueue audioQueue;
    //AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 0.5);
    
}

- (void) createTimer
{
    if (myPlayer)
    {
		//[progressUpdateTimer invalidate];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateProgress:)
                                                             userInfo:nil
                                                              repeats:YES];
        isTimerON = YES;
    }
}
- (void) createTimerLocal
{
    if (localPlayer)
    {
		[progressUpdateTimer invalidate];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateProgressLocal:)
                                                             userInfo:nil
                                                              repeats:YES];
        
    }
}

- (void) updateProgressLocal: (NSTimer *) updateTimer
{
	if (localPlayer.isPlaying)
	{
		btnPlayPause.selected = YES;
		[songProgress setValue:[localPlayer timeInterval] / [localPlayer duration]];
		
		//[//playingTime setText:[NSString stringWithFormat:@"%@", [self formatTime:[localPlayer timeInterval]]]];
		//[playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
		//[songProgress setValue:(progress/duration) animated:YES];
	}
	else
	{
		btnPlayPause.selected = NO;
	}
	
	double progress = [localPlayer timeInterval];
	double duration = [localPlayer duration];
	int mm = (int) (progress / 60);
	int ss = (int) fmod(progress, 60);
	
	
	if (duration > 0)
	{
		[playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
		[songProgress setValue:(progress/duration) animated:YES];
	}
	
}

- (void) updateProgress: (NSTimer *) updateTimer
{
    if (myPlayer.isPlaying)
    {
        btnPlayPause.selected = YES;
    }
    else
    {
        btnPlayPause.selected = NO;
    }
    
    double progress = [myPlayer getSongPlayProgress];
    double duration = [myPlayer getSongDuration];
    int mm = (int) (progress /60);
    int ss = (int) fmod(progress,  60);
    if (duration > 0)
    {
        [playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
        [songProgress setValue:(progress/duration) animated: YES];
        
        int np = (int) (progress * 100/duration);
        eProgress  =  np > eProgress ? np : eProgress;
        
        if (![self.gTunggu isHidden])
        {
            self.gTunggu.hidden = YES;
            [self.gTunggu setNeedsDisplay];
        }
    }
    
    //NSLog(@"eProgress: %d.", eProgress);
//    if (myPlayer.isPlaying)
//    {
//        btnPlayPause.selected = YES;
//    }
//    else
//    {
//        btnPlayPause.selected = NO;
//    }
//    
//    if (myPlayer.streamer.bitRate != 0.0)
//    {
//        double progress = myPlayer.streamer.progress;
//        double duration = myPlayer.streamer.duration;
//        int mm = (int) (progress / 60);
//        int ss = (int) fmod(progress, 60);
//        
//        
//        if (duration > 0)
//        {
//            [playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
//            [songProgress setValue:(progress/duration) animated:YES];
//        }
//    }
}

- (void) checkProgress: (NSTimer *) myTimer
{
    if (myPlayer)
    {
        if (!isTimerON && [myPlayer isPlaying])
        {
            @try {
                NSLog(@"progressUpdateTimer is now on.");
                progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                       target:self
                                                                     selector:@selector(updateProgress:)
                                                                     userInfo:nil
                                                                      repeats:YES];
                isTimerON = YES;
                @try {
                    [checkTimer invalidate];
                }
                @catch (NSException *exception) {
                    NSLog(@"error here at checkTimer");
                }
            
            }
            @catch (NSException *exception) {
                NSLog(@"error here at checkTimer");
            }
        }
    }
}

- (void) fullstopping:(NSNotification *)notification
{
    btnPlayPause.selected = NO;
    self.gTunggu.hidden = YES;
    [self.gTunggu setNeedsDisplay];
}

- (void) playing:(NSNotification *)notification
{
    btnPlayPause.selected = YES;
}

- (void) playingNewSong:(NSNotification *)notification
{
    btnPlayPause.selected = YES;
    
    LocalPlaylist1 * song = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
    
    sSongId     = song.songId;
    sSongTitle  = song.songTitle;
    sAlbumName  = song.albumName;
    sArtistName = song.artistName;
    
    [songAlbumName setText:sAlbumName];
    [songArtistName setText:sArtistName];
    [songTitle setText:sSongTitle];
    [albumImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",song.songId]]]]];
    
    [self performSelector:@selector(checkProgress1) withObject:nil afterDelay:1.0];
    
    if (!isTimerON)
        [self createTimer];
    
    self.gTunggu.hidden = YES;
}

- (void) pausing:(NSNotification *)notification
{
    btnPlayPause.selected = NO;
}

- (void) stopping:(NSNotification *)notification
{
    btnPlayPause.selected = NO;
}

- (void) idling:(NSNotification *)notification
{
    btnPlayPause.selected = NO;
    [playingTime setText:@"00:00"];
    [songProgress setValue:0.0];
    
    if (isTimerON)
    {
        [progressUpdateTimer invalidate];
        isTimerON = NO;
        
//        if (eProgress > 90 && ![myPlayer isGettingNewSong])
//        {
//            [self performSelector:@selector(doNext)];
//            eProgress = 0;
//        }
    }
}

- (void) waiting:(NSNotification *)notification
{
    btnPlayPause.selected = NO;
}

- (void) installPlayerNotificationObservers
{
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fullstopping:)
                                                 name:[NSString stringWithUTF8String:kNotifFullStop]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playing:)
                                                 name:[NSString stringWithUTF8String:kNotifPlay]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausing:)
                                                 name:[NSString stringWithUTF8String:kNotifPause]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopping:)
                                                 name:[NSString stringWithUTF8String:kNotifStop]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(idling:)
                                                 name:[NSString stringWithUTF8String:kNotifIdle]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(waiting:)
                                                 name:[NSString stringWithUTF8String:kNotifWaiting]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playingNewSong:)
                                                 name:@"PlayNewSong"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doNext)
                                                 name:@"ErrorAndGoNext"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doErrStop)
                                                 name:@"ErrorAndStop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lihatkanTunggu:)
                                                 name:@"toNextSong"
                                               object:nil];
}

- (void) removePlayerNotificationObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifFullStop]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifPlay]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifPause]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifStop]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifIdle]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:[NSString stringWithUTF8String:kNotifWaiting]
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"PlayNewSong"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"ErrorAndGoNext"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"ErrorAndStop"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"toNextSong"
                                                 object:nil];
}

- (void) dealloc
{
    [self removePlayerNotificationObserver];
    
    [self release];
    [super dealloc];
}

@end
