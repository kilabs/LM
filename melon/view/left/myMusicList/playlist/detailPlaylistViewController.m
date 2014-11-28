//
//  detailPlaylistViewController.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/10/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "detailPlaylistViewController.h"
#include "GlobalDefine.h"
#import "mokletdevAppDelegate.h"
#import "AFNetworking.h"
#import "NewSongs.h"
#import "netracell_.h"
#import "allsongpickerViewController.h"
#import "YRDropdownView.h"
#import "localplayer.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "MelonPlayer.h"
#import "DownloadList.h"
#import <social/Social.h>
#import <Twitter/Twitter.h>
#import <accounts/Accounts.h>
#import "songDownloader.h"
#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"


@interface detailPlaylistViewController ()
{
 songListObject * currentSong;
}
@end

@implementation detailPlaylistViewController

@synthesize playlistId          = _playlistId;
@synthesize songListTable       = _songListTable;
@synthesize playlistSongList    = _playlistSongList;
@synthesize playlistTitle       = _playlistTitle;

int selectedResultIndex;
@synthesize gTunggu = _gTunggu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
    
    top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
    top_label.backgroundColor=[UIColor clearColor];
    
    TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
	// TitleBig.text=@"PLAYLIST";
    TitleBig.textAlignment=NSTextAlignmentCenter;
    TitleBig.backgroundColor=[UIColor clearColor];
    [TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
    TitleBig.textColor = [UIColor whiteColor];
    TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
    TitleBig.shadowOffset = CGSizeMake(0, 1.0);
    TitleBig.hidden=NO;
	[TitleBig setText:self.playlistTitle];
    
    [top_label addSubview:TitleBig];
    empty=[[UIView alloc]initWithFrame:CGRectMake(20, ((self.view.frame.size.height-120)/2)-60, 280, 120)];
	empty.backgroundColor=[UIColor clearColor];
	
	empty_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
	empty_title.text=@"Playlist Kosong";
	empty_title.backgroundColor=[UIColor clearColor];
	empty_title.textAlignment=NSTextAlignmentCenter;
	empty_title.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
	[empty_title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
	
	empty_text=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 110)];
	empty_text.text=@"Tidak ada musik di playlist anda, silahkan tambahkan musik dari direktori lokal anda dengan menekan tombol tambah";
	empty_text.numberOfLines=4;
	empty_text.backgroundColor=[UIColor clearColor];
	empty_text.textAlignment=NSTextAlignmentCenter;
	empty_text.textColor=[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1];
	[empty_text setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
	
	
	[self.view addSubview:empty];
	[empty addSubview:empty_title];
	[empty addSubview:empty_text];
	
	UIImage* image_ = [UIImage imageNamed:@"back"];
	CGRect frame_ = CGRectMake(-5, 0, 44, 44);
	UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame_];
	[leftbutton setBackgroundImage:image_ forState:UIControlStateNormal];
	//[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
	[leftbutton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *leftbuttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	leftbuttonView.backgroundColor=[UIColor clearColor];
	[leftbuttonView addSubview:leftbutton];
	UIBarButtonItem* leftbarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonView];
	
	UIImage* image2 = [UIImage imageNamed:@"add-button"];
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
	[self.navigationItem setLeftBarButtonItem:leftbarbutton];
    
    
    plView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48.0)] autorelease];
    plView.backgroundColor = [UIColor clearColor];
	//  [self.view addSubview:plView];
    
    CGRect r = [plView frame];
    r.origin.x += 10.0;
    
    
    UIImageView * latarAddPlaylist = [[[UIImageView alloc] initWithFrame:plView.bounds] autorelease];
    [latarAddPlaylist setImage:[UIImage imageNamed:@"addplbg"]];
    [plView addSubview:latarAddPlaylist];
    
    UILabel * playlistTitle = [[[UILabel alloc] initWithFrame:r] autorelease];
    NSLog(@"playlist title: %@.", self.playlistTitle);
    [playlistTitle setText:self.playlistTitle];
	[TitleBig setText:self.playlistTitle];
	// [plView addSubview:playlistTitle];
    
    songListTable = [[[UITableView alloc] init] autorelease];
    songListTable.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    [songListTable setBackgroundColor:[UIColor clearColor]];
	[songListTable setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
    [self.view addSubview:songListTable];
    songListTable.delegate = self;
    songListTable.dataSource = self;
    
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
    
    currentPage = 1;
    
    [self fetchPlaylistSongList];
    
    top_label.hidden = NO;
    
    selectedResultIndex = 0;
}
-(void)rightbuttonPush{
	allsongpickerViewController *s=[[[allsongpickerViewController alloc]init] autorelease];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:s];
	s.playlist_id=self.playlistId;
	s.playlist_name=self.playlistTitle;
	[self.navigationController presentModalViewController:navigationController animated:YES];

	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-lain"] forBarMetrics:UIBarMetricsDefault];
}

- (void) fetchPlaylistSongList
{
	empty.hidden=YES;
   	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
    NSString * offset = @"0";
    NSString * limit = @"100";
    
    NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists/%@/song", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId, self.playlistId];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              offset, @"offset",
                              limit, @"limit",
                              @"c", @"_DIR",
                              [NSString stringWithUTF8String:CNAME], @"_CNAME",
                              [NSString stringWithUTF8String:CPASS], @"_CPASS",
                              nil] autorelease];
    
    NSURL * URL = [NSURL URLWithString:sURL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"data songList of playlist: %@", responseObject);
        self.playlistSongList = [[[NSMutableArray alloc] init] autorelease];
		totalPage=[[responseObject objectForKey:@"totalSize"]intValue]/10;
        for (id data in [responseObject objectForKey:@"dataList"])
        {
            NewSongs * songItem = [[NewSongs alloc] initWithDictionary:data];
            
            
            if (![self.playlistSongList containsObject:songItem])
            {
                [self.playlistSongList addObject:songItem];
                _playlistSongList = self.playlistSongList;
            }
            [songItem release];
        }
		//[TitleBig setText:self.playlistTitle];
     
		[self performSelector:@selector(check) withObject:nil afterDelay:0.3];
		
        isLoadingData = NO;
        slowConnectionView.hidden = YES;
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			[[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
										 message:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
			
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
-(void)check{
	if(_playlistSongList.count!=0){
		songListTable.hidden=NO;
		[songListTable reloadData];
	}
	else{
		songListTable.hidden=YES;
		empty.hidden=NO;
	}
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Jumlah lagu di playlist: %d", [self.playlistSongList count]);
    return self.playlistSongList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.playlistSongList count]))
	{
		return 44;
		[songListTable setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
		CGFloat cellHeight = 153/2;
		if ([self.currentIndex isEqual:indexPath]) {
			cellHeight = self.expandedCellHeight;
		}
		return cellHeight;
	}
	
	
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    netracell_ * cell = [songListTable dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[netracell_ alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
   	if(indexPath.row % 2==0){
		cell.container.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
	}
	else{
		cell.container.backgroundColor=[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
	}
    NewSongs * songItem = (NewSongs *) [self.playlistSongList objectAtIndex:indexPath.row];
    cell.title.text = songItem.songName;
    cell.excerpt.text = songItem.artistName;
    cell.albumName.text = songItem.albumName;
    NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",songItem.songId];
    [cell.thumbnail setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseUrls]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

   cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//cell.genre.text=dataObject.genreName;
	cell.length.hidden=NO;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//	cell.music.hidden=YES;
	cell.genre.hidden=YES;
	cell.play.tag=indexPath.row;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.playmex.hidden=YES;
	cell.download.tag=indexPath.row;
	cell.addto_play_list.tag=indexPath.row;
	cell.playmex.tag=indexPath.row;
    [cell.playmex addTarget:self action:@selector(playMeEka:) forControlEvents:UIControlEventTouchUpInside];
	cell.addto_play_list.hidden=YES;
	[cell.addto_play_list addTarget:self action:@selector(addtoPlaylist:) forControlEvents:UIControlEventTouchUpInside];
	cell.twitter.tag=indexPath.row;
	//cell.mail.tag=indexPath.row;
	cell.facebook.tag=indexPath.row;
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	[cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)twitterShare:(id)sender{
	NSInteger i = [sender tag];
	
	songListObject *dataObject=[self.playlistSongList objectAtIndex:i];
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
	
	songListObject *dataObject=[self.playlistSongList objectAtIndex:i];
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
	NewSongs * song = [self.playlistSongList objectAtIndex:i];
	NSLog(@"song--playtime---->%@",song.playTime);
	
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
				local.playTime = [NSString stringWithFormat:@"%@", song.playTime];
				local.status = [NSNumber numberWithInt:0];
				
				
				[localContext MR_save];
				
				
				[[songDownloader sharedInstance] doDownload:song.songId userid:usersss.userId password:usersss.webPassword email:usersss.email];
				
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	netracell_ *cell = (netracell_ *)[songListTable cellForRowAtIndexPath:indexPath];
	cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundView.backgroundColor = [UIColor clearColor];
	songListObject *dataObject=[self.playlistSongList objectAtIndex:indexPath.row];
	NSString *berhasil=[NSString stringWithFormat:@"%@ berhasil dihapus dari playlist %@",dataObject.songName,self.playlistTitle];
	NSString *gagal=[NSString stringWithFormat:@"%@ gagal dihapus dari playlist %@",dataObject.songName,dataObject.songName];
	NSLog(@"delete");
	////http://118.98.31.132:8000/mapi/758965/playlists/130426?_CNAME=Android+Client&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=siraz@timun.com&_UPASS=MTIzNDU2
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
	NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists/%@?_CNAME=%@&&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@&_method=PUT&removeSongId=%@", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId,self.playlistId, [NSString stringWithUTF8String:CNAME], [NSString stringWithUTF8String:CPASS], user_now.username,user_now.webPassword,dataObject.songId];
	NSLog(@"surl--->%@",sURL);
	
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
		[self fetchPlaylistSongList];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[YRDropdownView showDropdownInView:self.view
									 title:NSLocalizedString(@"Error", nill)
									detail:gagal
									 image:[UIImage imageNamed:@"dropdown-alert_error"]
								  animated:YES
								 hideAfter:3];
		
	}];
    
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
	


}

- (void) playMeEka: (id) sender
{
    selectedResultIndex = [sender tag];
    NewSongs * songItem = [self.playlistSongList objectAtIndex:[sender tag]];
    if (songItem == nil)
    {
        return;
    }
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    [MPlayer stop];
    
    // add to nowplaying playlist
    [PlayerLib clearPlaylist];
    for (NewSongs * songItem in self.playlistSongList)
    {
        [PlayerLib addToPlaylistofNewSong:songItem];
    }
    
    
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
                [players createTimer];
                return;
            }
        }
    }
    
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    [PlayerLib addToPlaylistofNewSong:songItem];
    
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
        [players createTimer];
    }
    
    [self playMe:sender];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedResultIndex = indexPath.row;
    NewSongs * songItem = [self.playlistSongList objectAtIndex:indexPath.row];
    if (songItem == nil)
    {
        return;
    }
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    MPlayer = [MelonPlayer sharedInstance];
    
    [MPlayer stop];
    
    // add to nowplaying playlist
    [PlayerLib clearPlaylist];
    for (NewSongs * songItem in self.playlistSongList)
    {
        [PlayerLib addToPlaylistofNewSong:songItem];
    }
    
    
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
                [players createTimer];
                return;
            }
        }
    }
    
    if ([MPlayer isGettingNewSong])
        return;
    [MPlayer setGettingNewSong:[NSNumber numberWithBool:YES]];
    
    [PlayerLib addToPlaylistofNewSong:songItem];
    
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
        [players createTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
    }
	else{
	  NSLog(@"UP");
	}
}
-(void)viewWillAppear:(BOOL)animated{
	self.title=self.playlistTitle;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];

    isLoadingData = YES;
    loadingDataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(loadingTimeUp:)
                                                      userInfo:nil
                                                       repeats:YES];
    loadTimerisON = YES;
	currentPage = 1;

    [self fetchPlaylistSongList];
    
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

- (void) playMeHere: (id) sender
{
    [self playMe:sender];
}

-(void)playMe:(id)sender{
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	netracell_ *cell = (netracell_ *)[songListTable cellForRowAtIndexPath:indexPath];
	netracell_ *lass=(netracell_ *)[songListTable cellForRowAtIndexPath:self.currentIndex];
	
	if ([self.currentIndex isEqual:indexPath]){
		cell.twitter.hidden=YES;
		NSLog(@"sama kok");
		self.currentIndex = nil;
		self.expandedCellHeight =  153/2;
		[songListTable beginUpdates];
		[songListTable endUpdates];
		[UIView animateWithDuration:0.3
							  delay:0
							options: UIViewAnimationCurveEaseOut
						 animations:^{
							 cell.twitter.hidden=NO;
							 cell.facebook.hidden=NO;
							 cell.playmex.hidden=NO;
							 cell.addto_play_list.hidden=YES;
							 cell.facebook.frame=CGRectMake(210, 40, 34, 34);
							 cell.twitter.frame=CGRectMake(145, 40, 34, 34);
							 cell.playmex.frame=CGRectMake(80, 40, 34, 34);
							 cell.addto_play_list.frame=CGRectMake(45, 40, 34, 34);
						 }
						 completion:^(BOOL finished){
							 NSLog(@"Animation Done!");
							 // cell.twitter.hidden=YES;
							 // cell.facebook.hidden=YES;
							 cell.twitter.hidden=YES;
							 cell.facebook.hidden=YES;
							 cell.playmex.hidden=NO;
							 cell.addto_play_list.hidden=YES;
						 }];
		
		
	}
	//NSLog(@"UIGestureRecognizerStateBegan.");
	else{
		//Do Whatever You want on Began of Gesture
		self.currentIndex = indexPath;
		self.expandedCellHeight =  125;
		[songListTable beginUpdates];
		cell.twitter.hidden=YES;
		cell.playmex.hidden=YES;
		cell.facebook.hidden=YES;
		cell.addto_play_list.hidden=YES;
		
		
		lass.twitter.hidden=YES;
		lass.facebook.hidden=YES;
		lass.playmex.hidden=YES;
		lass.addto_play_list.hidden=YES;
		
		[songListTable endUpdates];
		cell.facebook.frame=CGRectMake(210, 40, 34, 34);
		cell.twitter.frame=CGRectMake(145, 40, 34, 34);
		cell.playmex.frame=CGRectMake(80, 40, 34, 34);
		cell.addto_play_list.frame=CGRectMake(45, 40, 34, 34);
		[UIView animateWithDuration:0.3
							  delay:0
							options: UIViewAnimationCurveEaseOut
						 animations:^{
							 cell.twitter.hidden=NO;
							 cell.facebook.hidden=NO;
							 cell.playmex.hidden=NO;
							 cell.addto_play_list.hidden=YES;
							 cell.twitter.frame=CGRectMake(145, 83, 34, 34);
							 cell.facebook.frame=CGRectMake(210, 83, 34, 34);
							 cell.playmex.frame=CGRectMake(80, 83, 34, 34);
							 cell.addto_play_list.frame=CGRectMake(45, 83, 34, 34);
							 
						 }
						 completion:^(BOOL finished){
							 
						 }];
	}
	

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
    
    songListObject * songItem = [self.playlistSongList objectAtIndex:selectedResultIndex];
    //top_label.hidden=NO;
    players = [[mokletdevPlayerViewController alloc]init];
    players.sSongId     = songItem.songId;
    players.sSongTitle  = songItem.songName;
	players.sArtistId   = songItem.artistId;
    players.sArtistName = songItem.artistName;
	players.sAlbumId    = songItem.albumId;
    players.sAlbumName  = songItem.albumName;
	//players.playTime    = songItem.playtime;
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
