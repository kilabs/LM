//
//  allsongpickerViewController.h
//  melon
//
//  Created by Arie on 5/29/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface allsongpickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *AllSongTable;
   // NSArray * AllSongList;
	
	UIView *top_label;
	UILabel *TitleBig;
    
    NSInteger current_page;
	NSInteger currIndex;
    NSInteger lastIndex;
	NSInteger total_page;
   // MelonPlayer * MPlayer;
    //localplayer *lplayer;
    NSString * currentSongId;
	NSMutableArray *list_to_push;
	UIImageView *checkmark;
	UIView *empty;
	UILabel *empty_title;
	UILabel *empty_text;
}
@property(nonatomic,strong)NSString *playlist_id;
@property(nonatomic,strong)NSString *playlist_name;

@end
