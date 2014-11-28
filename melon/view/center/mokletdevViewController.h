//
//  mokletdevViewController.h
//  melon
//
//   by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "mokletdevPlayerViewController.h"
#import "mokletdevSearchMusicController.h"
#import <MessageUI/MessageUI.h>
#import "CMNavBarNotificationView.h"
#import "TJSpinner.h"
#import "ActionSheetPicker.h"
#import "PlayerLib.h"
#import "GAITrackedViewController.h"

@class AbstractActionSheetPicker;
@class MelonPlayer;
@class StreamingBrief;

@interface mokletdevViewController : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CMNavBarNotificationViewDelegate,UIGestureRecognizerDelegate>
{
	UITableView *MelonList;
	UIView *noConnection;
	NSInteger current_page;
	NSInteger currIndex;
    NSInteger lastIndex;
	NSInteger total_page;
	
	UIView *searchView;
	mokletdevPlayerViewController *players;
	UIButton* searchbutton ;
	MelonPlayer * MPlayer;
	mokletdevSearchMusicController *searchWindow;
	
	UIView *top_label;
	UILabel *TitleBig;
	UILabel *singerName;
	UILongPressGestureRecognizer *longTap;
	UILabel *songNamess;
	TJSpinner *spinner;
	StreamingBrief * streamingMetadata;
    
    NSString        * currentSongId;
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
}
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property(nonatomic,retain) NSMutableArray  * netraMutableArray;
@property(nonatomic,retain) NSMutableArray  * netraMutableArrayPlaylist;
@property(nonatomic,retain) NSMutableArray  * netraMutableArrayResult;
@property(nonatomic,strong) UIImageView     * titleImage;
@property(nonatomic,strong) NSIndexPath *currentIndex;
@property (nonatomic) CGFloat expandedCellHeight;
@property (nonatomic, strong) UIImageView   * gTunggu;


@end
