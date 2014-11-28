//
//  AlbumListControllerByArtist.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mokletdevPlayerViewController.h"
#import "GAITrackedViewController.h"
#import "UIBorderLabel.h"
#import "TJSpinner.h"

@class MelonPlayer;

@interface AlbumListControllerByArtist : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	mokletdevPlayerViewController * players;
    
	UITableView         * searchResult;
	UIView              * searchbarContainer;
	UITextField         * searchForm;
	NSInteger           current_page;
	NSInteger           total_page;
    UIView              * top_label;
	UILabel             * TitleBig;
    MelonPlayer         * MPlayer;
	NSString            * currentSongId;
	UIButton            * searchbutton ;
    UIButton            * backButton;
    TJSpinner           *spinner;
}

@property(nonatomic,strong) NSMutableArray  * netraMutableAlbumArray;
@property (nonatomic, strong) UIImageView   * gTunggu;
@property(nonatomic,strong) UIBorderLabel   *HeaderTitle;

@end