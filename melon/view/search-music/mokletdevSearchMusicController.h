//
//  mokletdevSearchMusicController.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mokletdevPlayerViewController.h"
#import "GAITrackedViewController.h"
#import "UIBorderLabel.h"

@class MelonPlayer;

@interface mokletdevSearchMusicController : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	mokletdevPlayerViewController * players;
    
	UITableView         * searchResult;
    UITableView         * searchResultAlbum;
    UITableView         * searchResultArtist;
	UIView              * searchbarContainer;
	UITextField         * searchForm;
	NSInteger           current_page;
	NSInteger           total_page;
    UIView              * top_label;
	UILabel             * TitleBig;
    MelonPlayer         * MPlayer;
	NSString            * currentSongId;
	UIButton            * searchbutton ;
}

@property(nonatomic,strong) NSMutableArray  * netraMutableArray;
@property(nonatomic,strong) NSMutableArray  * netraMutableAlbumArray;
@property(nonatomic,strong) NSMutableArray  * netraMutableArtistArray;
@property(nonatomic, strong) UIImageView   * gTunggu;
@property(nonatomic,strong) UIBorderLabel *HeaderTitle;
@property(nonatomic,strong) UIBorderLabel *HeaderTitleAlbum;
@property(nonatomic,strong) UIBorderLabel *HeaderTitleArtist;
@property(nonatomic,strong) UIScrollView *scrollView;

@end
