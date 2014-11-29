//
//  mokletdevViewController.m
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevViewController.h"
#import "AFNetworking.h"
#import "songListObject.h"
#import "PageCacheList.h"
#import "netracell_.h"
#import <social/Social.h>
#import <Twitter/Twitter.h>
#import <accounts/Accounts.h>
#include "Encryption.h"
#include "GlobalDefine.h"
#import "MelonPlayer.h"
#import <CommonCrypto/CommonCrypto.h>
#import "localplayer.h"
#include "StreamingBrief.h"
#import "PlaylistBrief.h"
#import "mokletdevAppDelegate.h"
#import "DownloadList.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "songDownloader.h"
#import "YRDropdownView.h"
#import "DownloadList.h"
#import "localplayer.h"
#import "JASidePanelController.h"
#import "ActionSheetPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetStringPicker.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"

static const int kLoadingCellTag = 1273;
bool firstLoad=0;
bool fetch=0;
bool search=0;
bool opened=0;
bool search_active=0;
bool already_caches = 0;
NSString * bitRateCD;
NSString * codecTypeCD;
NSString * contentID;
NSString * errorCode;
NSString * fullTrackYN;
NSString * playtime;
NSString * sampling;
NSString * sessionID;


enum eTableContentType currTableContentType;
enum eTableContentType lastTableContentType;

enum eTableContentType {
    NEWRELEASE = 0,
    TOPCHART
};

@interface mokletdevViewController ()
{
@private
    songListObject * currentSong;
    songDownloader * _songDownloader;
}
@end

@implementation mokletdevViewController
@synthesize actionSheetPicker;
@synthesize gTunggu = _gTunggu;

int selectedResultIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		
		//UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
		searchView=[[UIView alloc]initWithFrame:CGRectMake(0, -50, 320, 40)];
		searchView.backgroundColor=[UIColor blackColor];
		
		self.currentIndex=Nil;
		MelonList=[[UITableView alloc]init];
		MelonList.delegate=self;
		MelonList.dataSource=self;
		MelonList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[MelonList setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		MelonList.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		[self.view addSubview:MelonList];
		/*
		 longTap = [[UILongPressGestureRecognizer alloc]
		 initWithTarget:self action:@selector(handleLongPress:)];
		 longTap.minimumPressDuration = 0.3; //seconds
		 longTap.delegate = self;
		 [MelonList addGestureRecognizer:longTap];
		 [longTap release];
		 */
		currIndex=-1;
        lastIndex = -1;
		spinner = [[[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator] autorelease];
        spinner.hidesWhenStopped = YES;
        [spinner setColor:[UIColor colorWithRed:COLORWITHRED green:COLORWITHGREEN blue:COLORWITHBLUE alpha:1]];
        [spinner setInnerRadius:10];
        [spinner setOuterRadius:20];
        [spinner setStrokeWidth:8];
		[spinner setCenter:CGPointMake(160.0,180.0)];
        [spinner setNumberOfStrokes:8];
        [spinner setPatternLineCap:kCGLineCapButt];
		//        [spinner setSegmentImage:[UIImage imageNamed:@"Stick.jpeg"]];
        [spinner setPatternStyle:TJActivityIndicatorPatternStyleBox];
		
		
		[self.view addSubview:spinner];
		
		//self.titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 142, 24.5)];
		//[self.titleImage setImage:[UIImage imageNamed:@"topChart"]];
		
		//selectedCellIndexPath=[[NSIndexPath alloc]init];
		
		UIImage* image = [UIImage imageNamed:@"right"];
		CGRect frame = CGRectMake(-5, 0, 44, 44);
		UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame];
		[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
		//[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
		[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *leftbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		leftbuttonView.backgroundColor=[UIColor clearColor];
		[leftbuttonView addSubview:leftbutton];
		UIBarButtonItem* leftbarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonView];
		
		UIImage* image2 = [UIImage imageNamed:@"left"];
		CGRect frame2 = CGRectMake(50, 0, 44, 44);
		UIButton* rightbutton = [[UIButton alloc] initWithFrame:frame2];
		[rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
		//[rightbutton setBackgroundImage:[UIImage imageNamed:@"right-push"] forState:UIControlStateHighlighted];
		[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIImage* image3 = [UIImage imageNamed:@"search-button"];
		CGRect frame3 = CGRectMake(5, 0, 44, 44);
		searchbutton = [[UIButton alloc] initWithFrame:frame3];
		[searchbutton setBackgroundImage:image3 forState:UIControlStateNormal];
		//[searchbutton setBackgroundImage:[UIImage imageNamed:@"search-button-pressed"] forState:UIControlStateHighlighted];
		[searchbutton addTarget:self action:@selector(searchSongs) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *RightbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
		RightbuttonView.backgroundColor=[UIColor clearColor];
		[RightbuttonView addSubview:rightbutton];
		//[RightbuttonView addSubview:searchbutton];
		
		
		UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:RightbuttonView];
		
		
		[self.navigationItem setRightBarButtonItem:rightbarButton];
		[self.navigationItem setLeftBarButtonItem:leftbarbutton];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		
		
		current_page=1;
		[self.view addSubview:searchView];
		
		//[searchView addSubview:searchbar];
		
        lastTableContentType = NEWRELEASE;
		self.netraMutableArray=[NSMutableArray array];
		self.netraMutableArrayPlaylist=[[NSMutableArray alloc]init];
		top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 200, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		
		TitleBig=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
		TitleBig.text=NSLocalizedString(@"New Release", nil);
		TitleBig.textAlignment=NSTextAlignmentCenter;
		TitleBig.backgroundColor=[UIColor clearColor];
		[TitleBig setFont:[UIFont fontWithName:@"Marion-Bold" size:22]];
		TitleBig.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
		TitleBig.hidden=NO;
        
        [top_label addSubview:TitleBig];
		    
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    top_label.hidden = NO;
    TitleBig.hidden=NO;
    [self.navigationController.navigationBar addSubview:top_label];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
    
    selectedResultIndex = 0;

    
}
-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}

- (void)dismiss {
	
	
}
-(void)reloadInternet{
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    return 9;
	
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *cells = @"CellIdentifier";
    UITableViewCell *cell = [MelonList dequeueReusableCellWithIdentifier:cells];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
    }
    return cell;
}
@end
