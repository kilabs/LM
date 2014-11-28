//
//  downloadQueueViewController.h
//  melon
//
//  Created by Arie on 5/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "songDownloader.h"
#import "playerLocalViewController.h"
#import "GAITrackedViewController.h"
@class songDownloader;
@interface downloadQueueViewController : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *q;
	UIView *top_label;
	UILabel *TitleBig;
    
    UIView  * plView;
    UIButton * btnAddPlaylist;
	    songDownloader * mySongDownloader;
	NSTimer * timerDownloadProgress;
	
	playerLocalViewController *players;
}
@property(nonatomic,strong)NSMutableArray *soangQueue;
@end
