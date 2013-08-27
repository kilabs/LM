//
//  topChartViewController.m
//  melon
//
//  Created by Arie on 3/30/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "topChartViewController.h"
#import <CommonCrypto/CommonCrypto.h>

#import "AFNetworking.h"
#import "songListObject.h"
#import <Twitter/Twitter.h>
#import <social/Social.h>
#import <accounts/Accounts.h>
#include "Encryption.h"
#include "GlobalDefine.h"
#import "MelonPlayer.h"
#import "songListObject.h"
#import "mokletdevAppDelegate.h"
#import "DownloadList.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "YRDropdownView.h"
#import "localplayer.h"
#import "songListObject.h"
#import "netracell_.h"
#import "PlaylistBrief.h"
@interface topChartViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContex;

@end

@implementation topChartViewController
{
@private
    //songListObject * currentSong;
    songListObject * currentSong;
    songDownloader * _songDownloader;
	
}

int selectedResultIndex;
@synthesize gTunggu = _gTunggu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.netraMutableArrayPlaylist=[[NSMutableArray alloc]init];
		
		spinnerss = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
		spinnerss.hidesWhenStopped = YES;
		[spinnerss setColor:[UIColor colorWithRed:0.478 green:0.651 blue:0.176 alpha:1]];
		[spinnerss setInnerRadius:10];
		[spinnerss setOuterRadius:20];
		[spinnerss setStrokeWidth:8];
		[spinnerss setCenter:CGPointMake(160.0,180.0)];
		[spinnerss setNumberOfStrokes:8];
		[spinnerss setPatternLineCap:kCGLineCapButt];
		[spinnerss setPatternStyle:TJActivityIndicatorPatternStyleBox];
		[self.view addSubview:spinnerss];
		self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
	
        // Custom initialization
		tableChart=[[UITableView alloc]init];
		tableChart.delegate=self;
		tableChart.dataSource=self;
		tableChart.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[tableChart setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		tableChart.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		tableChart.hidden=YES;
		[self.view addSubview:tableChart];
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
		
		
		[self.navigationItem setRightBarButtonItem:rightbarButton];
		[self.navigationItem setLeftBarButtonItem:leftbarbutton];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		
		self.netraMutableArray=[NSMutableArray array];
		top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 186, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		
		TitleBig=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
		TitleBig.text=@"Top Chart";
		TitleBig.textAlignment=NSTextAlignmentCenter;
		TitleBig.backgroundColor=[UIColor clearColor];
		[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
		TitleBig.textColor = [UIColor whiteColor];
		TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		TitleBig.shadowOffset = CGSizeMake(0, 1.0);
		TitleBig.hidden=NO;
		songNamess=[[UILabel alloc]initWithFrame:CGRectMake(5, -7, 176, 44)];
		
		songNamess.backgroundColor=[UIColor clearColor];
		songNamess.textAlignment=NSTextAlignmentCenter;
		[songNamess setFont:[UIFont fontWithName:@"MuseoSans-700" size:16]];
		songNamess.textColor = [UIColor whiteColor];
		songNamess.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		songNamess.shadowOffset = CGSizeMake(0, 1.0);
		songNamess.hidden=YES;
		
		singerName=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 186, 44)];
		singerName.backgroundColor=[UIColor clearColor];
		singerName.textAlignment=NSTextAlignmentCenter;
		[singerName setFont:[UIFont fontWithName:@"OpenSans" size:12]];
		singerName.textColor = [UIColor whiteColor];
		singerName.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		singerName.shadowOffset = CGSizeMake(0, 1.0);
		singerName.hidden=YES;
		
		[top_label addSubview:TitleBig];
		[top_label addSubview:singerName];
		[top_label addSubview:songNamess];
	
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
        
        loadTimerisON = NO;
		
		
    }
    return self;
}
-(void)facebookShare:(id)sender{
	NSInteger i = [sender tag];
	
	//songListObject *dataObject=[self.netraMutableArray objectAtIndex:i];
    songListObject *dataObject=[self.netraMutableArray objectAtIndex:i];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *facebooContent=[NSString stringWithFormat:@"is listening to %@ by %@ %@ via MelOn for IOS", dataObject.songName, dataObject.artistName,shorturl];
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
	NSInteger i = [sender tag];
	
	//songListObject *dataObject=[self.netraMutableArray objectAtIndex:i];
    songListObject *dataObject=[self.netraMutableArray objectAtIndex:i];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://melon.co.id/album/detail.do?albumId=%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *twitContent=[NSString stringWithFormat:@"#MelOnPlaying %@ by %@ %@ via MelOn for IOS", dataObject.songName, dataObject.artistName,shorturl];
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
-(void)fetchChart{
	[self showHud];
	tableChart.hidden=YES;
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/songs/new?offset=%d&limit=10",current_page];
	NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily"];
	
	NSURL *URL=[NSURL URLWithString:baseUrl];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    //[httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:baseUrl parameters:nil];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		//total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
		//NSLog(@"responseObject--.%@",[responseObject description]);
        
        currentSongId = @"0";
		for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
			//songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
            songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
			if (![self.netraMutableArray containsObject:songListObjectData]) {
                [self.netraMutableArray addObject:songListObjectData];
				
            }
			[songListObjectData release];
		}
		[self performSelector:@selector(reloadData) withObject:nil afterDelay:5];
		
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
            slowConnectionView.hidden = YES;
			[YRDropdownView showDropdownInView:self.view
										 title:@"Galat"
										detail:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										 image:[UIImage imageNamed:@"dropdown-alert"]
									  animated:YES
									 hideAfter:3];
			[self removeHud];
		}
		
	}];
    
	[operation start];
	[operation release];
    
    //currTableContentType = NEWRELEASE;
	
	
}
-(void)reloadData{
	//[self removeHud];
	[tableChart setHidden:NO];
	[tableChart reloadData];
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	//NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	if([users_active count]>0){
		EUserBrief *usersss=[users_active objectAtIndex:0];
		[self loadPlaylist:usersss.userId pass:usersss.webPassword username:usersss.username];
	}
    
    slowConnectionView.hidden = YES;
}
///tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    return self.netraMutableArray.count;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	netracell_ *cell       = [tableChart dequeueReusableCellWithIdentifier:@"Cell"];
	//songListObject *dataObject=[self.netraMutableArray objectAtIndex:indexPath.row];
    songListObject *dataObject=[self.netraMutableArray objectAtIndex:indexPath.row];
	if (cell == nil)
	{
		cell= [[netracell_ alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
		//cell=[[[NetraCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ]autorelease];
	}
	if(indexPath.row % 2==0){
		cell.container.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
	}
	else{
		cell.container.backgroundColor=[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
	}
	int seconds = [dataObject.playtime intValue] % 60;
	int minutes = ([dataObject.playtime intValue] - seconds) / 60;
	cell.title.text=dataObject.songName;
	cell.excerpt.text=dataObject.artistName;
	cell.albumName.text = dataObject.albumName;
	[cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	//[cell.share addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
	cell.play.tag=indexPath.row;
	cell.download.tag=indexPath.row;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
	[cell.thumbnail setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];
	
	cell.length.text=[NSString stringWithFormat:@"%d : %d", minutes,seconds];
	
	//cell.genre.text=dataObject.genreName;
	cell.length.hidden=NO;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.music.hidden=YES;
	cell.genre.hidden=YES;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.playmex.hidden=YES;
	cell.addto_play_list.hidden=YES;
	cell.twitter.tag=indexPath.row;
	cell.facebook.tag=indexPath.row;
	cell.playmex.tag=indexPath.row;
	
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
	cell.addto_play_list.tag=indexPath.row;
	[cell.addto_play_list addTarget:self action:@selector(addtoPlaylist:) forControlEvents:UIControlEventTouchUpInside];
	[cell.playmex addTarget:self action:@selector(playMeHere:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
	
	
}
-(void)addtoPlaylist:(id)sender{
	songListObject * song = [self.netraMutableArray objectAtIndex:[sender tag]];
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
			[self postPlaylist:song.songId playlistId:b.playlistId playlistName:selectedValue songName:song.songName];
			
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
			NSLog(@"responseobject--->%@",responseObject);
        }
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
		}
        NSLog(@"error: %@", [error description]);
		
	}];
    
	[operation start];
    [httpClient release];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(self.currentIndex !=nil){
		netracell_ *cell = (netracell_ *)[tableChart cellForRowAtIndexPath:self.currentIndex];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.netraMutableArray count]))
	{
		return 44;
		[tableChart setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
		CGFloat cellHeight = 153/2;
		if ([self.currentIndex isEqual:indexPath]) {
			cellHeight = self.expandedCellHeight;
		}
		return cellHeight;
	}
	
	
}
-(void)playMeHere:(id)sender
{
    songListObject * songItem = [self.netraMutableArray objectAtIndex:[sender tag]];
    if (songItem == nil)
    {
        return;
    }

    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    
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
                [MPlayer pause];
            }
            else
            {
                if (![MPlayer isPaused])
                {
                    if (![MPlayer isGettingNewSong])
                    {
                        [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
                        [MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
                    }
                }
                else
                {
                    [MPlayer play];
                }
            }
            return;
        }
    }
    
    if ([MPlayer isGettingNewSong])
    {
        return;
    }
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    [PlayerLib addToPlaylistofTopChart:songItem];
    
    [MPlayer stop];
    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
    NSURL * songURL = [NSURL fileURLWithPath:songPath];
    NSLog(@"Play song: %@ - %@", songItem.songId, appDelegate.eUserId);
    if ([songPath isEqualToString:@""]) // streaming
    {
        [MPlayer setSongType:0];
        [MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
    }
    else
    {
        [MPlayer setSongType:1];
        [MPlayer playSongWithURL:songURL];
    }
}

-(void)playMe:(id)sender
{
	
	
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    netracell_ *cell = (netracell_ *)[tableChart cellForRowAtIndexPath:indexPath];
    netracell_ *lass=(netracell_ *)[tableChart cellForRowAtIndexPath:self.currentIndex];
	
    if ([self.currentIndex isEqual:indexPath]){
        cell.twitter.hidden=YES;
        NSLog(@"sama kok");
        self.currentIndex = nil;
        self.expandedCellHeight =  153/2;
        [tableChart beginUpdates];
        [tableChart endUpdates];
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
        [tableChart beginUpdates];
        cell.twitter.hidden=YES;
        cell.playmex.hidden=YES;
        cell.facebook.hidden=YES;
        cell.addto_play_list.hidden=YES;
        
        
        lass.twitter.hidden=YES;
        lass.facebook.hidden=YES;
        lass.playmex.hidden=YES;
        lass.addto_play_list.hidden=YES;
        
        [tableChart endUpdates];
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
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedResultIndex = indexPath.row;
	songListObject * songItem = [self.netraMutableArray objectAtIndex:indexPath.row];
	
	if (songItem == nil)
	{
		return;
	}
//	top_label.hidden=YES;
//	players = [[mokletdevPlayerViewController alloc]init];
//	players.sSongId     = songItem.songId;
//	players.sSongTitle  = songItem.songName;
//	players.sArtistId   = songItem.artistId;
//	players.sArtistName = songItem.artistName;
//	players.sAlbumId    = songItem.albumId;
//	players.sAlbumName  = songItem.albumName;
//	players.playTime    = songItem.playtime;
//	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players];
//	[self.navigationController presentModalViewController:navigationController animated:YES];
//	[navigationController release];
//	[players release];
	
	
	
	
	
	mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
	MPlayer = [MelonPlayer sharedInstance];
	
	
	// check current playing song.
	
	if ([appDelegate.nowPlayingPlaylistDefault count] > 0)
	{
		LocalPlaylist1 * npSong = [[LocalPlaylist1 alloc] init];
		npSong = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
		
		NSLog(@"npSong.songId - songItem.songId : %@ - %@.", npSong.songId, songItem.songId);
		if ([npSong.songId isEqualToString:songItem.songId])
		{
			if (![MPlayer isPaused])
			{
				[MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
				//[MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
                [MPlayer periksaLagudanStream:songItem.songId];
				[players createTimer];
				return;
			}
			
			if ([MPlayer isPlaying])
			{
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

-(void)viewWillAppear:(BOOL)animated{
	[TitleBig setHidden:NO];
	top_label.hidden=NO;
	[self.navigationController.navigationBar addSubview:top_label];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self fetchChart];
    top_label.hidden = NO;
	TitleBig.hidden=NO;
	// Do any additional setup after loading the view.
}

-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}

-(void)searchSongs{
	
	searchWindow=[[mokletdevSearchMusicController alloc]init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchWindow];
	
    [self presentModalViewController:navigationController animated:YES];
	
	
}

-(void)download:(id)sender
{
    
	NSLog(@"do download");
	/////he kon iku sakjane wes onok user e gak sih?
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	
	
	NSInteger i = [sender tag];
	songListObject * song = [self.netraMutableArray objectAtIndex:i];
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	if([users_active count]>0){
		EUserBrief *usersss=[users_active objectAtIndex:0];
		LocalPlaylist *musicFound = [LocalPlaylist MR_findFirstByAttribute:@"songId" withValue:[NSString stringWithFormat:@"%@-%@",usersss.userId,song.songId]];
        
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
                                                 title:@"Galat"
                                                detail:@"Pengambilan lagu tak bisa dilakukan. Periksa kembali produk MelOn Anda. Pastikan Anda mempunyai paket yang betul."
                                                 image:[UIImage imageNamed:@"dropdown-alert_error"]
                     //backgroundImage:[UIImage imageNamed:@"allow"]
                                              animated:YES
                                             hideAfter:3];
                    return;
                }
            }
        }
        
		if (!musicFound){
			DownloadList *musicQ = [DownloadList MR_findFirstByAttribute:@"songId" withValue:song.songId];
			if (!musicQ){
				
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
				local.status = [NSNumber numberWithInt:1];
				
				
				//[localContext MR_save];
				_songDownloader = [songDownloader sharedInstance];
				[_songDownloader doDownload:song.songId userid:usersss.userId password:usersss.webPassword email:usersss.email];
				
			}
			else{
				[YRDropdownView showDropdownInView:self.view
											 title:@"Galat"
											detail:@"Musik Sudah Di tambahkan ke Antrian"
											 image:[UIImage imageNamed:@"dropdown-alert_warning"]
								   backgroundImage:[UIImage imageNamed:@"warning"]
										  animated:YES
										 hideAfter:3];
			}
			
		}
		else{
			[YRDropdownView showDropdownInView:self.view
										 title:@"Galat"
										detail:@"Musik Sudah ada di Handset Anda"
										 image:[UIImage imageNamed:@"dropdown-alert_error"]
									  animated:YES
									 hideAfter:3];
		}
		
	}
	else{
		[YRDropdownView showDropdownInView:self.view
									 title:@"Galat"
									detail:@"Silahkan login terlebih dahulu untuk dapat mengambil lagu."
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
	}
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showHud{
	NSLog(@"showHud");
	[spinnerss startAnimating];
    
    isLoadingData = YES;
    loadingDataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(loadingTimeUp:)
                                                      userInfo:nil
                                                       repeats:YES];
    loadTimerisON = YES;
}
-(void)removeHud{
	NSLog(@"removeHud");
	[spinnerss stopAnimating];
    slowConnectionView.hidden = YES;
    isLoadingData = NO;
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
        
        [spinnerss stopAnimating];
        slowConnectionView.hidden = NO;
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
