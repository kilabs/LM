//
//  mokletdevAppDelegate.h
//  melon
//
//  Created by Arie on 2/27/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

/*
 
 need cleanup this shit! fuck it blow my mind!
 */

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "mokletdevViewController.h"
#import "mokletdevLeftViewController.h"
#import "mokletdevRightViewController.h"
#import "mokletdevLoginViewController.h"
#import "mokletdevGuideViewController.h"

#import "mokletdevPlayList.h"
#import "mokletdevHistoryController.h"
#import "mokletdevAllSong.h"
#import "downloadQueueViewController.h"
#import "mokletdevServiceController.h"

///right menu
#import "topChartViewController.h"
#import "mokletdevVideoPlayer.h"
#import "CMNavBarNotificationView.h"
#import "intro.h"

#import <FacebookSDK/FacebookSDK.h>
#import "Layanan.h"
#import "mokletdevPlayerViewController.h"
//#import "UserBrief.h"

//@class UserBrief;
@class songListObject;
@class songDownloader;
@class MelonPlayer;
@class Reachability;
@interface mokletdevAppDelegate : UIResponder <UIApplicationDelegate,CMNavBarNotificationViewDelegate>
{
//    UserBrief       * user;
    long long         dlProgress;
    float             dlPercentage;
    songListObject  * song;
    Reachability *internetReach;
    NSTimer         * timerDownloadQueue;
    
    float             ekaDlProgress;
    
    songDownloader  * ekaSongDownloader;
	MelonPlayer * MPlayer;
    int               currentDownloadListItemRow;
    
    BOOL              isLoggedIn;
    
    Layanan         * eLayanan;
}
@property (strong, nonatomic) NSString *lastController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *mainViewController;
@property (strong, nonatomic) mokletdevViewController *viewController;
@property (strong, nonatomic) mokletdevLoginViewController *loginViewController;
@property (strong, nonatomic) mokletdevLeftViewController *leftView;
@property (strong, nonatomic) mokletdevRightViewController *rightView;
@property (strong, nonatomic) intro *guidePage;
@property (strong, nonatomic) mokletdevPlayerViewController *pl;


//@property (nonatomic, retain) UserBrief         * user;
@property (nonatomic, strong) songListObject    * song;
@property (nonatomic, strong) songDownloader    * ekaSongDownloader;
@property (strong, nonatomic) FBSession         * session;
@property (nonatomic, retain) NSMutableArray    * curDownloadList;
@property (nonatomic, strong) NSArray           * downloadList;
@property (nonatomic, retain) Layanan           * eLayanan;

@property (nonatomic, strong, readwrite) NSString                       * eUserId;
@property (nonatomic, strong, readwrite) NSString                       * ePassword;
@property (nonatomic, strong, readwrite) NSString                       * eWebPassword;
@property (nonatomic, strong, readwrite) NSString                       * eUserName;

@property (readwrite, strong) NSMutableArray    * nowPlayingPlayOrder;
@property (readwrite, strong) NSMutableArray    * nowPlayingPlaylistDefault;
@property (readwrite) NSInteger                 nowPlayingPlayOrderIndex;
@property (readwrite) NSInteger                 nowPlayingSongIndex;

@property (readwrite) NSInteger                 playOption;

@property (nonatomic) BOOL                      isGetLayanan;

- (void) ambilLayanan: (NSString *) userId;

@end
