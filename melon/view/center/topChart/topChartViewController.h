//
//  topChartViewController.h
//  melon
//
//  Created by Arie on 3/30/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "mokletdevPlayerViewController.h"
#import "mokletdevSearchMusicController.h"
#import "TJSpinner.h"
#import "ActionSheetPicker.h"
@class MelonPlayer;
@class StreamingBrief;
@class AbstractActionSheetPicker;
@interface topChartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	UIButton* searchbutton ;
	TJSpinner *spinnerss;
	NSInteger currIndex;
    NSInteger lastIndex;
	UITableView * tableChart;
	MelonPlayer * MPlayer;
    mokletdevPlayerViewController *players;
	mokletdevSearchMusicController *searchWindow;
	
	UIView *top_label;
	UILabel *singerName;
	UILabel *TitleBig;
	UILabel *songNamess;
    
    NSString * currentSongId;
    
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
    UIView          * slowConnectionView;
}

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property(nonatomic,retain) NSMutableArray *netraMutableArray;
@property(nonatomic,strong) NSIndexPath *currentIndex;
@property(nonatomic,retain) NSMutableArray  * netraMutableArrayPlaylist;
@property (nonatomic) CGFloat expandedCellHeight;
@property (nonatomic, strong) UIImageView   * gTunggu;


@end
