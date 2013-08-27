//
//  MelonVideoPlayerViewController.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/2/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "MelonVideoPlayerViewController.h"


@interface MelonVideoPlayerViewController ()

- (void) installMovieNotificationObservers;
- (void) removeMovieNotificationHandlers;


@end

@implementation MelonVideoPlayerViewController

@synthesize lblTitle, lblAlbum, lblArtist;

@synthesize videoTitle  = _videoTitle;
@synthesize videoArtist = _videoArtist;
@synthesize videoAlbum  = _videoAlbum;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
	//change back button image
    if(self.navigationController.viewControllers.count > 1) {
        
        backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
        
        //UIBarButtonItem * searchButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
        
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"]  forBarMetrics:UIBarMetricsDefault];
        
    }
    
    CGFloat eWidth = CGRectGetWidth(self.view.bounds);
    CGFloat eHeight = CGRectGetHeight(self.view.bounds);
    
    UIView * baseView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, eWidth, eHeight)] autorelease];
    baseView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1];
    [self.view addSubview:baseView];
    
    UIView * videoView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 40.0, eWidth - 20.0, 0.75 * eWidth)] autorelease];
    videoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:videoView];
    
    CGFloat y = 40;
    y = y + 0.75 * eWidth + 10 ;
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, y, eWidth - 20.0, 34.0)];
    lblTitle.text = self.videoTitle;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [lblTitle setFont:[UIFont fontWithName:@"OpenSans" size:28]];
    [self.view addSubview:lblTitle];
    
    y += 30;
    lblAlbum = [[UILabel alloc] initWithFrame:CGRectMake(10.0, y, eWidth - 20.0, 20.0)];
    lblAlbum.text = self.videoAlbum;
    lblAlbum.textColor = [UIColor whiteColor];
    lblAlbum.backgroundColor = [UIColor clearColor];
    lblAlbum.textAlignment = NSTextAlignmentCenter;
    [lblAlbum setFont:[UIFont fontWithName:@"OpenSans" size:16]];
    [self.view addSubview:lblAlbum];
    
    y += 22;
    lblArtist = [[UILabel alloc] initWithFrame:CGRectMake(10.0, y, eWidth - 20.0, 20.0)];
    lblArtist.text = self.videoArtist;
    lblArtist.textColor = [UIColor whiteColor];
    lblArtist.backgroundColor = [UIColor clearColor];
    lblArtist.textAlignment = NSTextAlignmentCenter;
    [lblArtist setFont:[UIFont fontWithName:@"OpenSans" size:16]];
    [self.view addSubview:lblArtist];
    
    eVideoPlayer = [[MPMoviePlayerController alloc] init];
    eVideoPlayer.view.frame = [videoView frame];
    [eVideoPlayer setFullscreen:YES];
    [self.view addSubview:eVideoPlayer.view];
    
    //sUrl = @"http://www.melon.co.id/progstream.mp4?vodId=105";
    //sUrl = @"http://liga465.com/siraz/partial.php?file=110121018_320k.mp4&stream=true";
    //sUrl = @"http://liga465.com/siraz/streamer.php";
    NSLog(@"Video URL: %@.", sUrl);
    NSURL * eURL = [NSURL URLWithString:sUrl] ;
    if ([eURL scheme])
    {
        MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
        
        [self configureVideoPlayer];
        [eVideoPlayer setControlStyle:MPMovieControlStyleDefault];
        [eVideoPlayer setMovieSourceType:movieSourceType];
        [eVideoPlayer setContentURL:eURL];
        [eVideoPlayer prepareToPlay];
        [eVideoPlayer play];
        NSLog(@"Play command telah dipanggil.");
    }
   
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    UIApplication * application = [UIApplication sharedApplication];
    //    if (application.statusBarOrientation != UIInterfaceOrientationLandscapeLeft)
    //    {
    //        UIViewController * vc = [[UIViewController alloc] init];
    //        [self presentModalViewController:vc animated:NO];
    //        [self dismissModalViewControllerAnimated:NO];
    //        [vc release];
    //    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self removeMovieNotificationHandlers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack
{
    [eVideoPlayer stop];
    [eVideoPlayer release];
    
    [self.navigationController popViewControllerAnimated:YES];
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"] forBarMetrics:UIBarMetricsDefault];
}

- (void) setVideoUrl: (NSString *) sURL
{
    sUrl = sURL;
}

- (void) configureVideoPlayer
{
    [self installMovieNotificationObservers];
}

-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = eVideoPlayer;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = eVideoPlayer;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback %@", [notification description]);
            //[self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
            //                    waitUntilDone:NO];
            
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
            
			break;
            
		default:
			break;
	}
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        //[self.overlayController setLoadStateDisplayString:@"n/a"];
        
        //[overlayController setLoadStateDisplayString:@"unknown"];
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        //[overlayController setLoadStateDisplayString:@"playable"];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        // Add an overlay view on top of the movie view
        //[self addOverlayView];
        
        //[overlayController setLoadStateDisplayString:@"playthrough ok"];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        //[overlayController setLoadStateDisplayString:@"stalled"];
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        //[overlayController setPlaybackStateDisplayString:@"stopped"];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        //[overlayController setPlaybackStateDisplayString:@"playing"];
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        //[overlayController setPlaybackStateDisplayString:@"paused"];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        //[overlayController setPlaybackStateDisplayString:@"interrupted"];
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	// Add an overlay view on top of the movie view
    //[self addOverlayView];
}

//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//}
//
//- (BOOL) shouldAutorotate
//{
//    return  YES;
//}
//
//- (NSUInteger) supportedInterfaceOrientations
//{
//    NSInteger mask = UIInterfaceOrientationMaskLandscape;
//    return mask;
//}

@end

//@implementation UINavigationController (Rotation_IOS6)
//
//- (NSUInteger) supportedInterfaceOrientations
//{
//    //return [[self.viewControllers lastObject] supportedInterfaceOrientations];
//    return UIInterfaceOrientationLandscapeLeft;
//}
//
//- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
//{
//    return  [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}
//
//@end
