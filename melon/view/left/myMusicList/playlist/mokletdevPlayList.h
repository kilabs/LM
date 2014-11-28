//
//  mokletdevPlayList.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"
#import "GAITrackedViewController.h"
@interface mokletdevPlayList : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{

	UITableView *playListTable;
	UIView *top_label;
	UILongPressGestureRecognizer *lp;
	UILabel *TitleBig;
    UIButton* searchbutton ;
    UIView  * plView;
    UIButton * btnAddPlaylist;
    NSInteger current_page;
	NSInteger total_page;
	TJSpinner *spinner;
	UIAlertView *message;
    
    BOOL            isLoadingData;
    BOOL            loadTimerisON;
    NSTimer         * loadingDataTimer;
    UIView          * slowConnectionView;
}
@property (nonatomic, strong) UITableView       * playListTable;
@property (nonatomic, strong, readwrite) NSMutableArray    * playListArray;
@property(nonatomic,strong) NSIndexPath *currentIndex;
@property (nonatomic) CGFloat expandedCellHeight;
@end
