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
NSArray  * sectionMenu;

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
        self.view.backgroundColor=[UIColor whiteColor];
        
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        searchView=[[UIView alloc]initWithFrame:CGRectMake(0, -50, 320, 40)];
        searchView.backgroundColor=[UIColor blackColor];
        
        sectionMenu = [NSArray arrayWithObjects:
                       @"Highlights",
                       @"New Releases",
                       @"LangitMusik’s Pick",
                       @"Popular Tracks",
                       @"Popular Albums",
                       @"Popular Artist",
                       @"Popular Playlist",
                       @"Mood",
                       @"Genre", nil];
        
        self.currentIndex=Nil;
        MelonList=[[UITableView alloc]init];
        MelonList.delegate=self;
        MelonList.dataSource=self;
        MelonList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
        MelonList.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
        [self.view addSubview:MelonList];
        
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
        self.netraMutableArray=[[NSMutableArray alloc]init];
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
    [self fetchData];
    
    
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
-(void)fetchData{
    if(firstLoad==1){
        MelonList.hidden=YES;
        MelonList.allowsSelection=YES;
        // [self showHud];
    }
    
    MelonList.allowsSelection=NO;
//    
//    if(firstLoad==1){
//        //load cache first
//        NSLog(@"load cache");
//       [self loadCacheData];
//    }
    
    NSString * offset = [NSString stringWithFormat:@"%d", (current_page -1)];
    
    NSString *baseUrl=[NSString stringWithFormat:@"%@songs/new?offset=%@&limit=5",[NSString stringWithUTF8String:MAPI_SERVER],offset];
    //NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily?offset=%d&limit=10",current_page];
    
    NSURL *URL=[NSURL URLWithString:baseUrl];
    //NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    NSLog(@"DATA URL %@", baseUrl);
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    //[httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:baseUrl parameters:nil];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
    
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject-->%@",responseObject);
        NSInteger offset =[[responseObject objectForKey:@"offset"]intValue];
        NSLog(@"response object-->%@",responseObject);
        //check store data
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"new_release" inContext:localContext];

            total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
            
            currentSongId = @"0";
            for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
                NSLog(@"responseObject-->%@",responseObject);
                songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
                if (![self.netraMutableArray containsObject:songListObjectData]) {
                    [self.netraMutableArray addObject:songListObjectData];
                    NSLog(@"netra MutableDictionary--->%@",netraDictionary);
                }
            }
            
            [self performSelector:@selector(loadSomde) withObject:self afterDelay:2];
        
        
//        
//        NSDictionary *responseJSON = [[NSDictionary alloc] initWithDictionary:responseObject];
//        
//        if(offset <= 1){
//            //NSLog(@"responseJSON-->%@",responseJSON);
//            if(responseJSON.count > 0){
//                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//                PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"new_release" inContext:localContext];
//                if (cache) {
//                    cache.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
//                }
//                else {
//                    //save to local db
//                    PageCacheList *local = [PageCacheList MR_createInContext:localContext];
//                    local.pageType = @"new_release";
//                    local.cacheData = [[NSDictionary alloc] initWithDictionary:responseObject];
//                }
//                [localContext MR_save];
//            }
//            
//            NSLog(@"SAVE TO DB");
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YRDropdownView showDropdownInView:self.view
                                     title:NSLocalizedString(@"Error", nill)
                                    detail:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:3];
        
        MelonList.allowsSelection=YES;
        
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [operation release];
    [httpClient release];
    currTableContentType = NEWRELEASE;
    
}
-(void)loadSomde{
    netracell_ *cell = (netracell_ *)[MelonList cellForRowAtIndexPath:self.currentIndex];
    cell.playmex.hidden=NO;
    cell.twitter.hidden=NO;
    cell.facebook.hidden=NO;
    cell.playmex.hidden=NO;
    cell.addto_play_list.hidden=NO;
    
    fetch=1;
   // [self removeHud];
    firstLoad=0;
    //[indicator stopAnimating];
    MelonList.hidden=NO;
    [self dismiss];
    
    [MelonList reloadData];
    [MelonList beginUpdates];
    [MelonList endUpdates];
    cell.playmex.hidden=NO;
    cell.twitter.hidden=NO;
    cell.facebook.hidden=NO;
    cell.playmex.hidden=NO;
    cell.addto_play_list.hidden=NO;
    NSLog(@"current index--->%@",self.currentIndex);
    MelonList.allowsSelection=YES;
    NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
    //NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    if([users_active count]>0){
        EUserBrief *usersss=[users_active objectAtIndex:0];
        [self loadPlaylist:usersss.userId pass:usersss.webPassword username:usersss.username];
    }
    
    
}
-(void)loadPlaylist:(NSString*)userId pass:(NSString*)pass username:(NSString *)username{
    [self.netraMutableArrayPlaylist removeAllObjects];
    
    NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists?_CNAME=%@&&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@&offset=0&limit=100", [NSString stringWithUTF8String:MAPI_SERVER], userId,[NSString stringWithUTF8String:CNAME],[NSString stringWithUTF8String:CPASS],username,pass];
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
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error){
            netracell_ *cell = (netracell_ *)[MelonList cellForRowAtIndexPath:self.currentIndex];
            cell.addto_play_list.enabled=NO;
            
        }
        NSLog(@"error: %@", [error description]);
        
    }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}
-(void)loadCacheData{
    //check store data
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    PageCacheList *cache = [PageCacheList MR_findFirstByAttribute:@"pageType" withValue:@"new_release" inContext:localContext];
    if (cache){
        total_page=[[cache.cacheData objectForKey:@"totalSize"]intValue]/10;
        
        //clear song data
        //[self.netraMutableArray removeAllObjects];
        [MelonList reloadData];
        
        //NSLog(@"LOAD CACHE %@", cache.cacheData);
        
        currentSongId = @"0";
        for(id netraDictionary in [cache.cacheData objectForKey:@"dataList"]){
            songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
            if (![self.netraMutableArray containsObject:songListObjectData]) {
                [self.netraMutableArray addObject:songListObjectData];
                NSLog(@"isi data-->%@",self.netraMutableArray);
            }
        }
        
        //NSLog(@"LOAD CACHE AFTER %@", self.netraMutableArray);
        
        already_caches = 1;
        
//        [self removeHud];
//        [self loadSomde];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 59.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    
    UIView *pink = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 184.5, 40)];
    //pink.backgroundColor = [UIColor colorWithRed:0.137 green:0.757 blue:0.945 alpha:1];
    pink.backgroundColor =[UIColor colorWithRed:0.922 green:0.031 blue:0.553 alpha:1] /*#eb088d*/;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, pink.frame.size.width, 20)];
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    /* Section header is in 0th index... */
    switch (section) {
        case 0:
            label.text = @"Highlights";
            break;
        case 1:
            label.text = @"New Release";
            break;
        case 2:
            label.text = @"LangitMusik’s Pick";
            break;
        case 3:
            label.text = @"Popular Tracks";
            break;
        case 4:
            label.text = @"Popular Albums";
            break;
        case 5:
            label.text = @"Popular Artist";
            break;
        case 6:
            label.text = @"Popular Playlist";
            break;
        case 7:
            label.text = @"Mood";
            break;
        default:
            label.text = @"Genre";
            break;
    }
    [pink addSubview:label];
    [view addSubview:pink];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

-(void)reloadInternet{
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ScrollCell";
    UITableViewCell *cell = [MelonList dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        scroller.showsHorizontalScrollIndicator = NO;
        scroller.backgroundColor = [UIColor clearColor];
        scroller.pagingEnabled  =YES;
        for (int i=0; i<self.netraMutableArray.count; i++) {
            songListObject *dataObject=[self.netraMutableArray objectAtIndex:indexPath.row];
            UIImageView *imageAlbum = [[UIImageView alloc]init];
            UIView *albumCover = [[UIView alloc]init];
            
            UILabel * album = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 15)];
            [album setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            album.text = @"Album";
            
            UILabel * artis = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 280, 15)];
            [artis setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
            artis.text = dataObject.artistName;
            
            UILabel * albumName = [[UILabel alloc]initWithFrame:CGRectMake(5, 50, 260, 25)];
            [albumName setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
            albumName.text = dataObject.albumName;
            
            
            albumCover.backgroundColor = [UIColor whiteColor];
            albumCover.layer.opacity =.6;
            
            [albumCover addSubview:album];
            [albumCover addSubview:artis];
            [albumCover addSubview:albumName];
            
            if (i==0) {
                imageAlbum.frame= CGRectMake(10, 10, 260, 290);
                
            }
            else{
                imageAlbum.frame= CGRectMake((i*10)+i*(260)+10, 10, 260, 290);
            }
            albumCover.frame = CGRectMake(0, imageAlbum.frame.size.height-88, imageAlbum.frame.size.width, 88);
            [imageAlbum addSubview:albumCover];
            
            NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
            [imageAlbum setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
            [scroller setContentSize:CGSizeMake(1360, 300)];
            [scroller addSubview:imageAlbum];
        }
        
        
        [cell addSubview:scroller];
    }
    
    
    return cell;
}
@end
