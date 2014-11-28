//
//  mokletdevHistoryController.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevHistoryController.h"
#import "AFNetworking.h"
#import "songListObject.h"
#import "PageCacheList.h"
#import "netracell_.h"
#import <social/Social.h>
#import <accounts/Accounts.h>
#include "Encryption.h"
#include "GlobalDefine.h"
#import "MelonPlayer.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Twitter/Twitter.h>
#include "StreamingBrief.h"
#import "mokletdevAppDelegate.h"
#import "DownloadList.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "songDownloader.h"
#import "YRDropdownView.h"
#import "localplayer.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"

const int tag_load = 127431123;
bool firstLoad_=0;
bool fetch_=0;
bool search_=0;
bool opened_=0;
bool search_active_=0;
bool already_cache_ = 0;
NSString * bitRateCD_;
NSString * codecTypeCD_;
NSString * contentID_;
NSString * errorCode_;
NSString * fullTrackYN_;
NSString * playtime_;
NSString * sampling_;
NSString * sessionID_;

enum eTableContentType currTableContentType_;
enum eTableContentType lastTableContentType_;

enum eTableContentType {
    NEWRELEASE = 0,
    TOPCHART
};
@interface mokletdevHistoryController ()
{
	songDownloader * _songDownloader;
@private
    songListObject * currentSong_;
}
@end

@implementation mokletdevHistoryController

@synthesize gTunggu = _gTunggu;

int selectedResultIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		
		//UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
		searchView_=[[UIView alloc]initWithFrame:CGRectMake(0, -50, 320, 40)];
		searchView_.backgroundColor=[UIColor blackColor];
		
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
		
		
		downloadHistory=[[UITableView alloc]init];
		downloadHistory.delegate=self;
		downloadHistory.dataSource=self;
		downloadHistory.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[downloadHistory setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		downloadHistory.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		[self.view addSubview:downloadHistory];
		
		currIndex_=-1;
        lastIndex_ = -1;
		
		UITapGestureRecognizer* tapCount_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		tapCount_.numberOfTapsRequired = 2;
		tapCount_.numberOfTouchesRequired = 1;
		[downloadHistory addGestureRecognizer:tapCount_];
		
		//self.titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 142, 24.5)];
		//[self.titleImage setImage:[UIImage imageNamed:@"topChart"]];
		
		//selectedCellIndexPath=[[NSIndexPath alloc]init];
		
		UIImage* image_ = [UIImage imageNamed:@"left"];
		CGRect frame_ = CGRectMake(-5, 0, 44, 44);
		UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame_];
		[leftbutton setBackgroundImage:image_ forState:UIControlStateNormal];
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
		
		
		UIView *RightbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
		RightbuttonView.backgroundColor=[UIColor clearColor];
		[RightbuttonView addSubview:rightbutton];
		
		
		
		UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:RightbuttonView];
		
		
		[self.navigationItem setRightBarButtonItem:rightbarButton];
		[self.navigationItem setLeftBarButtonItem:leftbarbutton];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		
		
		current_page_=1;

		[self.view addSubview:searchView_];
		
		//[searchView addSubview:searchbar];
		
		
        lastTableContentType_ = NEWRELEASE;
		self.netraMutableArray_=[NSMutableArray array];
		top_label_=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 186, 44)];
		top_label_.backgroundColor=[UIColor clearColor];
		TitleBig_=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
		TitleBig_.text=NSLocalizedString(@"Download History",nil);
		TitleBig_.textAlignment=NSTextAlignmentCenter;
		TitleBig_.backgroundColor=[UIColor clearColor];
		[TitleBig_ setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
		TitleBig_.textColor = [UIColor whiteColor];
		TitleBig_.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		TitleBig_.shadowOffset = CGSizeMake(0, 1.0);
		
		
		songNamess_=[[UILabel alloc]initWithFrame:CGRectMake(5, -7, 176, 44)];
		
		songNamess_.backgroundColor=[UIColor clearColor];
		songNamess_.textAlignment=NSTextAlignmentCenter;
		[songNamess_ setFont:[UIFont fontWithName:@"MuseoSans-700" size:16]];
		songNamess_.textColor = [UIColor whiteColor];
		songNamess_.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		songNamess_.shadowOffset = CGSizeMake(0, 1.0);
		songNamess_.hidden=YES;
		
		singerName_=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 186, 44)];
		singerName_.backgroundColor=[UIColor clearColor];
		singerName_.textAlignment=NSTextAlignmentCenter;
		[singerName_ setFont:[UIFont fontWithName:@"OpenSans" size:12]];
		singerName_.textColor = [UIColor whiteColor];
		singerName_.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		singerName_.shadowOffset = CGSizeMake(0, 1.0);
		singerName_.hidden=YES;
		
		[top_label_ addSubview:TitleBig_];
		[top_label_ addSubview:singerName_];
		[top_label_ addSubview:songNamess_];
		
		empty=[[UIView alloc]initWithFrame:CGRectMake(20, ((self.view.frame.size.height-120)/2)-60, 280, 120)];
		empty.backgroundColor=[UIColor clearColor];
		
		empty_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
		empty_title.text=NSLocalizedString(@"Download Empty",nil);
		empty_title.backgroundColor=[UIColor clearColor];
		empty_title.textAlignment=NSTextAlignmentCenter;
		empty_title.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
		[empty_title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
		
		empty_text=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 110)];
		empty_text.text=@"Anda Belum melakukan download sama sekali, silahkan download musik dari server";
		empty_text.numberOfLines=2;
		empty_text.backgroundColor=[UIColor clearColor];
		empty_text.textAlignment=NSTextAlignmentCenter;
		empty_text.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
		[empty_text setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
		
		
		[self.view addSubview:empty];
		[empty addSubview:empty_title];
		[empty addSubview:empty_text];
		
		[empty setHidden:YES];
		
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
		
    }
    return self;
}

- (void) doubleTap: (id) sender
{
    
}

-(void)searchSongs{
	
	searchWindow_=[[[mokletdevSearchMusicController alloc]init] autorelease];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchWindow_];
	
    [self presentModalViewController:navigationController animated:YES];
	
	
}
-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}
-(void)viewWillAppear:(BOOL)animated{
	TitleBig_.hidden=NO;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label_];
    
    self.gTunggu = [[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 160.0)/2, (CGRectGetHeight(self.view.bounds) - 212)/2, 160.0, 106)] autorelease];
    [self.gTunggu setImage:[UIImage imageNamed:@"st"]];
    [self.view addSubview:self.gTunggu];
    self.gTunggu.hidden = YES;
    
    selectedResultIndex = 0;
    
    [self fetchData_];
    
    [self installNotification];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self uninstallNotification];
}

-(void)loadCacheData{
    //check store data
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"download_history" inContext:localContext];
    if (cache){
        total_page_=[[cache.cacheData objectForKey:@"totalSize"]intValue]/10;
        
        //clear song data
        [self.netraMutableArray_ removeAllObjects];
		[downloadHistory reloadData];
        
        //NSLog(@"LOAD CACHE %@", cache.cacheData);
        
        for(id netraDictionary in [cache.cacheData objectForKey:@"dataList"]){
            songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
			if (![self.netraMutableArray_ containsObject:songListObjectData]) {
                [self.netraMutableArray_ addObject:songListObjectData];
				
            }
			
			[songListObjectData release];
		}
        
        //NSLog(@"LOAD CACHE AFTER %@", self.netraMutableArray_);
        
        already_cache_ = 1;
        
        [self removeHud];
        [self loadSomde];
    }
}

-(void)fetchData_{
	_users = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	if(firstLoad_==1){
		downloadHistory.hidden=YES;
		
		[self showHud];
        
        //load cache first
        [self loadCacheData];
	}
    
    NSString * offset = [NSString stringWithFormat:@"%d", (current_page_ -1)];
    
	EUserBrief *usersss=[_users objectAtIndex:0];
	NSString *client=[NSString stringWithFormat:@"iOS Client"];
	NSString *baseUrl=[NSString stringWithFormat:@"%@download/history/all?offset=%@&limit=10&userId=%@&_CNAME=%@&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@",[NSString stringWithUTF8String:MAPI_SERVER],offset,usersss.userId,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS],usersss.username,usersss.webPassword];
	NSLog(@"baseUrl adalah-->%@",baseUrl);
	NSString *properlyEscapedURL = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//  NSString * sURL = [NSString stringWithFormat:@"%@download/history/drm", [NSString stringWithUTF8String:MAPI_SERVER]];
	
	NSURL *URL=[NSURL URLWithString:baseUrl];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    //[httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:properlyEscapedURL parameters:nil];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
    
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject-->%@",responseObject);
        NSInteger offset =[[responseObject objectForKey:@"offset"]intValue];
        
        //check store data
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"download_history" inContext:localContext];
        if (!cache || offset>=10){
            total_page_=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            
            for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
                //NSLog(@"responseObject-->%@",responseObject);
                songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
                if (![self.netraMutableArray_ containsObject:songListObjectData]) {
                    [self.netraMutableArray_ addObject:songListObjectData];
                    
                }
                
                [songListObjectData release];
            }
            
            [self performSelector:@selector(loadSomde) withObject:self afterDelay:2];
		}
        
        NSDictionary *responseJSON = [[NSDictionary alloc] initWithDictionary:responseObject];
       
        if(offset <= 1){
            if(responseJSON.count > 0){
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"download_history" inContext:localContext];
                if (cache) {
                    cache.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
                }
                else {
                    //save to local db
                    PageCacheList *local = [PageCacheList MR_createInContext:localContext];
                    local.pageType = @"download_history";
                    local.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
                }
                [localContext MR_save];
            }
            
            NSLog(@"SAVE TO DB");
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			[YRDropdownView showDropdownInView:self.view
										 title:NSLocalizedString(@"Error", nill)
										detail:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										 image:[UIImage imageNamed:@"dropdown-alert"]
									  animated:YES
									 hideAfter:3];
			[self removeHud];
		}
	}];
    
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
	[operation release];
    
    currTableContentType_ = NEWRELEASE;
	
}

-(void)loadSomde{
	if(self.netraMutableArray_.count==0){
		empty.hidden=NO;
		[self removeHud];
	}
	else{
		[self removeHud];
		//fetch_=1;
		
		firstLoad_=0;
		//[indicator stopAnimating];
		downloadHistory.hidden=NO;
		//[self dismiss];
		
		[downloadHistory reloadData];
	}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if (current_page_ == 0) {
        return 1;
    }
    
    if (current_page_ < total_page_) {
        return self.netraMutableArray_.count + 1;
		
    }
	
    return self.netraMutableArray_.count;
	
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
	
	if (cell.tag == tag_load) {
		
		current_page_+=10;
		[self fetchData_];
		
		
	}
	
}
- (UITableViewCell *)loadingCells {
	
	
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:nil] autorelease];
    cell.userInteractionEnabled = NO;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator release];
    
    [activityIndicator startAnimating];
	cell.tag = tag_load;
	cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row < self.netraMutableArray_.count) {
		
        return [self NetraCellForIndexPath:indexPath];
		
    } else {
		
        return [self loadingCells];
    }
}
- (UITableViewCell *)NetraCellForIndexPath:(NSIndexPath *)indexPath {
	netracell_ *cell       = [downloadHistory dequeueReusableCellWithIdentifier:@"Cell"];
	songListObject *dataObject=[self.netraMutableArray_ objectAtIndex:indexPath.row];
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
    cell.download.tag=indexPath.row;
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	//[cell.share addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
	cell.play.tag=indexPath.row;
	cell.download.tag=indexPath.row;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
    [cell.thumbnail setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
	
	cell.length.text=[NSString stringWithFormat:@"%d : %d", minutes,seconds];
	
	cell.genre.text=dataObject.genreName;
	cell.length.hidden=NO;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.music.hidden=YES;
	cell.genre.hidden=YES;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.playmex.hidden=YES;
	cell.addto_play_list.hidden=YES;
	cell.twitter.tag=indexPath.row;
	//cell.mail.tag=indexPath.row;
	cell.facebook.tag=indexPath.row;
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
	//[cell.mail addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
	/*
	 else if(selectedIndex!=indexPath.row){
	 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^
	 {
	 cell.music_detail.frame=CGRectMake(-310, 0, cell.frame.size.width, cell.frame.size.height);
	 } completion:^(BOOL finished)
	 {
	 [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^
	 {
	 
	 } completion: NULL];
	 }];
	 
	 opened=1;
	 }
	 */
	return cell;
	
	
}

-(void)twitterShare:(id)sender{
	NSInteger i = [sender tag];
	
	songListObject *dataObject=[self.netraMutableArray_ objectAtIndex:i];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://langitmusik.com/album/%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *twitContent=[NSString stringWithFormat:@"#LangitMusik %@ by %@ %@ via LangitMusik for IOS", dataObject.songName, dataObject.artistName,shorturl];
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

-(void)facebookShare:(id)sender{
	NSInteger i = [sender tag];
	
	songListObject *dataObject=[self.netraMutableArray_ objectAtIndex:i];
	//NSString *shortenedURL=[[NSString alloc]init];
	NSString *shorturl= [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=melonindonesia2012&apikey=R_69f312e2046182f9fdc2e57bbdadb46f&longUrl=http://langitmusik.com/album/%@&format=txt",dataObject.albumId]] encoding:NSUTF8StringEncoding error:nil];
	NSString *facebooContent=[NSString stringWithFormat:@"is listening to %@ by %@ %@ via LangitMusik for IOS", dataObject.songName, dataObject.artistName,shorturl];
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
-(void)download:(id)sender
{
    
	NSLog(@"do download");
	/////he kon iku sakjane wes onok user e gak sih?
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	
	
	NSInteger i = [sender tag];
	songListObject * song = [self.netraMutableArray_ objectAtIndex:i];
	
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
                                                detail:@"Pengambilan lagu tak bisa dilakukan. Periksa kembali produk LangitMusik Anda. Pastikan Anda mempunyai paket yang betul."
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


-(void)playMe:(id)sender{
    //NewSongs * songItem = [self.netraMutableArrayResult_ objectAtIndex:[sender tag]];
    songListObject * songItem = [self.netraMutableArray_ objectAtIndex:[sender tag]];
    if (songItem == nil)
    {
        return;
    }
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    [MPlayer stop];
    
    [PlayerLib addToPlaylistofSong:songItem];
    
    players_ = [[mokletdevPlayerViewController alloc]init];
    players_.sSongId     = songItem.songId;
    players_.sSongTitle  = songItem.songName;
	players_.sArtistId   = songItem.artistId;
    players_.sArtistName = songItem.artistName;
	players_.sAlbumId    = songItem.albumId;
    players_.sAlbumName  = songItem.albumName;
	players_.playTime    = songItem.playtime;
    //[self.navigationController pushViewController:players_ animated:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players_];
    [self.navigationController presentModalViewController:navigationController animated:YES];
    [navigationController release];
    [players_ release];
    
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
                [players_ createTimer];
                return;
            }
        }
    }
    
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    //[PlayerLib addToPlaylistofNewSong:songItem];
    
    [MPlayer stop];
    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
    NSURL * songURL = [NSURL fileURLWithPath:songPath];
    
    NSLog(@"songPath: %@.", songPath);
    if ([songPath isEqualToString:@""]) // streaming
    {
        [MPlayer setSongType:0];
        [MPlayer playThisSong:appDelegate.eUserId andSongId:songItem.songId];
    }
    else
    {
        [MPlayer setSongType:1];
        [MPlayer playSongWithURL:songURL];
        [players_ createTimer];
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.netraMutableArray_ count]))
	{
		return 44;
		[downloadHistory setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
		return 153/2;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedResultIndex = indexPath.row;
	//TitleBig_.hidden=YES;

    songListObject * songItem = [self.netraMutableArray_ objectAtIndex:indexPath.row];

    if (songItem == nil)
    {
        return;
    }
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    [MPlayer stop];
    
    [PlayerLib addToPlaylistofSong:songItem];
    
//    players_ = [[mokletdevPlayerViewController alloc]init];
//    players_.sSongId     = songItem.songId;
//    players_.sSongTitle  = songItem.songName;
//	players_.sArtistId   = songItem.artistId;
//    players_.sArtistName = songItem.artistName;
//	players_.sAlbumId    = songItem.albumId;
//    players_.sAlbumName  = songItem.albumName;
//	players_.playTime    = songItem.playtime;
//    //[self.navigationController pushViewController:players_ animated:YES];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players_];
//    [self.navigationController presentModalViewController:navigationController animated:YES];
//    [navigationController release];
//    [players_ release];
    
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
                [players_ createTimer];
                return;
            }
        }
    }
    
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    //[PlayerLib addToPlaylistofSong:songItem];
    
    [MPlayer stop];
    NSString * songPath = [MPlayer checkLocalSong:songItem.songId forUserId:appDelegate.eUserId];
    NSURL * songURL = [NSURL fileURLWithPath:songPath];
    
    NSLog(@"songPath: %@.", songPath);
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
        [players_ createTimer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	firstLoad_=1;
	[self showHud];
	
	
	//tracking google analytics
    self.screenName = NSLocalizedString(@"Screen Name Download History", nil);
}
-(void)showHud{
	NSLog(@"showHud");
	[spinner startAnimating];
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
	[spinner stopAnimating];
    isLoadingData = NO;
    slowConnectionView.hidden = YES;
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
        
        [self removeHud];
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
    
    songListObject * songItem = [self.netraMutableArray_ objectAtIndex:selectedResultIndex];
    top_label_.hidden=NO;
    players_ = [[mokletdevPlayerViewController alloc]init];
    players_.sSongId     = songItem.songId;
    players_.sSongTitle  = songItem.songName;
	players_.sArtistId   = songItem.artistId;
    players_.sArtistName = songItem.artistName;
	players_.sAlbumId    = songItem.albumId;
    players_.sAlbumName  = songItem.albumName;
	players_.playTime    = songItem.playtime;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:players_];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	[players_ release];
    
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
