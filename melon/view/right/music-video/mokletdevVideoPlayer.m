//
//  mokletdevViewController.m
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevViewController.h"
#import "AFNetworking.h"
//#import "songListObject.h"
#import "VideoBrief.h"
#import <social/Social.h>
#import <accounts/Accounts.h>
#include "Encryption.h"
#include "GlobalDefine.h"
#import "MelonPlayer.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Twitter/Twitter.h>
#include "StreamingBrief.h"
#import "mokletdevAppDelegate.h"
#import "localplayer.h"
#import "MelonPlayer.h"
#import "YRDropdownView.h"
#import "netracell_.h"
const int kLoadingCellTags = 1273;
bool firstLoads=1;
bool fetchs=0;
bool searchs=0;
bool openeds=0;
bool search_actives=0;
NSString * bitRateCDs;
NSString * codecTypeCDs;
NSString * contentIDs;
NSString * errorCodes;
NSString * fullTrackYNs;
NSString * playtimes;
NSString * samplings;
NSString * sessionIDs;

enum eTableContentType currTableContentType;
enum eTableContentType lastTableContentType;

enum eTableContentType {
    NEWRELEASE = 0,
    TOPCHART
};

@interface mokletdevVideoPlayer ()
{
@private
    //songListObject * currentSong;
    VideoBrief  * currentVideo;
}
@end

@implementation mokletdevVideoPlayer


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
        spinner.hidesWhenStopped = YES;
        [spinner setColor:[UIColor colorWithRed:0.478 green:0.651 blue:0.176 alpha:1]];
        [spinner setInnerRadius:10];
        [spinner setOuterRadius:20];
        [spinner setStrokeWidth:8];
		[spinner setCenter:CGPointMake(160.0,180.0)];
        [spinner setNumberOfStrokes:8];
        [spinner setPatternLineCap:kCGLineCapButt];
		//        [spinner setSegmentImage:[UIImage imageNamed:@"Stick.jpeg"]];
        [spinner setPatternStyle:TJActivityIndicatorPatternStyleBox];
		[spinner startAnimating];
		
		[self.view addSubview:spinner];

		//UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
		searchView=[[UIView alloc]initWithFrame:CGRectMake(0, -50, 320, 40)];
		searchView.backgroundColor=[UIColor blackColor];
		
		MelonListVideo=[[UITableView alloc]init];
		MelonListVideo.delegate=self;
		MelonListVideo.dataSource=self;
		MelonListVideo.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
		[MelonListVideo setSeparatorColor:[UIColor clearColor]];
		[MelonListVideo setSeparatorColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1]];
		MelonListVideo.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
		MelonListVideo.hidden=YES;
		[self.view addSubview:MelonListVideo];
		
		currIndex=-1;
        lastIndex = -1;
		
		UITapGestureRecognizer* tapCount = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		tapCount.numberOfTapsRequired = 2;
		tapCount.numberOfTouchesRequired = 1;
		[MelonListVideo addGestureRecognizer:tapCount];
		
		//self.titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 142, 24.5)];
		//[self.titleImage setImage:[UIImage imageNamed:@"topChart"]];
		
		//selectedCellIndexPath=[[NSIndexPath alloc]init];
		
		UIImage* image = [UIImage imageNamed:@"left"];
		CGRect frame = CGRectMake(-5, 0, 44, 44);
		UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame];
		[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
		//[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
		[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
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
		
		UIView *RightbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)] autorelease];
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
		[self fetchData];
        isLoadingData = YES;
        loadingDataTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                            target:self
                                                          selector:@selector(loadingTimeUp:)
                                                          userInfo:nil
                                                           repeats:YES];
        loadTimerisON = YES;
		
        lastTableContentType = NEWRELEASE;
		self.myVideoList=[NSMutableArray array];
		top_label=[[UIView alloc]initWithFrame:CGRectMake(45, 0, 186, 44)];
		top_label.backgroundColor=[UIColor clearColor];
		
		TitleBig=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)];
		TitleBig.text=@"Music Video";
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
-(void)searchSongs{
	
	searchWindow=[[[mokletdevSearchMusicController alloc]init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:searchWindow] autorelease];
	
    [self presentModalViewController:navigationController animated:YES];
	
	
}



- (void)dismiss {
	NSLog(@"321");
	
}


-(void)fetchData{
    NSString * offset = [NSString stringWithFormat:@"%d", (current_page -1) * 10];
    NSString * limit = @"10";
    
    NSString * sURL = [NSString stringWithFormat:@"%@mvs/new/converted", [NSString stringWithUTF8String:MAPI_SERVER]];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              offset, @"offset",
                              limit, @"limit",
                              @"c", @"_DIR",
                              @"iOS Client", @"_CNAME",
                              @"DC6AE040A9200D384D4F08C0360A2607", @"_CPASS",
                              nil] autorelease];
    
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/mvs/new?offset=%d&limit=10&_DIR=c&_CNAME=iOS+Client&_CPASS=DC6AE040A9200D384D4F08C0360A2607",current_page];
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily?offset=%d&limit=10",current_page];
	
	NSURL *URL=[NSURL URLWithString:sURL];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"data video: %@", responseObject);
		total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
        NSLog(@"total_page = %d", total_page);
        currentSongId = @"0";
		for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
			//NSLog(@"responseObject-->%@",responseObject);
			//songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
            VideoBrief * videoListObjectData = [[VideoBrief alloc] initWithDictionary:netraDictionary];
			if (![self.myVideoList containsObject:videoListObjectData]) {
                [self.myVideoList addObject:videoListObjectData];
				
            }
			
			[videoListObjectData release];
		}
		
		[spinner stopAnimating];
        slowConnectionView.hidden = YES;
		MelonListVideo.hidden=NO;
        [MelonListVideo reloadData];
		isLoadingData = NO;
        slowConnectionView.hidden = YES;
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
            slowConnectionView.hidden = YES;
			[YRDropdownView showDropdownInView:self.view
										 title:@"Galat"
										detail:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										 image:[UIImage imageNamed:@"dropdown-alert"]
									  animated:YES
									 hideAfter:1];
			[spinner stopAnimating];
            slowConnectionView.hidden = YES;
			
		}
        NSLog(@"error: %@", [error description]);
		isLoadingData = NO;
        slowConnectionView.hidden = YES;
	}];
    
	[operation start];
	[operation release];
    [httpClient release];
    currTableContentType = NEWRELEASE;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if (current_page == 0) {
        return 1;
    }
    
    if (current_page < total_page) {
        return self.myVideoList.count + 1;
		
    }
	
    return self.myVideoList.count;
	
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
	
	if (cell.tag == kLoadingCellTags) {
		
		current_page+=10;
		[self fetchData];
		
		
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row < self.myVideoList.count) {
        return [self NetraCellForIndexPath:indexPath];
    } else {
		
        return [self loadingCell];
    }
}
- (UITableViewCell *)NetraCellForIndexPath:(NSIndexPath *)indexPath {
	netracell_ *cell       = [MelonListVideo dequeueReusableCellWithIdentifier:@"Cell"];
	//songListObject *dataObject=[self.myVideoList objectAtIndex:indexPath.row];
    VideoBrief * dataObject = [self.myVideoList objectAtIndex:indexPath.row];
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
	//int seconds = [dataObject.playtime intValue] % 60;
	//int minutes = ([dataObject.playtime intValue] - seconds) / 60;
	cell.title.text=dataObject.songName;
	cell.excerpt.text=dataObject.artistName;
	cell.albumName.text = dataObject.albumName;
	cell.download.hidden=YES;
	cell.play.hidden=YES;
	[cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	//[cell.share addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
	cell.play.tag=indexPath.row;
	//NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
    NSString *baseUrls = [NSString stringWithFormat:@"%@image.do?fileuid=%@", [NSString stringWithUTF8String:WEB_SERVER], dataObject.vodLImgPath];
	[cell.thumbnail setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];
	
	//cell.length.text=[NSString stringWithFormat:@"%d : %d", minutes,seconds];
	
	//cell.genre.text=dataObject.;
	cell.length.hidden=YES;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.music.hidden=YES;
	cell.genre.hidden=YES;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.twitter.tag=indexPath.row;
	//cell.mail.tag=indexPath.row;
	cell.facebook.tag=indexPath.row;
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
		return cell;
	
	
}

-(void)doubleTap:(id)sender{
	
}
-(void)sendMail:(id)sender{
	if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
		[[mailer navigationBar] setTintColor:[UIColor blackColor]];
		
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Greetings From Melon"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:nil];
        [mailer setToRecipients:toRecipients];
        
        
        
        NSString *emailBody = @"HEy! Please Download Melon IOs App";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        // mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController presentModalViewController:mailer animated:YES];
        
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
	
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}
-(void)twitterShare:(id)sender
{
    
}

-(void)facebookShare:(id)sender
{
    
}
-(void)showShare:(id)sender
{
    
}

-(void)download:(id)sender
{
    
	
}

-(void)playMe:(id)sender{
    
}

- (UITableViewCell *)loadingCell {
	
	
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:nil] autorelease];
    cell.userInteractionEnabled = NO;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator release];
    
    [activityIndicator startAnimating];
	cell.tag = kLoadingCellTags;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.myVideoList count]))
	{
		return 44;
		[MelonListVideo setSeparatorColor:[UIColor clearColor]];
		
	}
	else{
		return 153/2;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	//[[MelonPlayer sharedInstance].streamer stop];
	//[[localplayer sharedInstance] stop];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[MelonPlayer sharedInstance] stop];
    
    // get the link
    
    VideoBrief * selectedVideo = [self.myVideoList objectAtIndex:indexPath.row];
    //NSString * myURL = [NSString stringWithFormat:@"http://www.melon.co.id/streamer.mp4?vodId=%@", selectedVideo.songVodId];
    NSString * myURL = [NSString stringWithFormat:@"http://www.melon.co.id/progstream.mp4?vodId=%@", selectedVideo.songVodId];
    //NSString * myURL = [NSString stringWithFormat:@"http://www.melon.co.id/streamerIOS.do?vodId=%@", selectedVideo.songVodId];
    //NSString * myURL = [NSString stringWithFormat:@"http://www.melon.co.id/streamer.mp4?vodId=7145"];
    
    //UIViewController *vc = [[UIViewController alloc] init];
    //[self presentModalViewController:vc animated:NO];
    //[self dismissModalViewControllerAnimated:NO];
    players = [[[MelonVideoPlayerViewController alloc]init] autorelease];
    [players setVideoUrl:myURL];
    players.videoTitle  = selectedVideo.songName;
    players.videoArtist = selectedVideo.artistName;
    players.videoAlbum  = selectedVideo.albumName;
    [self.navigationController pushViewController:players animated:YES];

}

-(void)goingtoPlayers:(NSInteger)data{
	top_label.hidden=YES;
	//VideoBrief * dataObject = [self.myVideoList objectAtIndex:data];
	players = [[[MelonVideoPlayerViewController alloc]init] autorelease];
    
	
	[self.navigationController pushViewController:players animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
	
	top_label.hidden=NO;
	// this will appear as the title in the navigation bar
	
	
	//self.navigationItem.titleView = top_label;
	[self.navigationController.navigationBar addSubview:top_label];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [spinner stopAnimating];
        slowConnectionView.hidden = NO;
    }
}

@end
