//
//  mokletdevAllSong.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"
#import "mokletdevPlayerViewController.h"
#import "GAITrackedViewController.h"

@class MelonPlayer;
@class localplayer;
@class AbstractActionSheetPicker;
@interface mokletdevAllSong : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
	UITableView *AllSongTable;
    NSArray * AllSongList;

	UIView *top_label;
	UILabel *TitleBig;
    UISearchBar *searchbar;
    NSInteger current_page;
	NSInteger currIndex;
    NSInteger lastIndex;
	NSInteger total_page;
    MelonPlayer * MPlayer;
    localplayer *lplayer;
    NSString * currentSongId;
	UISearchDisplayController *searchController;
    mokletdevPlayerViewController *players;
	UIView *empty;
	UILabel *empty_title;
	UILabel *empty_text;

}
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property(nonatomic,strong) NSIndexPath *currentIndex;
@property(nonatomic,retain) NSMutableArray  * netraMutableArrayPlaylist;
@property (nonatomic) CGFloat expandedCellHeight;
@property (nonatomic, strong) UIImageView   * gTunggu;

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
