//
//  MusicListControllerByAlbum.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "MusicListControllerByAlbum.h"
#import "AFNetworking.h"
#import "songListObject.h"
#import "SearchCell.h"
#import "SearchCellSong.h"
#import "MelonPlayer.h"
#import "mokletdevAppDelegate.h"
#include "GlobalDefine.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"
#import "songDownloader.h"
#import "YRDropdownView.h"
#import "DownloadList.h"

#import "localplayer.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "EUserBrief.h"
@interface MusicListControllerByAlbum (){
    songListObject * currentSong;
    songDownloader * _songDownloader;
}

@end

@implementation MusicListControllerByAlbum
static const int kLoadingCellTag2 = 1273;

@synthesize gTunggu = _gTunggu;
@synthesize HeaderTitle;

static int HEADER_TITLE_HEIGHT = 30;

NSString *albumName, *albumId;

int selectedResultIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
		//self.title=@"Search Song";
		self.view.backgroundColor=[UIColor whiteColor];
        
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
		[spinner startAnimating];
        
		searchResult=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
		searchResult.delegate=self;
		searchResult.tableFooterView = [[[UIView alloc] init] autorelease];
		searchResult.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
		searchResult.dataSource=self;
		searchResult.separatorColor=[UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
		
		searchbarContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
		searchbarContainer.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbar"]];
		UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(40, 0, 5, 20)] autorelease];
		
		searchForm=[[UITextField alloc]initWithFrame:CGRectMake(30, 7, 280, 30)];
		searchForm.backgroundColor=[UIColor clearColor];
		searchForm.layer.sublayerTransform = CATransform3DMakeTranslation(5, 3, 0);
		searchForm.leftViewMode = UITextFieldViewModeAlways;
		searchForm.leftView = paddingView;
		searchForm.placeholder=NSLocalizedString(@"Search Song", nil);
		searchForm.delegate=self;
		searchForm.clearButtonMode = UITextFieldViewModeWhileEditing;
		
		searchForm.autocorrectionType=UITextAutocorrectionTypeNo;
		searchForm.leftViewMode = UITextFieldViewModeAlways;
		searchForm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[searchForm setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
		searchForm.textColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1] ;
		searchForm.returnKeyType=UIReturnKeyDone;
		[searchbarContainer addSubview:searchForm];
		
		[searchForm becomeFirstResponder];
		
		//[searchBar setBackgroundImage:[UIImage new]];
		//[searchBar setTranslucent:YES];
        
        //header title song
        HeaderTitle=[[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADER_TITLE_HEIGHT)];
        HeaderTitle.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"common-navbar1"]];//[UIColor colorWithRed:236.0/255 green:9.0/255 blue:142.0/255 alpha:1];
        HeaderTitle.textColor=[UIColor whiteColor];
        HeaderTitle.text = NSLocalizedString(@"Album", nil);
        [HeaderTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        
        HeaderTitle.topInset = 10;
        HeaderTitle.leftInset = 15;
        HeaderTitle.bottomInset = 10;
        HeaderTitle.rightInset = 15;
		
		//searchResult.tableHeaderView=searchbarContainer;
        searchResult.tableHeaderView=HeaderTitle;
		top_label=[[UIView alloc]initWithFrame:CGRectMake(40, 0, 186, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
		TitleBig.text=NSLocalizedString(@"Album", nil);
		TitleBig.textAlignment=NSTextAlignmentCenter;
		TitleBig.backgroundColor=[UIColor clearColor];
		[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
		TitleBig.textColor = [UIColor whiteColor];
		TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		TitleBig.shadowOffset = CGSizeMake(0, 1.0);
		
		self.netraMutableArray=[[NSMutableArray alloc]init];
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
		
		
		//[self.navigationItem setRightBarButtonItem:rightbarButton];
		//[self.navigationItem setLeftBarButtonItem:leftbarbutton];
        
        //change back button image
        backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)] autorelease];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
        
        //UIBarButtonItem * searchButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
        
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"]  forBarMetrics:UIBarMetricsDefault];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		
		[top_label addSubview:TitleBig];
        
        selectedResultIndex = 0;
        
		[self.view addSubview:searchResult];
        [self.view addSubview:spinner];
    }
	
    return self;
}
-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"] forBarMetrics:UIBarMetricsDefault];
}

-(void)setAlbumName:(NSString *)currAlbumName{
    albumName = currAlbumName;
}

-(void)setAlbumId:(NSString *)currAlbumId{
    albumId = currAlbumId;
}

-(void)getSuggest:(NSString *)KeyWords{
	//NSLog(@"called");
	
	NSString *baseUrl=[NSString stringWithFormat:@"%@songs?albumId=%@&_DIR=c&_CNAME=%@&_CPASS=%@&limit=50", [NSString stringWithUTF8String:MAPI_SERVER],KeyWords,[NSString stringWithUTF8String:CNAME], [NSString stringWithUTF8String:CPASS]];
	NSString* escapedUrl = [baseUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL=[NSURL URLWithString:escapedUrl];
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	NSLog(@"request-->%@",URL);
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //clear song data
        [self.netraMutableArray removeAllObjects];
		[searchResult reloadData];
        
		total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
		for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
			
			songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
			if (![self.netraMutableArray containsObject:songListObjectData]) {
                [self.netraMutableArray addObject:songListObjectData];
				
            }
			
			[songListObjectData release];
		}
		
		//fetch=1;
		//firstLoad=0;
		//MelonList.hidden=NO;
		//[self dismiss];
		[searchResult setHidden:NO];
		[searchResult reloadData];
        
        [spinner stopAnimating];
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			
			[searchResult setHidden:YES];
            
            [spinner stopAnimating];
		}
		
	}];
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
	[operation release];
	
}

-(void)close{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    HeaderTitle.text=albumName;
	TitleBig.hidden=NO;
	[self.navigationController.navigationBar addSubview:top_label];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1"]  forBarMetrics:UIBarMetricsDefault];
	animated=YES;
    
    self.gTunggu = [[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 160.0)/2, (CGRectGetHeight(self.view.bounds) - 212)/2, 160.0, 106)] autorelease];
    [self.gTunggu setImage:[UIImage imageNamed:@"st"]];
    [self.view addSubview:self.gTunggu];
    self.gTunggu.hidden = YES;
    
    
    [self installNotification];
    
    [self getSuggest:albumId];
    
    //tracking google analytics
    self.screenName = [NSString stringWithFormat:NSLocalizedString(@"Screen Name Album", nil), albumName];
	
}
-(void)viewWillDisappear:(BOOL)animated{
	//self.title=@"music player";
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_lain"] forBarMetrics:UIBarMetricsDefault];
	//animated=YES;
    TitleBig.hidden=YES;
    [self uninstallNotification];
}

-(void)viewDidLoad{
	[super viewDidLoad];
    
    [spinner startAnimating];
    
    //tracking google analytics (Move to viewWillAppear because couldn't get albumName)
    //self.screenName = [NSString stringWithFormat:NSLocalizedString(@"Screen Name Album", nil), albumName];
	
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newString = [searchForm.text stringByReplacingCharactersInRange:range withString:string];
	if(searchForm.text.length>1){
		[self.netraMutableArray removeAllObjects];
		[self getSuggest:newString];
	}
	
	NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
		
		[self.netraMutableArray removeAllObjects];
		//[[self loadingCell] removeFromSuperview];
		[searchResult reloadData];
    }
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldBeginEditing");
	// _field.background = [UIImage imageNamed:@"focus.png"];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldEndEditing");
	
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
	[self.netraMutableArray removeAllObjects];
	[searchResult reloadData];
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchForm resignFirstResponder];
    return YES;
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
    
    return self.netraMutableArray.count;
	
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
	
	if (cell.tag == kLoadingCellTag2) {
		NSLog(@"kLoadingCellTag");
		current_page+=10;
		//[self fetchData];
		
		
	}
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	TitleBig.hidden=NO;
    selectedResultIndex = indexPath.row;
	songListObject * songItem = [self.netraMutableArray objectAtIndex:indexPath.row];
    if (songItem == nil)
    {
        return;
    }
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    //    top_label.hidden=NO;
    //    players = [[mokletdevPlayerViewController alloc]init];
    //    players.sSongId     = songItem.songId;
    //    players.sSongTitle  = songItem.songName;
    //	players.sArtistId   = songItem.artistId;
    //    players.sArtistName = songItem.artistName;
    //	players.sAlbumId    = songItem.albumId;
    //    players.sAlbumName  = songItem.albumName;
    //	players.playTime    = songItem.playtime;
    //	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players];
    //	[self.navigationController presentModalViewController:navigationController animated:YES];
    //	[navigationController release];
    //	[players release];
    
    // check current playing song.
    
    if ([appDelegate.nowPlayingPlaylistDefault count] > 0)
    {
        LocalPlaylist1 * npSong = [[LocalPlaylist1 alloc] init];
        npSong = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
        
        NSLog(@"npSong.songId - songItem.songId : %@ - %@.", npSong.songId, songItem.songId);
        if ([npSong.songId isEqualToString:songItem.songId])
        {
            if ([MPlayer isPlaying])
            {
                if (![MPlayer isPaused])
                {
                    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
                    //[MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
                    [MPlayer periksaLagudanStream:songItem.songId];
                    [players createTimer];
                    return;
                }
                
                [players createTimer];
                return;
            }
        }
    }
    
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    [PlayerLib addToPlaylistofSong:songItem];
    
    [MPlayer stop];
    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
    NSURL * songURL = [NSURL fileURLWithPath:songPath];
    
    if ([songPath isEqualToString:@""]) // streaming
    {
        [MPlayer setSongType:0];
        //[MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
        [MPlayer periksaLagudanStream:songItem.songId];
    }
    else
    {
        [MPlayer setSongType:1];
        [MPlayer playSongWithURL:songURL];
        [players createTimer];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SearchCellSong *cell       = [searchResult dequeueReusableCellWithIdentifier:@"Cell"];
	songListObject *dataObject=[self.netraMutableArray objectAtIndex:indexPath.row];
	if (cell == nil)
	{
		cell= [[SearchCellSong alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
		//cell=[[[NetraCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ]autorelease];
	}
	UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
	myBackView.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
	cell.selectedBackgroundView = myBackView;
	[myBackView release];
	cell.SongTitle.text=dataObject.songName;
	cell.Singer.text=dataObject.artistName;
    [cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    cell.download.tag=indexPath.row;
	//cell.detailTextLabel.highlightedTextColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1];
	//cell.detailTextLabel.text=dataObject.albumName;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
	
    [cell.image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
	
	
	return cell;
	
	
}

/*
 - (UITableViewCell *)loadingCell {
 UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
 reuseIdentifier:nil] autorelease];
 
 cell.userInteractionEnabled = NO;
 UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 // activityIndicator.center = cell.center;
 // [cell addSubview:activityIndicator];
 [activityIndicator release];
 
 // [activityIndicator startAnimating];
 cell.tag = kLoadingCellTag2;
 
 return cell;
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 75;
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
    
    songListObject * songItem = [self.netraMutableArray objectAtIndex:selectedResultIndex];
    top_label.hidden=NO;
    players = [[mokletdevPlayerViewController alloc]init];
    players.sSongId     = songItem.songId;
    players.sSongTitle  = songItem.songName;
	players.sArtistId   = songItem.artistId;
    players.sArtistName = songItem.artistName;
	players.sAlbumId    = songItem.albumId;
    players.sAlbumName  = songItem.albumName;
	players.playTime    = songItem.playtime;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	[players release];
    
    self.gTunggu.hidden = YES;
}

-(void)download:(id)sender
{
    
	NSLog(@"do download");
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	
	
	NSInteger i = [sender tag];
	songListObject * song = [self.netraMutableArray objectAtIndex:i];
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	if([users_active count]>0){
		EUserBrief *usersss=[users_active objectAtIndex:0];
        
        // periksa layanan
        mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
        if (appDelegate.isGetLayanan)
        {
            NSMutableArray * lyn = [NSMutableArray arrayWithArray:[Layanan MR_findAll]];
            if ([lyn count] > 0)
            {
                Layanan * eLayanan = (Layanan *) [lyn objectAtIndex:0];
                if ([eLayanan.paymentProdName isEqualToString:@""])
                {
                    [YRDropdownView showDropdownInView:self.view
                                                 title:NSLocalizedString(@"Error", nill)
                                                detail:@"Pengambilan lagu tak bisa dilakukan. Periksa kembali produk MelOn Anda. Pastikan Anda mempunyai paket yang betul."
                                                 image:[UIImage imageNamed:@"dropdown-alert_error"]
                     //backgroundImage:[UIImage imageNamed:@"allow"]
                                              animated:YES
                                             hideAfter:3];
                    return;
                }
            }
        }
		
		LocalPlaylist *musicFound = [LocalPlaylist MR_findFirstByAttribute:@"songId" withValue:[NSString stringWithFormat:@"%@-%@",usersss.userId,song.songId]];
		if (!musicFound){
			NSLog(@"musicFound---->%@",musicFound.songId);
			DownloadList *musicQ = [DownloadList MR_findFirstByAttribute:@"songId" withValue:song.songId];
			if (!musicQ){
				NSLog(@"songF---->%@",musicQ.songId);
				
				[YRDropdownView showDropdownInView:self.view
											 title:@"Informasi"
											detail:@"Musik Sedang Di tambahkan ke Antrian"
											 image:[UIImage imageNamed:@"dropdown-alert_success"]
								   backgroundImage:[UIImage imageNamed:@"allow"]
										  animated:YES
										 hideAfter:3];
				
				
				DownloadList *local = [DownloadList MR_createInContext:localContext];
				local.tanggal=[NSDate date];
				local.songId = song.songId;
				local.songTitle = song.songName;
				local.artistId = [NSString stringWithFormat:@"%@", song.artistId];
				local.artistName = song.artistName;
				local.albumId = [NSString stringWithFormat:@"%@", song.albumId];
				local.albumName = song.albumName;
				local.downId = @"";
				local.userId = [NSString stringWithFormat:@"%@", usersss.userId];
				local.tanggal = [NSDate date];
				local.finished = [NSNumber numberWithInt:0];
				local.playTime = [NSString stringWithFormat:@"%@", song.playtime];
				local.status = [NSNumber numberWithInt:0];
				
				
				[localContext MR_save];
				
				_songDownloader = [songDownloader sharedInstance];
				[_songDownloader doDownload:song.songId userid:usersss.userId password:usersss.webPassword email:usersss.email];
				
			}
			else{
				[YRDropdownView showDropdownInView:self.view
											 title:NSLocalizedString(@"Error", nill)
											detail:@"Musik Sudah Di tambahkan ke Antrian"
											 image:[UIImage imageNamed:@"dropdown-alert_warning"]
								   backgroundImage:[UIImage imageNamed:@"warning"]
										  animated:YES
										 hideAfter:3];
			}
			
		}
		else{
			[YRDropdownView showDropdownInView:self.view
										 title:NSLocalizedString(@"Error", nill)
										detail:@"Musik Sudah ada di Handset Anda"
										 image:[UIImage imageNamed:@"dropdown-alert_error"]
									  animated:YES
									 hideAfter:3];
		}
		
	}
	else{
		[YRDropdownView showDropdownInView:self.view
									 title:NSLocalizedString(@"Error", nill)
									detail:@"Silahkan login terlebih dahulu untuk dapat mengambil lagu."
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
	}
	
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