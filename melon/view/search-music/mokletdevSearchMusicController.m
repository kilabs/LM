//
//  mokletdevSearchMusicController.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevSearchMusicController.h"
#import "MusicListControllerByAlbum.h"
#import "AlbumListControllerByArtist.h"
#import "AFNetworking.h"
#import "songListObject.h"
#import "albumListObject.h"
#import "artistListObject.h"
#import "SearchCell.h"
#import "SearchCellSong.h"
#import "MelonPlayer.h"
#import "mokletdevAppDelegate.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"
#import "songDownloader.h"
#import "YRDropdownView.h"
#import "DownloadList.h"

#import "localplayer.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "EUserBrief.h"
#import "GlobalDefine.h"
@interface mokletdevSearchMusicController (){
    songListObject * currentSong;
    albumListObject * currentAlbum;
    songDownloader * _songDownloader;
}

@end

@implementation mokletdevSearchMusicController
static const int kLoadingCellTag2 = 1273;

@synthesize gTunggu = _gTunggu;
@synthesize HeaderTitle;
@synthesize HeaderTitleAlbum;
@synthesize HeaderTitleArtist;
@synthesize scrollView;

int selectedResultIndex;

int songTableHeight = 0, albumTableHeight = 0, artistTableHeight = 0;

static int SONG_ROW_HEIGHT = 75;
static int ALBUM_ROW_HEIGHT = 75;
static int ARTIST_ROW_HEIGHT = 75;
static int HEADER_TITLE_HEIGHT = 30;

static int RECORD_LIMIT = 10;

NSOperationQueue *operationQueueSong, *operationQueueAlbum, *operationQueueArtist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		//self.title=@"Search Song";
		self.view.backgroundColor=[UIColor whiteColor];
        
        songTableHeight = albumTableHeight = artistTableHeight = HEADER_TITLE_HEIGHT;
        
        //init scrollview
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
        scrollView.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
        
        //init song tableview
		searchResult=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-94)];
		searchResult.delegate=self;
		searchResult.tableFooterView = [[[UIView alloc] init] autorelease];
		searchResult.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
		searchResult.dataSource=self;
		searchResult.separatorColor=[UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
        
        //init album tableview
        searchResultAlbum=[[UITableView alloc]initWithFrame:CGRectMake(0, 35, self.view.bounds.size.width, self.view.bounds.size.height-94)];
		searchResultAlbum.delegate=self;
		searchResultAlbum.tableFooterView = [[[UIView alloc] init] autorelease];
		searchResultAlbum.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
		searchResultAlbum.dataSource=self;
		searchResultAlbum.separatorColor=[UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
        
        //init artist tableview
        searchResultArtist=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height-94)];
		searchResultArtist.delegate=self;
		searchResultArtist.tableFooterView = [[[UIView alloc] init] autorelease];
		searchResultArtist.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
		searchResultArtist.dataSource=self;
		searchResultArtist.separatorColor=[UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
		
        //init search form
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
        
        [self.view addSubview:searchbarContainer];
        
        //header title song
        HeaderTitle=[[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADER_TITLE_HEIGHT)];
        HeaderTitle.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"common-navbar1"]];//[UIColor colorWithRed:236.0/255 green:9.0/255 blue:142.0/255 alpha:1];
        HeaderTitle.textColor=[UIColor whiteColor];
        HeaderTitle.text = NSLocalizedString(@"Song", nil);
        [HeaderTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        
        HeaderTitle.topInset = 10;
        HeaderTitle.leftInset = 15;
        HeaderTitle.bottomInset = 10;
        HeaderTitle.rightInset = 15;
        
        //header album title
        HeaderTitleAlbum=[[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADER_TITLE_HEIGHT)];
        HeaderTitleAlbum.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"common-navbar1"]];//[UIColor colorWithRed:236.0/255 green:9.0/255 blue:142.0/255 alpha:1];
        HeaderTitleAlbum.textColor=[UIColor whiteColor];
        HeaderTitleAlbum.text = NSLocalizedString(@"Album", nil);
        [HeaderTitleAlbum setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        
        HeaderTitleAlbum.topInset = 10;
        HeaderTitleAlbum.leftInset = 15;
        HeaderTitleAlbum.bottomInset = 10;
        HeaderTitleAlbum.rightInset = 15;
        
        //header artist title
        HeaderTitleArtist=[[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADER_TITLE_HEIGHT)];
        HeaderTitleArtist.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"common-navbar1"]];//[UIColor colorWithRed:236.0/255 green:9.0/255 blue:142.0/255 alpha:1];
        HeaderTitleArtist.textColor=[UIColor whiteColor];
        HeaderTitleArtist.text = NSLocalizedString(@"Artist", nil);
        [HeaderTitleArtist setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        
        HeaderTitleArtist.topInset = 10;
        HeaderTitleArtist.leftInset = 15;
        HeaderTitleArtist.bottomInset = 10;
        HeaderTitleArtist.rightInset = 15;
		
		//searchResult.tableHeaderView=searchbarContainer;
        searchResult.tableHeaderView=HeaderTitle;
        searchResultAlbum.tableHeaderView=HeaderTitleAlbum;
        searchResultArtist.tableHeaderView=HeaderTitleArtist;
        
		top_label=[[UIView alloc]initWithFrame:CGRectMake(40, 0, 186, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
		TitleBig.text=NSLocalizedString(@"Search Song", nil);
		TitleBig.textAlignment=NSTextAlignmentCenter;
		TitleBig.backgroundColor=[UIColor clearColor];
		[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
		TitleBig.textColor = [UIColor whiteColor];
		TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		TitleBig.shadowOffset = CGSizeMake(0, 1.0);
		
		self.netraMutableArray=[[NSMutableArray alloc]init];
        self.netraMutableAlbumArray=[[NSMutableArray alloc]init];
        self.netraMutableArtistArray=[[NSMutableArray alloc]init];
        
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
		
		[top_label addSubview:TitleBig];
        
        selectedResultIndex = 0;
        
		
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    [self.scrollView addSubview:searchResult];
    [self.scrollView addSubview:searchResultAlbum];
    [self.scrollView addSubview:searchResultArtist];
    
	[self.view addSubview:scrollView];
    
    [self hideSectionTitle];
	
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

-(void)hideSectionTitle{
    [HeaderTitle setHidden:YES];
    [HeaderTitleAlbum setHidden:YES];
    [HeaderTitleArtist setHidden:YES];
}

-(void)getSuggest:(NSString *)KeyWords{
	//NSLog(@"called");
	
	NSString *baseUrl=[NSString stringWithFormat:@"%@search/integration/song?keyword=%@&_DIR=c&_CNAME=%@&_CPASS=%@&offset=0&limit=%i",[NSString stringWithUTF8String:MAPI_SERVER],KeyWords,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS], RECORD_LIMIT];
	NSString* escapedUrl = [baseUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL=[NSURL URLWithString:escapedUrl];
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	NSLog(@"request-->%@",URL);
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            //clear song data
            [self.netraMutableArray removeAllObjects];
            [searchResult reloadData];
            
            total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            
            int size =[[responseObject objectForKey:@"size"]intValue];
            
            if(size>0)
                songTableHeight = (size*SONG_ROW_HEIGHT)+HEADER_TITLE_HEIGHT;
            else
                songTableHeight = HEADER_TITLE_HEIGHT;
            
            if(HeaderTitleAlbum.hidden==YES)
                albumTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(HeaderTitleArtist.hidden==YES)
                artistTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(albumTableHeight<0) albumTableHeight = 0;
            if(artistTableHeight<0) artistTableHeight = 0;
            
            //set scrollview height
            int totalHeight = songTableHeight + albumTableHeight + artistTableHeight;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            
            if(totalHeight < screenRect.size.height)
                totalHeight = screenRect.size.height;
            
            NSLog(@"TOTAL HEIGHT SONG %i", totalHeight);
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, totalHeight+100);
            
            //set song table height
            CGRect frame = searchResult.frame;
            frame.size.height = songTableHeight;
            searchResult.frame = frame;
            
            //set album table position
            CGRect frame1 = searchResultAlbum.frame;
            frame1.origin.y = songTableHeight + (HeaderTitle.hidden==NO?5:0);
            searchResultAlbum.frame = frame1;
            
            //set artist table position
            CGRect frame2 = searchResultArtist.frame;
            frame2.origin.y = (albumTableHeight+songTableHeight+ (HeaderTitleAlbum.hidden==NO?5:0) ) + (HeaderTitleArtist.hidden==NO?5:0);
            searchResultArtist.frame = frame2;
            
            for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
                
                songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
                if (![self.netraMutableArray containsObject:songListObjectData]) {
                    [self.netraMutableArray addObject:songListObjectData];
                    
                }
                
                [songListObjectData release];
            }
            
            [HeaderTitle setHidden:YES];
            if(size > 0){
                [HeaderTitle setHidden:NO];
            }
            
            //fetch=1;
            //firstLoad=0;
            //MelonList.hidden=NO;
            //[self dismiss];
            [searchResult setHidden:NO];
            [searchResult reloadData];
		}
        @catch (NSException *exception) {
            NSLog(@"error album load %@", exception);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			
			[searchResult setHidden:YES];
		}
		
	}];
	//[operation start];
    if(operationQueueSong==nil)
        operationQueueSong = [[NSOperationQueue alloc] init];
    
    [operationQueueSong cancelAllOperations];
    [operationQueueSong addOperation:operation];
	[operation release];
	
}

-(void)getSuggestAlbum:(NSString *)KeyWords{
	
	NSString *baseUrl=[NSString stringWithFormat:@"%@search/integration/album?keyword=%@&_DIR=c&_CNAME=%@&_CPASS=%@&offset=0&limit=%i",[NSString stringWithUTF8String:MAPI_SERVER],KeyWords,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS], RECORD_LIMIT];
	NSString* escapedUrl = [baseUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL=[NSURL URLWithString:escapedUrl];
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	NSLog(@"request-->%@",URL);
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            //clear album data
            [self.netraMutableAlbumArray removeAllObjects];
            [searchResultAlbum reloadData];
            
            NSLog(@"RESPONSE %@", responseObject);
            
            total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            
            int size =[[responseObject objectForKey:@"size"]intValue];
            
            if(size>0)
                albumTableHeight = (size*ALBUM_ROW_HEIGHT)+HEADER_TITLE_HEIGHT;
            else
                albumTableHeight = HEADER_TITLE_HEIGHT;
            
            if(HeaderTitle.hidden==YES)
                songTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(HeaderTitleArtist.hidden==YES)
                artistTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(songTableHeight<0) songTableHeight = 0;
            if(artistTableHeight<0) artistTableHeight = 0;
            
            //set scrollview height
            int totalHeight = songTableHeight + albumTableHeight + artistTableHeight;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            
            if(totalHeight < screenRect.size.height)
                totalHeight = screenRect.size.height;
            
            NSLog(@"TOTAL HEIGHT ALBUM %i", totalHeight);
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, totalHeight+100);
            
            //set album table height
            CGRect frame = searchResultAlbum.frame;
            frame.size.height = albumTableHeight;
            searchResultAlbum.frame = frame;
            
            //set album table position
            CGRect frame1 = searchResultAlbum.frame;
            frame1.origin.y = songTableHeight + (HeaderTitle.hidden==NO?5:0);
            searchResultAlbum.frame = frame1;
            
            //set artist table position
            CGRect frame2 = searchResultArtist.frame;
            frame2.origin.y = (albumTableHeight+songTableHeight+ (HeaderTitleArtist.hidden==NO?5:0) ) + (HeaderTitle.hidden==NO?5:0);
            searchResultArtist.frame = frame2;
            
            for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
                
                albumListObject *albumListObjectData=[[albumListObject alloc] initWithDictionary:netraDictionary];
                if (![self.netraMutableAlbumArray containsObject:albumListObjectData]) {
                    [self.netraMutableAlbumArray addObject:albumListObjectData];
                    
                }
                
                [albumListObjectData release];
            }
            
            [HeaderTitleAlbum setHidden:YES];
            if(size > 0){
                [HeaderTitleAlbum setHidden:NO];
            }
            
            //fetch=1;
            //firstLoad=0;
            //MelonList.hidden=NO;
            //[self dismiss];
            [searchResultAlbum setHidden:NO];
            [searchResultAlbum reloadData];
        }
        @catch (NSException *exception) {
            NSLog(@"error album load %@", exception);
        }
        
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			
			[searchResultAlbum setHidden:YES];
		}
		
	}];
	//[operation start];
    if(operationQueueAlbum==nil)
        operationQueueAlbum = [[NSOperationQueue alloc] init];
    
    [operationQueueAlbum cancelAllOperations];
    [operationQueueAlbum addOperation:operation];
	[operation release];
	
}

-(void)getSuggestArtist:(NSString *)KeyWords{
	
	NSString *baseUrl=[NSString stringWithFormat:@"%@search/integration/artist?keyword=%@&_DIR=c&_CNAME=%@&_CPASS=%@&offset=0&limit=%i",[NSString stringWithUTF8String:MAPI_SERVER],KeyWords,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS], RECORD_LIMIT];
	NSString* escapedUrl = [baseUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *URL=[NSURL URLWithString:escapedUrl];
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	NSLog(@"request-->%@",URL);
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            //clear artist data
            [self.netraMutableArtistArray removeAllObjects];
            [searchResultArtist reloadData];
            
            NSLog(@"RESPONSE %@", responseObject);
            
            total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            
            int size =[[responseObject objectForKey:@"size"]intValue];
            
            if(size>0)
                artistTableHeight = (size*ARTIST_ROW_HEIGHT)+HEADER_TITLE_HEIGHT;
            else
                artistTableHeight = HEADER_TITLE_HEIGHT;
            
            if(HeaderTitle.hidden==YES)
                songTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(HeaderTitleAlbum.hidden==YES)
                albumTableHeight -= HEADER_TITLE_HEIGHT;
            
            if(songTableHeight<0) songTableHeight = 0;
            if(albumTableHeight<0) albumTableHeight = 0;
            
            //set scrollview height
            int totalHeight = songTableHeight + albumTableHeight + artistTableHeight;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            
            if(totalHeight < screenRect.size.height)
                totalHeight = screenRect.size.height;
            
            NSLog(@"TOTAL HEIGHT ARTIST %i", totalHeight);
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, totalHeight+100);
            
            //set album table height
            CGRect frame = searchResultArtist.frame;
            frame.size.height = artistTableHeight;
            searchResultArtist.frame = frame;
            
            //set album table position
            CGRect frame1 = searchResultAlbum.frame;
            frame1.origin.y = songTableHeight + (HeaderTitle.hidden==NO?5:0);
            searchResultAlbum.frame = frame1;
            
            //set artist table position
            CGRect frame2 = searchResultArtist.frame;
            frame2.origin.y = (albumTableHeight+songTableHeight+ (HeaderTitleAlbum.hidden==NO?5:0) )+ (HeaderTitle.hidden==NO?5:0);
            searchResultArtist.frame = frame2;
            
            for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
                
                artistListObject *artistListObjectData=[[artistListObject alloc] initWithDictionary:netraDictionary];
                if (![self.netraMutableArtistArray containsObject:artistListObjectData]) {
                    [self.netraMutableArtistArray addObject:artistListObjectData];
                    
                }
                
                [artistListObjectData release];
            }
            
            [HeaderTitleArtist setHidden:YES];
            if(size > 0){
                [HeaderTitleArtist setHidden:NO];
            }
            
            //fetch=1;
            //firstLoad=0;
            //MelonList.hidden=NO;
            //[self dismiss];
            [searchResultArtist setHidden:NO];
            [searchResultArtist reloadData];
        }
        @catch (NSException *exception) {
            NSLog(@"error artist load %@", exception);
        }
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			
			[searchResultArtist setHidden:YES];
		}
		
	}];
	//[operation start];
    if(operationQueueArtist==nil)
        operationQueueArtist = [[NSOperationQueue alloc] init];
    
    [operationQueueArtist cancelAllOperations];
    [operationQueueArtist addOperation:operation];
	[operation release];
	
}

-(void)close{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
	TitleBig.hidden=NO;
	[self.navigationController.navigationBar addSubview:top_label];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"]  forBarMetrics:UIBarMetricsDefault];
	animated=YES;
    
    self.gTunggu = [[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 160.0)/2, (CGRectGetHeight(self.view.bounds) - 212)/2, 160.0, 106)] autorelease];
    [self.gTunggu setImage:[UIImage imageNamed:@"st"]];
    [self.view addSubview:self.gTunggu];
    self.gTunggu.hidden = YES;
    
    
    [self installNotification];
	
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
    
    //tracking google analytics
    self.screenName = NSLocalizedString(@"Screen Name Search Song", nil);
	
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newString = [searchForm.text stringByReplacingCharactersInRange:range withString:string];
    
    if(newString.length <= 0)
        [self hideSectionTitle];
    
    //minimal 3 character to search
	//if(searchForm.text.length>1){
		[self.netraMutableArray removeAllObjects];
        [self.netraMutableAlbumArray removeAllObjects];
        [self.netraMutableArtistArray removeAllObjects];
		[self getSuggest:newString];
        [self getSuggestAlbum:newString];
        [self getSuggestArtist:newString];
	//}
	
	NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
		
		[self.netraMutableArray removeAllObjects];
        [self.netraMutableAlbumArray removeAllObjects];
        [self.netraMutableArtistArray removeAllObjects];
		//[[self loadingCell] removeFromSuperview];
		[searchResult reloadData];
        [searchResultAlbum reloadData];
        [searchResultArtist reloadData];
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
    //clear song, album data
	[self.netraMutableArray removeAllObjects];
	[searchResult reloadData];
    
    [self.netraMutableAlbumArray removeAllObjects];
	[searchResultAlbum reloadData];
    
    [self.netraMutableArtistArray removeAllObjects];
	[searchResultArtist reloadData];
    
    //set song table height
    CGRect frame = searchResult.frame;
    frame.size.height = HEADER_TITLE_HEIGHT;
    searchResult.frame = frame;
    
    CGRect frame1 = searchResultAlbum.frame;
    frame1.size.height = HEADER_TITLE_HEIGHT;
    frame1.origin.y = 35;
    searchResultAlbum.frame = frame1;
    
    CGRect frame2 = searchResultArtist.frame;
    frame1.size.height = HEADER_TITLE_HEIGHT;
    frame1.origin.y = 70;
    searchResultArtist.frame = frame1;
    
    [self hideSectionTitle];
    
    //scroll to top
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
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
    if(tableView == searchResult)
        return self.netraMutableArray.count;
    else if(tableView == searchResultAlbum)
        return self.netraMutableAlbumArray.count;
    else if(tableView == searchResultArtist)
        return self.netraMutableArtistArray.count;
	else
        return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //if(tableView == searchResult) {
        cell.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
        
        if (cell.tag == kLoadingCellTag2) {
            NSLog(@"kLoadingCellTag");
            current_page+=10;
            //[self fetchData];
            
            
        }
    //es}
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECT ROW");
    
    if(tableView == searchResult) {
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
    else if(tableView == searchResultAlbum) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        albumListObject * albumItem = [self.netraMutableAlbumArray objectAtIndex:indexPath.row];
        
        MusicListControllerByAlbum *viewController = [[MusicListControllerByAlbum alloc] init];
        [viewController setAlbumName:albumItem.albumName];
        [viewController setAlbumId:albumItem.albumId];
        // Push View Controller onto Navigation Stack
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(tableView == searchResultArtist) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        artistListObject * artistItem = [self.netraMutableArtistArray objectAtIndex:indexPath.row];
        
        AlbumListControllerByArtist *viewController = [[AlbumListControllerByArtist alloc] init];
        [viewController setArtistName:artistItem.artistName];
        [viewController setArtistId:artistItem.artistId];
        // Push View Controller onto Navigation Stack
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row %i", indexPath.row);
    
    if(tableView == searchResult) {
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
    else if(tableView == searchResultAlbum){
        SearchCell *cell       = [searchResult dequeueReusableCellWithIdentifier:@"Cell"];
        albumListObject *dataObject=[self.netraMutableAlbumArray objectAtIndex:indexPath.row];
        if (cell == nil)
        {
            cell= [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            //cell=[[[NetraCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ]autorelease];
        }
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
        cell.selectedBackgroundView = myBackView;
        [myBackView release];
        cell.SongTitle.text=dataObject.albumName;
        cell.Singer.text=dataObject.mainArtistName;
        //cell.detailTextLabel.highlightedTextColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1];
        //cell.detailTextLabel.text=dataObject.albumName;
        NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/file.do?fileuid=%@",dataObject.albumLImgPath];
        
        [cell.image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        return cell;
    }
    else if(tableView == searchResultArtist){
        SearchCell *cell       = [searchResult dequeueReusableCellWithIdentifier:@"Cell"];
        artistListObject *dataObject=[self.netraMutableArtistArray objectAtIndex:indexPath.row];
        if (cell == nil)
        {
            cell= [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            //cell=[[[NetraCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ]autorelease];
        }
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
        cell.selectedBackgroundView = myBackView;
        [myBackView release];
        cell.SongTitle.text=dataObject.artistName;
        cell.Singer.text=dataObject.nationality;
        //cell.detailTextLabel.highlightedTextColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1];
        //cell.detailTextLabel.text=dataObject.albumName;
        NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/file.do?fileuid=%@",dataObject.artistMImgPath];
        
        [cell.image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        return cell;
    }
	
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
    if(tableView == searchResult) {
        return SONG_ROW_HEIGHT;
    }
    else if(tableView == searchResultAlbum){
        return ALBUM_ROW_HEIGHT;
    }
    else if(tableView == searchResultArtist){
        return ARTIST_ROW_HEIGHT;
    }
    else
        return 0;
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
