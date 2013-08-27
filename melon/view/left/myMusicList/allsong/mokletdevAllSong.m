//
//  mokletdevAllSong.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevAllSong.h"
#import "mokletdevAppDelegate.h"
#import "LocalPlaylist.h"
#import "DownloadList.h"
#import "AFNetworking.h"
#import "MelonPlayer.h"
#import "netracell_.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "EUserBrief.h"
#import "mokletdevPlayerViewController.h"
#import "localplayer.h"
#import "YRDropdownView.h"
#import "PlaylistBrief.h"
#import "GlobalDefine.h"

#import <Twitter/Twitter.h>
#import <social/Social.h>
#import <accounts/Accounts.h>
@interface mokletdevAllSong ()
{
@private
    LocalPlaylist * currentList;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContex;

@property (nonatomic,retain) NSMutableArray  * AllSongList;
@property (nonatomic,retain) NSMutableArray  * All_last_download_list;
@property (nonatomic, strong) UITableView * AllSongTable;

@end

@implementation mokletdevAllSong

@synthesize AllSongList = _AllSongList;

@synthesize AllSongTable = _AllSongTable;
@synthesize gTunggu = _gTunggu;
bool isFiltered=false;

int selectedResultIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.backgroundColor=[UIColor whiteColor];
		// Custom initialization
		top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		self.netraMutableArrayPlaylist=[[NSMutableArray alloc]init];
		AllSongTable=[[[UITableView alloc]init] autorelease];
		AllSongTable.backgroundColor=[UIColor blackColor];
		AllSongTable.delegate=self;
		AllSongTable.dataSource=self;
		AllSongTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		
		[AllSongTable setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		
		AllSongTable.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		[AllSongTable setContentOffset:CGPointMake(0,44) animated:YES];
		[self.view addSubview:AllSongTable];
		
		empty=[[UIView alloc]initWithFrame:CGRectMake(20, ((self.view.frame.size.height-120)/2)-60, 280, 120)];
		empty.backgroundColor=[UIColor clearColor];
		
		empty_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
		empty_title.text=@"All Song Empty";
		empty_title.backgroundColor=[UIColor clearColor];
		empty_title.textAlignment=NSTextAlignmentCenter;
		empty_title.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
		[empty_title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
		
		empty_text=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 110)];
		empty_text.text=@"Tidak ada musik di direktori lokal iphone anda";
		empty_text.numberOfLines=2;
		empty_text.backgroundColor=[UIColor clearColor];
		empty_text.textAlignment=NSTextAlignmentCenter;
		empty_text.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
		[empty_text setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
		
		
		[self.view addSubview:empty];
		[empty addSubview:empty_title];
		[empty addSubview:empty_text];

		
		
	}
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchNotes)
												name:@"reloadTable"
											  object:nil];
    
    top_label.hidden = NO;
	
}
-(void)facebookShare:(id)sender{
	//NSInteger i = [sender tag];
	
	//songListObject *dataObject=[self.netraMutableArray objectAtIndex:i];
    LocalPlaylist * dataObject = [self.AllSongList objectAtIndex:[sender tag]];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *facebooContent=[NSString stringWithFormat:@"is listening to %@ by %@ %@ via MelOn for IOS", dataObject.songTitle, dataObject.artistName,shorturl];
	//Check if our weak library (Twitter.framework) is available
	
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
				
                NSLog(@"Cancelled");
				
            } else
				
            {
                NSLog(@"Done");
            }
			
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
		
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:facebooContent];
		NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
		
		NSURL *url_image = [NSURL URLWithString:baseUrls];
		NSData *data = [NSData dataWithContentsOfURL:url_image];
		UIImage *images = [UIImage imageWithData:data];
        [controller addImage:images];
		
        [self presentViewController:controller animated:YES completion:Nil];
		
    }
    else{
        NSLog(@"UnAvailable");
    }
}
-(void)twitterShare:(id)sender{
	    LocalPlaylist * dataObject = [self.AllSongList objectAtIndex:[sender tag]];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *twitContent=[NSString stringWithFormat:@"#MelOnPlaying %@ by %@ %@ via MelOn for IOS", dataObject.songTitle, dataObject.artistName,shorturl];
	//Check if our weak library (Twitter.framework) is available
    Class TWTweetClass = NSClassFromString(@"TWTweetComposeViewController");
    if (TWTweetClass != nil)
    {
        //Create the tweet sheet
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        
        //Set initial text (optional)
        [tweetSheet setInitialText:twitContent];
        
        //Attach an image (optional)
		// [tweetSheet addImage:[UIImage imageNamed:@"anImage.png"]];
        
        //Add a link (optional)
		// [tweetSheet addURL:[NSURL URLWithString:@"http://www.pixelchild.com.au/"]];
        
        //Set our completion handler with a block
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
        //Present the tweet sheet
        [self presentModalViewController:tweetSheet animated:YES];
        
        //Release unless your one of the cool kids using ARC :)
        [tweetSheet release];
        
    }
    else
    {
        //TODO: Add a twitter composer fallback
    }
}
-(void)viewWillAppear:(BOOL)animated{
	[TitleBig setHidden:YES];
	[self initLayout];
	[self fetchNotes];
	netracell_ *cell = (netracell_ *)[AllSongTable cellForRowAtIndexPath:self.currentIndex];
	cell.twitter.hidden=NO;
	cell.facebook.hidden=NO;
	cell.playmex.hidden=NO;
	cell.addto_play_list.hidden=NO;
	cell.twitter.frame=CGRectMake(175, 83, 34, 34);
	cell.facebook.frame=CGRectMake(240, 83, 34, 34);
	cell.playmex.frame=CGRectMake(110, 83, 34, 34);
	cell.addto_play_list.frame=CGRectMake(45, 83, 34, 34);
    
    self.gTunggu = [[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 160.0)/2, (CGRectGetHeight(self.view.bounds) - 212)/2, 160.0, 106)] autorelease];
    [self.gTunggu setImage:[UIImage imageNamed:@"st"]];
    [self.view addSubview:self.gTunggu];
    self.gTunggu.hidden = YES;
    
    selectedResultIndex = 0;
    
    [self installNotification];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self uninstallNotification];
}

-(void)addtoPlaylist:(id)sender{
	LocalPlaylist * currentSongList = [self.AllSongList objectAtIndex:[sender tag]];
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	//NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	if([users_active count]>0){
		NSMutableArray *FC=[[NSMutableArray alloc]init];
		[FC removeAllObjects];
		for(int i=0;i<self.netraMutableArrayPlaylist.count;i++){
			PlaylistBrief *a=[self.netraMutableArrayPlaylist objectAtIndex:i];
			[FC addObject:a.playlistName];
			
			
		}
		ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
			PlaylistBrief *b=[self.netraMutableArrayPlaylist objectAtIndex:selectedIndex];
			[self postPlaylist:currentSongList.songId playlistId:b.playlistId playlistName:selectedValue songName:currentSongList.songTitle];
			
		};
		[ActionSheetStringPicker showPickerWithTitle:@"Pilih Playlist" rows:FC initialSelection:0 doneBlock:done cancelBlock:nil origin:sender];
		
		
	}
	else{
		[YRDropdownView showDropdownInView:self.view
									 title:@"Galat"
									detail:@"Silahkan login terlebih dahulu untuk dapat Memasukkan lagu dalam playlist."
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
	}
}
-(void)postPlaylist:(NSString *)songId playlistId:(NSString *)playlistId playlistName:(NSString *)playlistName songName:(NSString *)songName{
	
	NSString *berhasil=[NSString stringWithFormat:@"%@ berhasil dimasukkan ke dalam playlist %@",songName,playlistName];
	NSString *gagal=[NSString stringWithFormat:@"%@ gagal dimasukkan ke dalam playlist %@",songName,playlistName];
	
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
	NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists/%@/song?_CNAME=iOS Client&&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=%@&_UPASS=%@&_method=PUT&newSongId=%@&plasylitId=%@", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId,playlistId,user_now.username,user_now.webPassword,songId,playlistId];
	NSURL *URL=[NSURL URLWithString:sURL];
	NSString *properlyEscapedURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
	NSLog(@"MAPI_SERVER--->%@",sURL);
	
	NSMutableURLRequest * request = [httpClient requestWithMethod:@"PUT" path:properlyEscapedURL parameters:nil];
	NSLog(@"request--->%@",request);
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[YRDropdownView showDropdownInView:self.view
									 title:@"Informasi"
									detail:berhasil
									 image:[UIImage imageNamed:@"dropdown-alert_success"]
						   backgroundImage:[UIImage imageNamed:@"allow"]
								  animated:YES
								 hideAfter:3];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[YRDropdownView showDropdownInView:self.view
									 title:@"Galat"
									detail:gagal
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
		
	}];
    
	[operation start];
    [httpClient release];
	
	
}
-(void)loadPlaylist:(NSString*)userId pass:(NSString*)pass username:(NSString *)username{
	[self.netraMutableArrayPlaylist removeAllObjects];
	
    NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists?_CNAME=iOS Client&&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=%@&_UPASS=%@&offset=0&limit=100", [NSString stringWithUTF8String:MAPI_SERVER], userId,username,pass];
	NSURL *URL=[NSURL URLWithString:sURL];
	NSString *properlyEscapedURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:properlyEscapedURL parameters:Nil];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		for (id data in [responseObject objectForKey:@"dataList"])
        {
            PlaylistBrief * playlistItem = [[PlaylistBrief alloc] initWithDictionary:data];
            if (![self.netraMutableArrayPlaylist containsObject:playlistItem])
            {
                [self.netraMutableArrayPlaylist addObject:playlistItem];
				// _playListArray = self.playListArray;
            }
            [playlistItem release];
			//NSLog(@"responseobject--->%@",responseObject);
        }
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
		}
        NSLog(@"error: %@", [error description]);
		
	}];
    
	[operation start];
    [httpClient release];
}
-(void)initLayout{
	
	
	
	
	// Custom initialization
	self.view.backgroundColor=[UIColor whiteColor];
	top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
	top_label.backgroundColor=[UIColor clearColor];
	
	TitleBig=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
	TitleBig.text=@"All Songs";
	TitleBig.textAlignment=NSTextAlignmentCenter;
	TitleBig.backgroundColor=[UIColor clearColor];
	[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
	TitleBig.textColor = [UIColor whiteColor];
	TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
	TitleBig.shadowOffset = CGSizeMake(0, 1.0);
	TitleBig.hidden=NO;
	[top_label addSubview:TitleBig];
	
	UIImage* image = [UIImage imageNamed:@"left"];
	CGRect frame = CGRectMake(-5, 0, 44, 44);
	UIButton* leftbutton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
	
	
	UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
	leftbuttonView.backgroundColor=[UIColor clearColor];
	[leftbuttonView addSubview:leftbutton];
	UIBarButtonItem* leftbarbutton = [[[UIBarButtonItem alloc] initWithCustomView:leftbuttonView] autorelease
									  ];
	[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage* image2 = [UIImage imageNamed:@"right"];
	CGRect frame2 = CGRectMake(50, 0, 44, 44);
	UIButton* rightbutton = [[[UIButton alloc] initWithFrame:frame2] autorelease
							 
							 ];
	[rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
	[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *RightbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)] autorelease];
	RightbuttonView.backgroundColor=[UIColor clearColor];
	[RightbuttonView addSubview:rightbutton];
	
	UIBarButtonItem* rightbarButton = [[[UIBarButtonItem alloc] initWithCustomView:RightbuttonView]  autorelease];
	
	
	[self.navigationItem setRightBarButtonItem:rightbarButton];
	[self.navigationItem setLeftBarButtonItem:leftbarbutton];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];
	
}

-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
    return self.AllSongList.count;
	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    netracell_ * cell = [AllSongTable dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[netracell_ alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	if(indexPath.row % 2==0){
		cell.container.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
	}
	else{
		cell.container.backgroundColor=[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
	}
	LocalPlaylist * currentSongList = [self.AllSongList objectAtIndex:indexPath.row];
	
	cell.title.text = currentSongList.songTitle;
	cell.excerpt.text = currentSongList.artistName;
	cell.albumName.text = currentSongList.albumName;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",currentSongList.realSongid];
	[cell.thumbnail setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
	cell.download.hidden=YES;
	cell.play.tag=indexPath.row;
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.download.hidden=YES;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.playmex.hidden=YES;
	cell.addto_play_list.hidden=YES;
    //cell.removeButton.hidden = NO;
    cell.playmex.tag = indexPath.row;
	cell.addto_play_list.tag=indexPath.row;
	cell.facebook.tag=indexPath.row;
	cell.twitter.tag=indexPath.row;
    //cell.removeButton.tag = indexPath.row;
    
    [cell.playmex addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	[cell.addto_play_list addTarget:self action:@selector(addtoPlaylist:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

		CGFloat cellHeight = 153/2;
		if ([self.currentIndex isEqual:indexPath]) {
			cellHeight = self.expandedCellHeight;
		}
		return cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	netracell_ *cell = (netracell_ *)[AllSongTable cellForRowAtIndexPath:indexPath];
	netracell_ *lass=(netracell_ *)[AllSongTable cellForRowAtIndexPath:self.currentIndex];
	
    selectedResultIndex = indexPath.row;
    
	if ([self.currentIndex isEqual:indexPath]){
		cell.twitter.hidden=YES;
		NSLog(@"sama kok");
		self.currentIndex = nil;
		self.expandedCellHeight =  153/2;
		[AllSongTable beginUpdates];
		[AllSongTable endUpdates];
		[UIView animateWithDuration:0.3
							  delay:0
							options: UIViewAnimationCurveEaseOut
						 animations:^{
							 cell.twitter.hidden=NO;
							 cell.facebook.hidden=NO;
							 cell.playmex.hidden=NO;
							 cell.addto_play_list.hidden=NO;
							 cell.facebook.frame=CGRectMake(240, 40, 34, 34);
							 cell.twitter.frame=CGRectMake(175, 40, 34, 34);
							 cell.playmex.frame=CGRectMake(110, 40, 34, 34);
							 cell.addto_play_list.frame=CGRectMake(45, 40, 34, 34);
						 }
						 completion:^(BOOL finished){
							 NSLog(@"Animation Done!");
							 // cell.twitter.hidden=YES;
							 // cell.facebook.hidden=YES;
							 cell.twitter.hidden=YES;
							 cell.facebook.hidden=YES;
							 cell.playmex.hidden=YES;
							 cell.addto_play_list.hidden=YES;
						 }];
		
		
	}
	//NSLog(@"UIGestureRecognizerStateBegan.");
	else{
		//Do Whatever You want on Began of Gesture
		self.currentIndex = indexPath;
		self.expandedCellHeight =  125;
		[AllSongTable beginUpdates];
		cell.twitter.hidden=YES;
		cell.playmex.hidden=YES;
		cell.facebook.hidden=YES;
		cell.addto_play_list.hidden=YES;
		
		
		lass.twitter.hidden=YES;
		lass.facebook.hidden=YES;
		lass.playmex.hidden=YES;
		lass.addto_play_list.hidden=YES;
		
		[AllSongTable endUpdates];
		cell.facebook.frame=CGRectMake(240, 40, 34, 34);
		cell.twitter.frame=CGRectMake(175, 40, 34, 34);
		cell.playmex.frame=CGRectMake(110, 40, 34, 34);
		cell.addto_play_list.frame=CGRectMake(45, 40, 34, 34);
		[UIView animateWithDuration:0.3
							  delay:0
							options: UIViewAnimationCurveEaseOut
						 animations:^{
							 cell.twitter.hidden=NO;
							 cell.facebook.hidden=NO;
							 cell.playmex.hidden=NO;
							 cell.addto_play_list.hidden=NO;
							 cell.twitter.frame=CGRectMake(175, 83, 34, 34);
							 cell.facebook.frame=CGRectMake(240, 83, 34, 34);
							 cell.playmex.frame=CGRectMake(110, 83, 34, 34);
							 cell.addto_play_list.frame=CGRectMake(45, 83, 34, 34);
							 
						 }
						 completion:^(BOOL finished){
							 
						 }];
	}

	
	/*
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	
	mokletdevPlayerViewController *players = [[[mokletdevPlayerViewController alloc]init] autorelease];
	 LocalPlaylist * dataObject = [self.AllSongList objectAtIndex:indexPath.row];
	players.sSongId = dataObject.realSongid;
	players.sSongTitle = dataObject.songTitle;
	players.sArtistId = dataObject.artistId;
    players.sArtistName = dataObject.artistName;
	players.sAlbumId = dataObject.albumId;
    players.sAlbumName = dataObject.albumName;
	players.status=[NSString stringWithFormat:@"0"];
	
	[self.navigationController pushViewController:players animated:YES];
	[TitleBig setHidden:YES];
	LocalPlaylist * pl = [self.AllSongList objectAtIndex:indexPath.row];
	NSLog(@"pl--->%@",pl.filePath);
	[[MelonPlayer sharedInstance].streamer stop];
	lplayer=[localplayer sharedInstance];
	if([pl.songId isEqualToString:lplayer.songnowNow])
	{
		if([lplayer isPlaying]) {
			
			
		}
		else{
			
			[lplayer play];
			
		}
	}
	else{
		
		[lplayer stop];
		[lplayer playThisSong:pl.songId andSongId:pl.filePath songtitle:pl.songTitle singer:pl.artistName];
		
		[lplayer play];
		
	}
	
	
	*/
	
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(self.currentIndex !=nil){
		netracell_ *cell = (netracell_ *)[AllSongTable cellForRowAtIndexPath:self.currentIndex];
		cell.twitter.hidden=NO;
		cell.facebook.hidden=NO;
		cell.playmex.hidden=NO;
		cell.addto_play_list.hidden=NO;
		cell.twitter.frame=CGRectMake(175, 83, 34, 34);
		cell.facebook.frame=CGRectMake(240, 83, 34, 34);
		cell.playmex.frame=CGRectMake(110, 83, 34, 34);
		cell.addto_play_list.frame=CGRectMake(45, 83, 34, 34);
	}
	
}
-(void)playMe:(id)sender
{
    
    //LocalPlaylist * songItem = [self.AllSongList objectAtIndex:[sender tag]];
    //if (songItem == nil)
    //    return;
    
    selectedResultIndex = [sender tag];
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    [MPlayer stop];
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    [PlayerLib clearPlaylist];
    for (int i = 0; i < [self.AllSongList count]; ++i)
    {
        LocalPlaylist * songItem = [self.AllSongList objectAtIndex:i];
        songItem.songId = songItem.realSongid;
        [PlayerLib addToPlaylistofPlaylistSongItem:songItem];
    }
    
    //[MPlayer stop];
    LocalPlaylist * songItem = [self.AllSongList objectAtIndex:[sender tag]];
    songItem.songId = songItem.realSongid;

    [PlayerLib addToPlaylistofPlaylistSongItem:songItem];
    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
    NSURL * songURL = [NSURL fileURLWithPath:songPath];
    
    if ([songPath isEqualToString:@""]) // streaming
    {
        [MPlayer setSongType:0];
        [MPlayer periksaLagudanStream:songItem.songId];
    }
    else
    {
        [self showPlayer:nil];
        [MPlayer setSongType:1];
        [MPlayer playSongWithURL:songURL];
        [players createTimer];
    }
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
		LocalPlaylist * dataObject = [self.AllSongList objectAtIndex:indexPath.row];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		BOOL fileExists = [fileManager fileExistsAtPath:dataObject.filePath];
		NSLog(@"Path to file: %@", dataObject.filePath);
		NSLog(@"File exists: %d", fileExists);
		NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:dataObject.filePath]);
		if (fileExists)
		{
			NSLog(@"Yup file ada");
			BOOL success = [fileManager removeItemAtPath:dataObject.filePath error:&error];
			if (!success) NSLog(@"Error: %@", [error localizedDescription]);
		}
		DownloadList *music_f = [DownloadList MR_findFirstByAttribute:@"songId" withValue:dataObject.realSongid inContext:localContext];
		if(music_f){
			[music_f MR_deleteInContext:localContext];
		}
		[self.AllSongList removeObjectAtIndex:indexPath.row];
		[dataObject MR_deleteEntity];
		[localContext MR_saveNestedContexts];
		
		/*delete file
		 */
		
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if([[localplayer sharedInstance] isPlaying]){
			[[localplayer sharedInstance] stop];
		}
		
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}
- (void) doDownload:(id) sender
{
	
}

//- (void) doPlay:(id) sender
//{
//    LocalPlaylist * songItem = [self.AllSongList objectAtIndex:[sender tag]];
//    if (songItem == nil)
//        return;
//    
//    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
//    MPlayer = [MelonPlayer sharedInstance];
//    
//    top_label.hidden=YES;
//    players = [[mokletdevPlayerViewController alloc]init];
//    players.sSongId     = songItem.songId;
//    players.sSongTitle  = songItem.songTitle;
//	players.sArtistId   = songItem.artistId;
//    players.sArtistName = songItem.artistName;
//	players.sAlbumId    = songItem.albumId;
//    players.sAlbumName  = songItem.albumName;
//	players.playTime    = songItem.playTime;
//    [self.navigationController pushViewController:players animated:YES];
//    [players release];
//    
//    // check current playing song.
//    
//    if ([appDelegate.nowPlayingPlaylistDefault count] > 0)
//    {
//        LocalPlaylist1 * npSong = [[LocalPlaylist1 alloc] init];
//        npSong = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
//        
//        NSLog(@"npSong.songId - songItem.songId : %@ - %@.", npSong.songId, songItem.songId);
//        if ([npSong.songId isEqualToString:songItem.songId])
//        {
//            if ([MPlayer isPlaying])
//            {
//                [players createTimer];
//                return;
//            }
//        }
//    }
//    
//    [PlayerLib addToPlaylistofPlaylistSongItem:songItem];
//    
//    [MPlayer stop];
//    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
//    NSURL * songURL = [NSURL fileURLWithPath:songPath];
//    
//    if ([songPath isEqualToString:@""]) // streaming
//    {
//        [MPlayer setSongType:0];
//        [MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
//    }
//    else
//    {
//        [MPlayer setSongType:1];
//        [MPlayer playSongWithURL:songURL];
//        [players createTimer];
//    }
//    
//}


- (void)fetchNotes {
	NSArray *userNow=[EUserBrief MR_findAll];
	EUserBrief *orang=[userNow objectAtIndex:0];
	
	
	
	self.AllSongList = [NSMutableArray arrayWithArray:[LocalPlaylist MR_findByAttribute:@"userId" withValue:orang.userId andOrderBy:@"tanggal" ascending:YES]];
	
	//self.AllSongList = [NSMutableArray arrayWithArray:[LocalPlaylist MR_findAll]];
	
	if(self.AllSongList.count==0){
		empty.hidden=NO;
		
	}
	else{
		empty.hidden=YES;
		[AllSongTable reloadData];
		[AllSongTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self loadPlaylist:orang.userId pass:orang.webPassword username:orang.username];
		}
}

- (void) showWaitMessage: (NSNotification *) notification
{
    self.gTunggu.hidden = NO;
}

- (void) DismissWaitMessage: (NSNotification *) notification
{
    self.gTunggu.hidden = YES;
}

- (void) showPlayer: (NSNotification *) notification
{
    if (selectedResultIndex < 0)
        return;
    
    LocalPlaylist * songItem = [self.AllSongList objectAtIndex:selectedResultIndex];
    top_label.hidden=NO;
    players = [[mokletdevPlayerViewController alloc]init];
    players.sSongId     = songItem.songId;
    players.sSongTitle  = songItem.songTitle;
	players.sArtistId   = songItem.artistId;
    players.sArtistName = songItem.artistName;
	players.sAlbumId    = songItem.albumId;
    players.sAlbumName  = songItem.albumName;
	players.playTime    = songItem.playTime;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	[players release];
    
    self.gTunggu.hidden = YES;
}

#pragma mark ---
#pragma mark notification

- (void) installNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showWaitMessage:)
                                                 name:@"ShowWaitMessage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DismissWaitMessage:)
                                                 name:@"DismissWaitMessage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPlayer:)
                                                 name:@"ShowPlayer"
                                               object:nil];
}

- (void) uninstallNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"ShowWaitMessage"
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"DismissWaitMessage"
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"ShowPlayer"
                                                 object:nil];
}

@end
