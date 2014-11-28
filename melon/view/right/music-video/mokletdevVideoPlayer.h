//
//  mokletdevViewController.h
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "mokletdevPlayerViewController.h"
#import "mokletdevSearchMusicController.h"
#import <MessageUI/MessageUI.h>
#import "MelonVideoPlayerViewController.h"
#import "TJSpinner.h"
#import "GAITrackedViewController.h"
@class MelonPlayer;
@class StreamingBrief;

@interface mokletdevVideoPlayer : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
	UITableView *MelonListVideo;
	
	NSInteger current_page;
	NSInteger currIndex;
    NSInteger lastIndex;
	NSInteger total_page;
	TJSpinner *spinner;
	UIView *searchView;
	MelonVideoPlayerViewController *players;
    
	UIButton* searchbutton ;
	MelonPlayer * MPlayer;
	mokletdevSearchMusicController *searchWindow;
	
	UIView *top_label;
	UILabel *singerName;
	UILabel *TitleBig;
	UILabel *songNamess;
	
	StreamingBrief * streamingMetadata;
    
    NSString * currentSongId;
    
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
    UIView          * slowConnectionView;
}
@property(nonatomic,retain) NSMutableArray  * myVideoList;
@property(nonatomic,strong) UIImageView     * titleImage;


@end
