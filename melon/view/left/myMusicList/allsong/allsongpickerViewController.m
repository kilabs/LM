//
//  allsongpickerViewController.m
//  melon
//
//  Created by Arie on 5/29/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "allsongpickerViewController.h"
#import "mokletdevAppDelegate.h"
#import "LocalPlaylist.h"
#import "DownloadList.h"
#import "AFNetworking.h"
#import "MelonPlayer.h"
#import "netracell_.h"
#import "LocalPlaylist.h"
#import "EUserBrief.h"
#import "mokletdevPlayerViewController.h"
#import "localplayer.h"
#import "YRDropdownView.h"
#include "Encryption.h"
#include "GlobalDefine.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"

@interface allsongpickerViewController ()
{
@private
    LocalPlaylist * currentList;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContex;

@property (nonatomic,retain) NSMutableArray  * AllSongList;
@property (nonatomic,retain) NSMutableArray  * state;
@property (nonatomic,retain) NSMutableArray  * All_last_download_list;

@end

@implementation allsongpickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		// Custom initialization
		self.view.backgroundColor=[UIColor whiteColor];
		// Custom initialization
		top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		list_to_push=[[NSMutableArray alloc]init];
		
		AllSongTable=[[[UITableView alloc]init] autorelease];
		AllSongTable.backgroundColor=[UIColor blackColor];
		AllSongTable.delegate=self;
		AllSongTable.dataSource=self;
		AllSongTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[AllSongTable setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		AllSongTable.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		
		[self.view addSubview:AllSongTable];
		self.state=[[NSMutableArray alloc]init];
		
		empty=[[UIView alloc]initWithFrame:CGRectMake(20, ((self.view.frame.size.height-120)/2)-60, 280, 120)];
		empty.backgroundColor=[UIColor clearColor];
		empty.hidden=YES;
		
		empty_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
		empty_title.text=@"Local Song Kosong";
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
		
		
	
		[empty addSubview:empty_title];
		[empty addSubview:empty_text];
		[self.view addSubview:empty];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchNotes)
												name:@"reloadTable"
											  object:nil];
	
}

-(void)viewWillAppear:(BOOL)animated{
	[TitleBig setHidden:YES];
	[self initLayout];
	[self fetchNotes];
}

-(void)initLayout{
	
	
	
	
	// Custom initialization
	self.view.backgroundColor=[UIColor whiteColor];
	top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
	top_label.backgroundColor=[UIColor clearColor];
	
	TitleBig=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
	TitleBig.text=@"Pilih Lagu";
	TitleBig.textAlignment=NSTextAlignmentCenter;
	TitleBig.backgroundColor=[UIColor clearColor];
	[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
	TitleBig.textColor = [UIColor whiteColor];
	TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
	TitleBig.shadowOffset = CGSizeMake(0, 1.0);
	TitleBig.hidden=NO;
	[top_label addSubview:TitleBig];
	
	UIImage* image = [UIImage imageNamed:@"OK"];
	CGRect frame = CGRectMake(-5, 0, 44, 44);
	UIButton* leftbutton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
	
	
	UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
	leftbuttonView.backgroundColor=[UIColor clearColor];
	[leftbuttonView addSubview:leftbutton];
	UIBarButtonItem* leftbarbutton = [[[UIBarButtonItem alloc] initWithCustomView:leftbuttonView] autorelease
									  ];
	[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage* image2 = [UIImage imageNamed:@"cancel"];
	CGRect frame2 = CGRectMake(55, 0, 44, 44);
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
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2-kanan2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];
	
}

-(void)lefbuttonPush{
	[YRDropdownView showDropdownInView:self.view
								 title:@"Proses"
								detail:@"Sedang Menambahkan Lagu anda ke Server"
								 image:[UIImage imageNamed:@"dropdown-alert_error"]
							  animated:YES
							 hideAfter:3];
	if(list_to_push.count!=0){
		NSString *string = [list_to_push componentsJoinedByString:@","];
		//NSString *berhasil=[NSString stringWithFormat:@"%@ berhasil dimasukkan ke dalam playlist %@",songName,playlistName];
		//NSString *gagal=[NSString stringWithFormat:@"%@ gagal dimasukkan ke dalam playlist %@",songName,playlistName];
		
		NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
		EUserBrief *user_now=[users_active objectAtIndex:0];
		NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists/%@/song?_CNAME=%@&&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@&_method=PUT&newSongId=%@&plasylitId=%@", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId,self.playlist_id, [NSString stringWithUTF8String:CNAME], [NSString stringWithUTF8String:CPASS], user_now.username,user_now.webPassword,string,self.playlist_id];
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
										detail:@"Berhasil Menambahkan Musik ke dalam Playlist"
										 image:[UIImage imageNamed:@"dropdown-alert_success"]
							   backgroundImage:[UIImage imageNamed:@"allow"]
									  animated:YES
			 
									 hideAfter:2];
			[self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			[YRDropdownView showDropdownInView:self.view
										 title:NSLocalizedString(@"Error", nill)
										detail:@"Gagal Menambahkan Musik ke dalam Playlist"
										 image:[UIImage imageNamed:@"dropdown-alert_error"]
									  animated:YES
									 hideAfter:3];
			
		}];
		
		//[operation start];
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue addOperation:operation];
		[httpClient release];
		

	}
	else{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	}
	//[self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)dismiss{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)rightbuttonPush {
	[self.navigationController dismissModalViewControllerAnimated:YES];
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
		cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_dark"]];
	}
	else{
		cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_light"]];
	}
	
	if([self.state containsObject:indexPath]){
		if(indexPath.row % 2==0){
			cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_dark_active"]];
		}
		else{
			cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_light_active"]];
		}
    } else {
		if(indexPath.row % 2==0){
			cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_dark"]];
		}
		else{
			cell.container.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_light"]];
		}
    }
	LocalPlaylist * currentSongList = [self.AllSongList objectAtIndex:indexPath.row];
	
	cell.title.text = currentSongList.songTitle;
	cell.excerpt.text = currentSongList.artistName;
	cell.albumName.text = currentSongList.albumName;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",currentSongList.realSongid];

    [cell.thumbnail setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.play.hidden=YES;
	cell.download.hidden=YES;
	cell.playmex.hidden=YES;
	cell.addto_play_list.hidden=YES;
	cell.play.tag=indexPath.row;
	[cell.play addTarget:self action:@selector(playeme:) forControlEvents:UIControlEventTouchUpInside];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 153/2;
    if(indexPath.row ==([self.AllSongList count]))
	{
		return 44;
		[AllSongTable setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
        return 153/2;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	LocalPlaylist *l=[self.AllSongList objectAtIndex:indexPath.row];
	
	[AllSongTable deselectRowAtIndexPath:indexPath animated:YES];
	if([self.state containsObject:indexPath]){
        [self.state removeObject:indexPath];
		[list_to_push removeObject:l.realSongid];
    } else {
        [self.state addObject:indexPath];
		//[list_to_push insertObject:l.realSongid atIndex:indexPath];
		[list_to_push addObject:l.realSongid];
    }
	[AllSongTable reloadData];
	}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}
- (void) doDownload:(id) sender
{
	
}

- (void)fetchNotes {
	NSArray *userNow=[EUserBrief MR_findAll];
	EUserBrief *orang=[userNow objectAtIndex:0];
	
	
	
	self.AllSongList = [NSMutableArray arrayWithArray:[LocalPlaylist MR_findByAttribute:@"userId" withValue:orang.userId andOrderBy:@"tanggal" ascending:NO]];
	
	//self.AllSongList = [NSMutableArray arrayWithArray:[LocalPlaylist MR_findAll]];
	
	if(self.AllSongList.count==0){
		empty.hidden=NO;
	}
	else{
		[empty setHidden:YES];
		[AllSongTable reloadData];
		[AllSongTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

@end
