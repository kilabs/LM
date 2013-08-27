//
//  mokletdevHistoryController.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "mokletdevPlayerViewController.h"
#import "mokletdevSearchMusicController.h"
#import <MessageUI/MessageUI.h>
#import "TJSpinner.h"
@class MelonPlayer;
@class StreamingBrief;

@interface mokletdevHistoryController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{

	UITableView *downloadHistory;
	NSInteger current_page_;
	NSInteger currIndex_;
    NSInteger lastIndex_;
	NSInteger total_page_;
	TJSpinner *spinner;
	UIView *searchView_;
	mokletdevPlayerViewController *players_;
	UIButton* searchbutton_ ;
	MelonPlayer * MPlayer;
	mokletdevSearchMusicController *searchWindow_;
	
	UIView *top_label_;
	UILabel *singerName_;
	UILabel *TitleBig_;
	UILabel *songNamess_;
	
	StreamingBrief * streamingMetadata_;
    
    NSString * currentSongId_;
	UIView *empty;
	UILabel *empty_title;
	UILabel *empty_text;
    
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
    UIView          * slowConnectionView;

}
@property(nonatomic,retain) NSMutableArray  * netraMutableArray_;
@property(nonatomic,retain) NSMutableArray  * netraMutableArrayResult_;
@property(nonatomic,strong) UIImageView     * titleImage_;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) UIImageView   * gTunggu;

@end
