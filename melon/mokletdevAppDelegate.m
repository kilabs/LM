//
//  mokletdevAppDelegate.m
//  melon
//
//  Created by Arie on 2/27/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevAppDelegate.h"
#import "AFNetworking.h"
#include "GlobalDefine.h"

#import "mokletdevAllSong.h"
#include "songListObject.h"
#import "DownloadList.h"
#import "LocalPlaylist.h"
#import "EUserBrief.h"
#import "NSStrinAdditions.h"
#import "MelonPlayer.h"
#import "Config.h"
#import "Reachability.h"
#import "mokletdevSearchMusicController.h"
#import "PlayerConfig.h"
#import "mokletdevSearchMusicController.h"
#import "LocalPlaylist1.h"

/******* Google Analytics Tracking *******/
static NSString *const kGaPropertyId = @"UA-23163798-6";
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 120;

@interface mokletdevAppDelegate ()

- (void)initializeGoogleAnalytics;

@end


@implementation mokletdevAppDelegate

@synthesize session = _session;
//@synthesize user = _user;
@synthesize song = _song;
@synthesize ekaSongDownloader = _ekaSongDownloader;
@synthesize curDownloadList = _curDownloadList;
@synthesize downloadList = _downloadList;
@synthesize eUserId         = _eUserId;
@synthesize ePassword       = _ePassword;
@synthesize eWebPassword    = _eWebPassword;
@synthesize eUserName       = _eUserName;

@synthesize nowPlayingPlayOrder         = _nowPlayingPlayOrder;
@synthesize nowPlayingPlaylistDefault   = _nowPlayingPlaylistDefault;
@synthesize nowPlayingPlayOrderIndex    = _nowPlayingPlayOrderIndex;
@synthesize nowPlayingSongIndex         = _nowPlayingSongIndex;
@synthesize playOption                  = _playOption;
@synthesize eLayanan                    = _eLayanan;
@synthesize isGetLayanan                = _isGetLayanan;

NSString * tempUserName;
NSString * tempWebPassword;

- (void)dealloc
{
	[_window release];
	[_viewController release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
	NSLog(@"123");
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application didFinishLaunchingWithOptions");
    
	self.pl=[[mokletdevPlayerViewController alloc]init];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCenter:)
												name:@"dealNotification"
											  object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notif:)
												name:@"downloadDone"
											  object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadWindow)
												name:@"dismiss"
											  object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigPlayer)
												name:@"bigPlayer"
											  object:nil];
	/*
	   [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	*/
	
    //[MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"MyDatabase.sqlite"]; //auto migration db version
    
    self.nowPlayingPlayOrder = [[[NSMutableArray alloc] init] autorelease];
    self.nowPlayingPlaylistDefault = [[[NSMutableArray alloc] init] autorelease];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray * playerConfiguration = [PlayerConfig MR_findAll];
    if ([playerConfiguration count] > 0)
    {
        PlayerConfig * playerConfig = [playerConfiguration objectAtIndex:0];
        self.playOption = playerConfig.playOption.integerValue;
        NSLog(@"PlayOption: %d, autoLogin: %d, firstUse: %d", self.playOption, playerConfig.autoLogin.integerValue, playerConfig.firstUse.integerValue);
        
        if (playerConfig.firstUse == [NSNumber numberWithInt:1])
        {
            [self loadIntro];
        }
        else
        {
            [self loadWindow];
        }
        
        // auto login -- pasti autologin
        BOOL autologin = playerConfig.autoLogin.intValue;
        if (autologin && playerConfig.lastUser.integerValue != 0)
        {
            
            NSMutableArray * users = [NSMutableArray arrayWithArray:[EUserBrief MR_findByAttribute:@"userId" withValue:playerConfig.lastUser]];
            if ([users count] > 0)
            {
                EUserBrief * lastUser = [users objectAtIndex:0];
                self.nowPlayingPlaylistDefault = [NSMutableArray arrayWithArray:[LocalPlaylist1 MR_findByAttribute:@"userId" withValue:lastUser.userId andOrderBy:@"tanggal" ascending:YES]];
                
                // Isikan daftar indeks untuk daftar now playing.
                if (SHUFFLE_ON == (self.playOption & SHUFFLE_ON))
                {
                    NSMutableArray * tempOrder = [[[NSMutableArray alloc] init] autorelease];
                    for (int i = 0; i < [self.nowPlayingPlaylistDefault count]; ++i)
                    {
                        [tempOrder addObject:i];
                    }
                    
                    while ([tempOrder count] > 0)
                    {
                        int idx = rand() % [tempOrder count];
                        [self.nowPlayingPlayOrder addObject:[tempOrder objectAtIndex:idx]];
                        [tempOrder removeObjectAtIndex:idx];
                    }
                }
                
                self.eUserId = lastUser.userId;
                self.ePassword = lastUser.ePassword;
                self.eWebPassword = lastUser.webPassword;
                self.eUserName = lastUser.username;
                // loginkan user.
                //[self tryToLoginAs:lastUser.username withPassword:lastUser.ePassword];
            }
        }
        // tak seharusnya di sini
        NSMutableArray * users = [NSMutableArray arrayWithArray:[EUserBrief MR_findAll]];
        if ([users count] > 0)
        {
            EUserBrief * lastUser = [users objectAtIndex:0];
            self.eUserId = lastUser.userId;
            self.ePassword = lastUser.ePassword;
            self.eWebPassword = lastUser.webPassword;
            self.eUserName = lastUser.username;
        }
        
        [self ambilLayanan:self.eUserId];
        // isi playlist
        self.nowPlayingPlaylistDefault = [NSMutableArray arrayWithArray:[LocalPlaylist1 MR_findAll]];
        if ([self.nowPlayingPlaylistDefault count] > 0)
        {
            // Isikan daftar indeks untuk daftar now playing.
            if (SHUFFLE_ON == (self.playOption & SHUFFLE_ON) && [self.nowPlayingPlaylistDefault count] > 1)
            {
                NSMutableArray * tempOrder = [[[NSMutableArray alloc] init] autorelease];
                for (int i = 0; i < [self.nowPlayingPlaylistDefault count]; ++i)
                {
                    NSNumber * urutan = [NSNumber numberWithInt:i];
                    [tempOrder addObject:urutan];
                }
                
                while ([tempOrder count] > 0)
                {
                    int idx = rand() % [tempOrder count];
                    [self.nowPlayingPlayOrder addObject:[tempOrder objectAtIndex:idx]];
                    [tempOrder removeObjectAtIndex:idx];
                }
            }
            else
            {
                for (int i = 0; i < [self.nowPlayingPlaylistDefault count]; ++i)
                {
                    NSNumber * urutan = [NSNumber numberWithInt:i];
                    [self.nowPlayingPlayOrder addObject:urutan];
                }
            }
        }
        
        self.nowPlayingPlayOrderIndex = 0;
        NSNumber * idx;
        if ([self.nowPlayingPlayOrder count] > 0)
        {
            idx = [self.nowPlayingPlayOrder objectAtIndex:self.nowPlayingPlayOrderIndex];
        }
        else
        {
            idx = [NSNumber numberWithInt:0];
        }
        self.nowPlayingSongIndex = idx.integerValue;
    }
    
    // create a new player configuration
    else
    {
        PlayerConfig * playerConfig = [PlayerConfig MR_createInContext:localContext];
        playerConfig.autoLogin  = [NSNumber numberWithInt:1];
        playerConfig.firstUse   = [NSNumber numberWithInt:1];
        playerConfig.lastUser   = [NSNumber numberWithInt:0];
        playerConfig.lastVolume = [NSNumber numberWithFloat:0.50];
        playerConfig.playOption = [NSNumber numberWithInt:4];
        [localContext MR_save];
        
        self.playOption = REPEAT_NO;
        
        [self loadIntro];
    }
    
//	if([EPassword isEqualToString:@"213"]){
//		[self loadIntro];
//	}
//	else{
//		[self loadWindow];
//	}
//	[MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    
    //google analytics
    [self initializeGoogleAnalytics];
    
    return YES;
	
}

- (void)initializeGoogleAnalytics {
    NSDictionary *appDefaults = @{kTrackingPreferenceKey: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kTrackingPreferenceKey];
    
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
    
}

-(void)searchWindowGlobal{
	/*mokletdevSearchMusicController *searchWindow=[[[mokletdevSearchMusicController alloc]init] autorelease];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchWindow];
	
	[self.mainViewController.centerPanel presentingViewController:navigationController];
	 */

}
-(void)loadIntro{
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.guidePage=[[intro alloc]init];
    self.window.rootViewController = self.guidePage;
	[self.viewController presentModalViewController:self.guidePage animated:YES];
    NSLog(@"intro show");
    [self.window makeKeyAndVisible];
}
-(void)loadWindow{
	[self.guidePage dismissModalViewControllerAnimated:YES];
	self.guidePage .modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.guidePage .view.alpha = 0.0;
	[UIView animateWithDuration:0.5
					 animations:^{self.guidePage.view.alpha  = 1.0;}];
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]
				   autorelease];
	self.mainViewController=[[JASidePanelController alloc]init];
	self.leftView=[[mokletdevLeftViewController alloc]init];
	self.rightView=[[mokletdevRightViewController alloc]init];
	[self setCenter:nil];
	self.mainViewController.rightPanel=self.rightView;
	self.mainViewController.leftPanel=self.leftView;
	self.window.rootViewController =self.mainViewController;
	MPlayer = [MelonPlayer sharedInstance];
	[self.window makeKeyAndVisible];

}
- (void)notif:(NSNotification *)notification
{
	NSMutableArray *dict = (NSMutableArray*)notification.object;
	NSString *theString=[dict objectAtIndex:0];
	[CMNavBarNotificationView setBackgroundImage:[UIImage imageNamed:@"notif"]];
	[CMNavBarNotificationView notifyWithText:@"Download Selesai:"
									  detail:theString
									   image:nil
								 andDuration:2.5];
	
	[dict removeAllObjects];
}
-(void)bigPlayer{
    NSLog(@"eka check before here.");
    
    //create new instance player and get current song (Totok)
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    LocalPlaylist1 * songItem = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
    
    self.pl = [[mokletdevPlayerViewController alloc]init];
    self.pl.sSongId     = songItem.songId;
    self.pl.sSongTitle  = songItem.songTitle;
	self.pl.sArtistId   = songItem.artistId;
    self.pl.sArtistName = songItem.artistName;
	self.pl.sAlbumId    = songItem.albumId;
    self.pl.sAlbumName  = songItem.albumName;
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.pl];

	//self.mainViewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(self.lastController) alloc] init]];
    NSLog(@"eka check here.");
	[self.mainViewController.centerPanel presentViewController:navigationController animated:YES completion:nil];
	[navigationController release];
	[self.pl release];
	//[se]
}
-(void)setCenter:(NSNotification *)notification{
	
	NSMutableArray *dict = (NSMutableArray*)notification.object;
	//NSLog([dict objectAtIndex:0]);
	//self.mainViewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[[dict objectAtIndex:0] alloc] init]];
	if(notification==nil){
		//	self.mainViewController.centerPanel =nil;
		self.mainViewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[mokletdevViewController alloc] init]];
		//[self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
		self.lastController=@"mokletdevViewController";
	}
	
	else if([[dict objectAtIndex:0] isEqualToString:self.lastController]){
		
	}
    
    else if([[dict objectAtIndex:0] isEqualToString:@"intro"]){
		[self loadIntro];
	}
    
	else{
		self.mainViewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString([dict objectAtIndex:0]) alloc] init]];
		self.lastController=[dict objectAtIndex:0];
	}
}



- (void)applicationWillResignActive:(UIApplication *)application
{
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    //google analytics
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kTrackingPreferenceKey];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[MagicalRecord cleanUp];
	  [self.session close];
}

- (void) ambilLayanan: (NSString *) userId
{
    if ([userId isKindOfClass:[NSNull class]])
    {
        return;
    }
    
    NSString * sURL = [NSString stringWithFormat:@"%@users/%@/onservice", [NSString stringWithUTF8String:MAPI_SERVER], userId];
    
    NSLog(@"sURL : %@.", sURL);
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.eUserName, @"_UNAME",
							  self.eWebPassword, @"_UPASS",
                              @"cu", @"_DIR",
                              [NSString stringWithUTF8String:CNAME], @"_CNAME",
                              [NSString stringWithUTF8String:CPASS], @"_CPASS",
                              nil] autorelease];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:sURL]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    
    AFJSONRequestOperation * operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"responseObject--->%@",responseObject);
        
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        @try {
        
            [Layanan MR_truncateAllInContext:localContext];
            [localContext MR_save];
        
            Layanan * layanan = [Layanan MR_createInContext:localContext];
            layanan.allowedReservationYN = @"";
            layanan.allowedWithdrawalCancelYN = @"";
            layanan.allowedWithdrawalReservationYN = @"";
            layanan.autoRetentionYN = @"";
            layanan.chargeDate = @"";
            layanan.gracePeriodDown = @"";
            layanan.gracePeriodPlay = @"";
            layanan.gracePeriodStream = @"";
            layanan.limitDown = @"";
            layanan.limitDownCnt = @"0";
        
            layanan.limitStream = @"";
            layanan.limitStreamCnt = @"0";
            layanan.mobileOnlyYN = @"";
            layanan.ownershipType = @"";
            layanan.payUserId = @"";
            layanan.payUserNickname = @"";
            layanan.paymentProdCateId = @"";
            layanan.paymentProdCateName = @"";
            layanan.paymentProdId = @"";
            layanan.paymentProdImg = @"";
        
            layanan.paymentProdName = @"";
            layanan.paymentWayId = @"";
            layanan.paymentWayName = @"";
            layanan.postReserveDate = @"";
            layanan.ppStatusCd = @"";
            layanan.reservedPaymentProdId = @"";
            layanan.reservedPaymentProdName = @"";
            layanan.supportDrmYN = @"";
            layanan.supportNonDrmYN = @"";
            layanan.supportStreamYN = @"";
        
            layanan.useEndDate = @"";
            layanan.useStartDate = @"";
            layanan.userPaymentProdId = @"";
        
        
            if ([[responseObject objectAtIndex:0] objectForKey:@"allowedReservationYN"] != (NSString *) [NSNull null])
            {
                layanan.allowedReservationYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"allowedReservationYN"] ];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"allowedWithdrawalCancelYN"] != (NSString *) [NSNull null])
            {
                layanan.allowedWithdrawalCancelYN = [NSString stringWithFormat:@"%@", [[responseObject  objectAtIndex:0] objectForKey:@"allowedWithdrawalCancelYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"allowedWithdrawalReservationYN"] != (NSString *) [NSNull null])
            {
                layanan.allowedWithdrawalReservationYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"allowedWithdrawalReservationYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"autoRetentionYN"] != (NSString *) [NSNull null])
            {
                layanan.autoRetentionYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"autoRetentionYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"chargeDate"] != (NSString *) [NSNull null])
            {
                layanan.chargeDate = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"chargeDate"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"gracePeriodDown"] != (NSString *) [NSNull null])
            {
                layanan.gracePeriodDown = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"gracePeriodDown"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"gracePeriodPlay"] != (NSString *) [NSNull null])
            {
                layanan.gracePeriodPlay = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"gracePeriodPlay"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"gracePeriodStream"] != (NSString *) [NSNull null])
            {
                layanan.gracePeriodStream = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"gracePeriodStream"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"limitDown"] != (NSString *) [NSNull null])
            {
                layanan.limitDown = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"limitDown"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"limitDownCnt"] != (NSString *) [NSNull null])
            {
                layanan.limitDownCnt = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"limitDownCnt"]];
            }
        
            if ([[responseObject objectAtIndex:0] objectForKey:@"limitStream"] != (NSString *) [NSNull null])
            {
                layanan.limitStream = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"limitStream"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"limitStreamCnt"] != (NSString *) [NSNull null])
            {
                layanan.limitStreamCnt = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"limitStreamCnt"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"mobileOnlyYN"] != (NSString *) [NSNull null])
            {
                layanan.mobileOnlyYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"mobileOnlyYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"ownershipType"] != (NSString *) [NSNull null])
            {
                layanan.ownershipType = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"ownershipType"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"payUserId"] != (NSString *) [NSNull null])
            {
                layanan.payUserId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"payUserId"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"payUserNickname"] != (NSString *) [NSNull null])
            {
                layanan.payUserNickname = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"payUserNickname"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentProdCateId"] != (NSString *) [NSNull null])
            {
                layanan.paymentProdCateId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentProdCateId"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentProdCateName"] != (NSString *) [NSNull null])
            {
                layanan.paymentProdCateName = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentProdCateName"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentProdId"] != (NSString *) [NSNull null])
            {
                layanan.paymentProdId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentProdId"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentProdImg"] != (NSString *) [NSNull null])
            {
                layanan.paymentProdImg = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentProdImg"]];
            }
        
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentProdName"] != (NSString *) [NSNull null])
            {
                layanan.paymentProdName = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentProdName"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentWayId"] != (NSString *) [NSNull null])
            {
                layanan.paymentWayId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentWayId"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"paymentWayName"] != (NSString *) [NSNull null])
            {
                layanan.paymentWayName = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"paymentWayName"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"postReserveDate"] != (NSString *) [NSNull null])
            {
                layanan.postReserveDate = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"postReserveDate"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"ppStatusCd"] != (NSString *) [NSNull null])
            {
                layanan.ppStatusCd = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"ppStatusCd"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"reservedPaymentProdId"] != (NSString *) [NSNull null])
            {
                layanan.reservedPaymentProdId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"reservedPaymentProdId"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"reservedPaymentProdName"] != (NSString *) [NSNull null])
            {
                layanan.reservedPaymentProdName = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"reservedPaymentProdName"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"supportDrmYN"] != (NSString *) [NSNull null])
            {
                layanan.supportDrmYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"supportDrmYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"supportNonDrmYN"] != (NSString *) [NSNull null])
            {
                layanan.supportNonDrmYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"supportNonDrmYN"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"supportStreamYN"] != (NSString *) [NSNull null])
            {
                layanan.supportStreamYN = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"supportStreamYN"]];
            }
        
            if ([[responseObject objectAtIndex:0] objectForKey:@"useEndDate"] != (NSString *) [NSNull null])
            {
                layanan.useEndDate = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0]    objectForKey:@"useEndDate"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"useStartDate"] != (NSString *) [NSNull null])
            {
                layanan.useStartDate = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0] objectForKey:@"useStartDate"]];
            }
            if ([[responseObject objectAtIndex:0] objectForKey:@"userPaymentProdId"] != (NSString *) [NSNull null])
            {
                layanan.userPaymentProdId = [NSString stringWithFormat:@"%@", [[responseObject objectAtIndex:0]     objectForKey:@"userPaymentProdId"]];
            }
        
        
            [localContext MR_save];
        }
        @catch (NSException *exception) {
            NSLog(@"Galat ketika mengambil data layanan.");
        }
        
        
        @try {
            //self.eLayanan = [[Layanan alloc] init];
            NSMutableArray * lyn = [NSMutableArray arrayWithArray:[Layanan MR_findAll]];
            if ([lyn count] > 0)
            {
                self.eLayanan = (Layanan *) [lyn objectAtIndex:0];      // ekachan 20130625
                self.isGetLayanan = TRUE;
            }
            else
            {
                self.isGetLayanan = FALSE;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"layanan gagal diambil dari database.");
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error while request : %@.", [error description]);
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}


@end
