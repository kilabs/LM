//
//  mokletdevPlayList.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevPlayList.h"
#include "GlobalDefine.h"
#import "AFNetworking.h"
#import "playlistTableViewCell.h"
#import "mokletdevAppDelegate.h"
#import "PlaylistBrief.h"
#import "detailPlaylistViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "addPlaylistForm.h"
#import "YRDropdownView.h"
#import "PageCacheList.h"
@interface mokletdevPlayList () <addplaylistFormDelegate>{
	addPlaylistForm *add;
}

@end

@implementation mokletdevPlayList

@synthesize playListTable = _playListTable;
@synthesize playListArray = _playListArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateTextView) name:@"commit" object:nil];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
		// Do any additional setup after loading the view.
		spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
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
		UIImage* image = [UIImage imageNamed:@"left"];
		CGRect frame = CGRectMake(-5, 0, 44, 44);
		UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame];
		[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
		//[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
		[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *leftbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		leftbuttonView.backgroundColor=[UIColor clearColor];
		[leftbuttonView addSubview:leftbutton];
		UIBarButtonItem* leftbarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonView];
		
		UIImage* image2 = [UIImage imageNamed:@"right"];
		CGRect frame2 = CGRectMake(50, 0, 44, 44);
		UIButton* rightbutton = [[UIButton alloc] initWithFrame:frame2];
		[rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
		//[rightbutton setBackgroundImage:[UIImage imageNamed:@"right-push"] forState:UIControlStateHighlighted];
		[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIImage* image3 = [UIImage imageNamed:@"add-button"];
		CGRect frame3 = CGRectMake(5, 0, 44, 44);
		searchbutton = [[UIButton alloc] initWithFrame:frame3];
		[searchbutton setBackgroundImage:image3 forState:UIControlStateNormal];
		//[searchbutton setBackgroundImage:[UIImage imageNamed:@"search-button-pressed"] forState:UIControlStateHighlighted];
		[searchbutton addTarget:self action:@selector(addPlayList) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *RightbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
		RightbuttonView.backgroundColor=[UIColor clearColor];
		[RightbuttonView addSubview:rightbutton];
		[RightbuttonView addSubview:searchbutton];
		
		
		UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:RightbuttonView];
		
		
		[self.navigationItem setRightBarButtonItem:rightbarButton];
		[self.navigationItem setLeftBarButtonItem:leftbarbutton];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-lain"] forBarMetrics:UIBarMetricsDefault];
		[self.navigationController.navigationBar addSubview:top_label];
		
		
		playListTable=[[[UITableView alloc]init] autorelease];
		playListTable.frame=CGRectMake(0, plView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[playListTable setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]];
		[playListTable setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		[self.view addSubview:playListTable];
		playListTable.delegate = self;
		playListTable.dataSource = self;
		playListTable.hidden=YES;
		lp = [[UILongPressGestureRecognizer alloc]
				   initWithTarget:self action:@selector(handleLongPress:)];
		lp.minimumPressDuration = 0.3; //seconds
		lp.delegate = self;
		[playListTable addGestureRecognizer:lp];
		[lp release];
		
		slowConnectionView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		slowConnectionView.backgroundColor=[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1] ;
		slowConnectionView.hidden=YES;
		[self.view addSubview:slowConnectionView];
        
        UILabel * labelNoConnection = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height - 250) /2, self.view.frame.size.width, 100.0)];
        labelNoConnection.backgroundColor = [UIColor clearColor];
        [labelNoConnection setFont:[UIFont fontWithName:@"OpenSans" size:9]];
        labelNoConnection.textColor = [UIColor grayColor];
        labelNoConnection.textAlignment = NSTextAlignmentCenter;
        labelNoConnection.lineBreakMode = NSLineBreakByClipping;
        labelNoConnection.numberOfLines = 4;
        labelNoConnection.text = @"Jaringan Anda kemungkinan tehubung lambat.\r\nGunakan jaringan dengan kecepatan cukup untuk hasil yang bagus.";
        [slowConnectionView addSubview:labelNoConnection];
		
		// Custom initialization
		
		self.playListArray = [[NSMutableArray alloc] init];
		current_page = 1;
		//[self fetchUserPlaylist];
			//[self fetchUserPlaylist];
        // Custom initialization
		
    }
    return self;
}

-(void)addPlayList{
	add=[[addPlaylistForm alloc]init];
	[self presentPopupViewController:add animationType:MJPopupViewAnimationSlideBottomBottom];
	
	
}
- (void)populateTextView
{
	//NSLog(@"adds-->%@",adds);
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
	[self fetchUserPlaylist];
    add = nil;
}
-(void)viewWillAppear:(BOOL)animated{
	top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 186, 44)];
	top_label.backgroundColor=[UIColor clearColor];
	
	TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 186, 44)] autorelease];
	TitleBig.text=NSLocalizedString(@"Playlist",nil);
	TitleBig.textAlignment=NSTextAlignmentCenter;
	TitleBig.backgroundColor=[UIColor clearColor];
	[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
	TitleBig.textColor = [UIColor whiteColor];
	TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
	TitleBig.shadowOffset = CGSizeMake(0, 1.0);
	TitleBig.hidden=NO;
	
	[top_label addSubview:TitleBig];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-lain"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];

    NSLog(@"Lalu di sini.");
    
    isLoadingData = YES;
    loadingDataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(loadingTimeUp:)
                                                      userInfo:nil
                                                       repeats:YES];
    loadTimerisON = YES;
    
    [self fetchUserPlaylist];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    top_label.hidden = NO;
    
    //tracking google analytics
    self.screenName = NSLocalizedString(@"Screen Name Playlist", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lefbuttonPush{
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	[self.sidePanelController showRightPanel:YES];
}

-(void)loadCacheData{
    //check store data
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"playlist" inContext:localContext];
    if (cache){
        
        //clear song data
        [self.playListArray removeAllObjects];
		[playListTable reloadData];
        
        //NSLog(@"LOAD CACHE %@", cache.cacheData);
        
        for (id data in [cache.cacheData objectForKey:@"dataList"])
        {
            PlaylistBrief * playlistItem = [[PlaylistBrief alloc] initWithDictionary:data];
            if (![self.playListArray containsObject:playlistItem])
            {
                [self.playListArray addObject:playlistItem];
                _playListArray = self.playListArray;
            }
            [playlistItem release];
        }

        
        //NSLog(@"LOAD CACHE AFTER %@", self.playListArray);
        
        [playListTable setHidden:NO];
		[spinner stopAnimating];
        [playListTable reloadData];
		
        isLoadingData = NO;
        slowConnectionView.hidden = YES;
        
    }
}

- (void) fetchUserPlaylist
{
	[self.playListArray removeAllObjects];
	
	playListTable.hidden=YES;
	[spinner startAnimating];
    
    //load cache first
    [self loadCacheData];
    
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
    
    
   // NSString * offset = [NSString stringWithFormat:@"%d", (current_page -1) * 10];
    //NSString * limit = @"10";
    
    NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists?_CNAME=%@&&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS],user_now.username,user_now.webPassword];
    NSLog(@"surls--->%@",sURL);
	NSURL *URL=[NSURL URLWithString:sURL];
   NSString *properlyEscapedURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"--->%@",properlyEscapedURL);
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:properlyEscapedURL parameters:Nil];
	 NSLog(@"surls--->%@",request);
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"data playlists: %@", responseObject);
        
        //check store data
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"playlist" inContext:localContext];
        if (!cache){
        
            total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            //NSLog(@"total_page = %d", total_page);
            for (id data in [responseObject objectForKey:@"dataList"])
            {
                PlaylistBrief * playlistItem = [[PlaylistBrief alloc] initWithDictionary:data];
                if (![self.playListArray containsObject:playlistItem])
                {
                    [self.playListArray addObject:playlistItem];
                    _playListArray = self.playListArray;
                }
                [playlistItem release];
            }
            [playListTable setHidden:NO];
            [spinner stopAnimating];
            [playListTable reloadData];
            
            isLoadingData = NO;
            slowConnectionView.hidden = YES;
        }
        
        NSDictionary *responseJSON = [[NSDictionary alloc] initWithDictionary:responseObject];
        
        if(responseJSON.count > 0){
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"playlist" inContext:localContext];
            if (cache) {
                cache.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
            }
            else {
                //save to local db
                PageCacheList *local = [PageCacheList MR_createInContext:localContext];
                local.pageType = @"playlist";
                local.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
            }
            [localContext MR_save];
        }
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			playListTable.hidden=YES;
			[spinner stopAnimating];
			[YRDropdownView showDropdownInView:self.view
										 title:NSLocalizedString(@"Error", nill)
										detail:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										 image:[UIImage imageNamed:@"dropdown-alert"]
									  animated:YES
									 hideAfter:3];

			
		}
        NSLog(@"error: %@", [error description]);
		isLoadingData = NO;
        slowConnectionView.hidden = YES;
	}];
    
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	NSLog(@"Jumlah playlist: %d", [self.playListArray count]);
    return self.playListArray.count;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.playListArray count]))
	{
		return 44;
		[playListTable setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
		CGFloat cellHeight = 54;
		if ([self.currentIndex isEqual:indexPath]) {
			cellHeight = self.expandedCellHeight;
		}
		return cellHeight;
	}
	
	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    playlistTableViewCell * cell = [playListTable dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[playlistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if(indexPath.row % 2==0){
		cell.container.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
	}
	else{
		cell.container.backgroundColor=[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
	}
    PlaylistBrief * currPlaylist = [self.playListArray objectAtIndex:indexPath.row];
    cell.playlistTitle.text = currPlaylist.playlistName;
	//NSString *myString = [NSNumber [currPlaylist.totalSongCount]];
	cell.total_Song.text=[NSString stringWithFormat:@"%d Lagu", [currPlaylist.totalSongCount intValue], nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.edit.hidden=YES;
	cell.edit.tag=indexPath.row;
	cell.delete_.hidden=YES;
	cell.delete_.tag=indexPath.row;
	[cell.delete_ addTarget:self action:@selector(deletePlaylist:) forControlEvents:UIControlEventTouchUpInside];
	[cell.delete_ addTarget:self action:@selector(rename:) forControlEvents:UIControlEventTouchUpInside];

	return cell;
}
-(void)rename:(id)sender{
	message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
										 message:@"Hapus Playlist?"
										delegate:self
							   cancelButtonTitle:@"Ya"
							   otherButtonTitles:nil];
	
	[message addButtonWithTitle:@"Batalkan"];
	[message show];
	
}
-(void)deletePlaylist:(id)sender{
	message = [[UIAlertView alloc] initWithTitle:@"Warning"
													  message:@"Hapus Playlist?"
													 delegate:self
											cancelButtonTitle:@"Ya"
											otherButtonTitles:nil];
	
	[message addButtonWithTitle:@"Batalkan"];
	[message show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"123");
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Ya"])
    {
        NSLog(@"YA");
    }
    else if([title isEqualToString:@"Batalkan"])
    {
        NSLog(@"Batalkan");
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    // get current playlist data.
    PlaylistBrief * cPL = (PlaylistBrief *) [self.playListArray objectAtIndex:indexPath.row];
    TitleBig.hidden=YES;
    detailPlaylistViewController * detailViewController=[[[detailPlaylistViewController alloc]init] autorelease];
    detailViewController.playlistId = cPL.playlistId;
	NSLog(@"cpl-->%@",cPL.playlistId);
    detailViewController.playlistTitle = cPL.playlistName;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{/*
    CGPoint p = [gestureRecognizer locationInView:playListTable];
	   NSIndexPath *indexPath = [playListTable indexPathForRowAtPoint:p];
	playlistTableViewCell *cell = (playlistTableViewCell *)[playListTable cellForRowAtIndexPath:indexPath];
	playlistTableViewCell *lass=(playlistTableViewCell *)[playListTable cellForRowAtIndexPath:self.currentIndex];
 
	NSLog(@"---->%@",self.currentIndex);
	NSLog(@"-indexPath-->%@",indexPath);
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		NSLog(@"UIGestureRecognizerStateEnded");
		//Do Whatever You want on End of Gesture
		//self.currentIndex = indexPath;
		//	self.expandedCellHeight =  200.0f;
		
		
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
		if ([self.currentIndex isEqual:indexPath]){
			NSLog(@"sama kok");
			self.currentIndex = nil;
			self.expandedCellHeight =  54;
			[playListTable beginUpdates];
			[playListTable endUpdates];
			[UIView animateWithDuration:0.3
								  delay:0
								options: UIViewAnimationCurveEaseOut
							 animations:^{
								 cell.edit.hidden=NO;
								 cell.delete_.hidden=NO;
								 cell.edit.frame=CGRectMake(180.5, 20, 34, 34);
								 cell.delete_.frame=CGRectMake(120.5, 20, 34, 34);
								 
							 }
							 completion:^(BOOL finished){
								 NSLog(@"Animation Done!");
								 // cell.twitter.hidden=YES;
								 // cell.facebook.hidden=YES;
								 cell.edit.hidden=YES;
								 cell.delete_.hidden=YES;
								 
							 }];

		}
		//NSLog(@"UIGestureRecognizerStateBegan.");
		else{
			//Do Whatever You want on Began of Gesture
			self.currentIndex = indexPath;
			self.expandedCellHeight =  100;
			[playListTable beginUpdates];
			cell.edit.hidden=YES;
			cell.delete_.hidden=YES;
			lass.edit.hidden=YES;
			lass.delete_.hidden=YES;
			[playListTable endUpdates];
			cell.edit.frame=CGRectMake(180.5, 20, 34, 34);
			cell.delete_.frame=CGRectMake(120.5, 20, 34, 34);
			[UIView animateWithDuration:0.3
								  delay:0
								options: UIViewAnimationCurveEaseOut
							 animations:^{
								 cell.edit.hidden=NO;
								 cell.delete_.hidden=NO;
								 cell.edit.frame=CGRectMake(180.5, 60, 34, 34);
								 cell.delete_.frame=CGRectMake(120.5, 60, 34, 34);
								 
							 }
							 completion:^(BOOL finished){
								 
							 }];
		}

	}
	//make cell with this indexpath  expanded
	
    //this asks tableview to redraw cells
    //actually it invokes reload of cell just if it's height was changed
    //and animates the resize of the cell
  */
}

- (void) loadingTimeUp: (NSTimer *) updateTimer
{
    if (loadTimerisON)
    {
        [loadingDataTimer invalidate];
        loadTimerisON = NO;
    }
    
    if (isLoadingData)
    {
        isLoadingData = NO;     // meskipun tidak sebenarnya dihentikan.
        
        slowConnectionView.hidden = NO;
    }
}

@end
