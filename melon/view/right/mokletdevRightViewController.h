//
//  mokletdevRightViewController.h
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MelonPlayer;
@class localplayer;
@interface mokletdevRightViewController :  UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *MelonListRight;
	NSMutableArray *dummyData;
	UIView *miniplayer;
	UIView *player_button;
	UISlider *slider;
	UILabel *song_title;
	UILabel *singer;
	UILabel *time;
	UIImageView *image;
	 NSTimer * progressUpdateTimer;
	UIButton * btnPlayPause;
	UIButton * btnPlayPause_local;
	UIButton * btnNext;
    UIButton * btnPrev;


}

@property(nonatomic,strong)NSString *statusa;
@end
