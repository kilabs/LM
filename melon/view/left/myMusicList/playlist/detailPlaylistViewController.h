//
//  detailPlaylistViewController.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/10/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mokletdevPlayerViewController.h"
@interface detailPlaylistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView * songListTable;
    UIView      * top_label;
	UILabel     * TitleBig;
    UIView      * plView;
    
    NSInteger   currentPage;
    NSInteger   totalPage;
    
    NSString    * playlistId;
	mokletdevPlayerViewController *players;
	 NSString * currentSongId;
    
    MelonPlayer * MPlayer;
	UIView *empty;
	UILabel *empty_title;
	UILabel *empty_text;
    
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
    UIView          * slowConnectionView;
}

@property (nonatomic, strong) UITableView * songListTable;
@property (nonatomic, strong) NSMutableArray * playlistSongList;

@property (nonatomic, strong) NSString * playlistId;
@property (nonatomic, strong) NSString * playlistTitle;
@property(nonatomic,strong) NSIndexPath *currentIndex;
@property (nonatomic) CGFloat expandedCellHeight;
@property (nonatomic, strong) UIImageView   * gTunggu;

@end
