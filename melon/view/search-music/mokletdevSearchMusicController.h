//
//  mokletdevSearchMusicController.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mokletdevPlayerViewController.h"

@class MelonPlayer;

@interface mokletdevSearchMusicController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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
}

@property(nonatomic,strong) NSMutableArray  * netraMutableArray;
@property (nonatomic, strong) UIImageView   * gTunggu;

@end
