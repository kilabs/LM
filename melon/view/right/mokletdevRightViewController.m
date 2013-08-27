//
//  mokletdevRightViewController.m
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "mokletdevRightViewController.h"
#import "mokletdevCellRight.h"
#import "MelonPlayer.h"
#import "localplayer.h"
#import "AFNetworking.h"
#import "LocalPlaylist1.h"
#import "mokletdevAppDelegate.h"


@interface mokletdevRightViewController ()

@end

@implementation mokletdevRightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.backgroundColor=[UIColor colorWithRed:0.282 green:0.282 blue:0.286 alpha:1] ;
		
		MelonListRight=[[UITableView alloc]init];
		MelonListRight.scrollEnabled = NO;
		MelonListRight.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
		MelonListRight.backgroundColor=[UIColor colorWithRed:0.282 green:0.282 blue:0.286 alpha:1] ;
		MelonListRight.separatorColor=[UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1];
		MelonListRight.dataSource=self;
		MelonListRight.delegate=self;
		[self.view addSubview:MelonListRight];
		
		miniplayer =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width, 130)];
		miniplayer.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
		miniplayer.hidden=YES;
		[self.view addSubview:miniplayer];
		UITapGestureRecognizer *singleFingerTap =
		[[UITapGestureRecognizer alloc] initWithTarget:self
												action:@selector(backtoBig:)];
		
		player_button=[[UIView alloc]initWithFrame:CGRectMake(0, miniplayer.frame.size.height-44.5, self.view.frame.size.width, 44.5)];
		player_button.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
		[miniplayer addSubview:player_button];
		[miniplayer addGestureRecognizer:singleFingerTap];
		[singleFingerTap release];
		UIView *border_top=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		UIView *border_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 1)];
		border_top.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
		border_bottom.backgroundColor=[UIColor colorWithRed:0.4 green:0.404 blue:0.427 alpha:0.2];
		[player_button addSubview:border_top];
		[player_button addSubview:border_bottom];
		
		image=[[UIImageView alloc]initWithFrame:CGRectMake(75, 5, 75, 75)];
		[image setImage:[UIImage imageNamed:@"placeholder"]];
		[miniplayer addSubview:image];
		
		song_title=[[UILabel alloc]init];
		song_title.backgroundColor=[UIColor clearColor];
		song_title.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		song_title.highlightedTextColor=[UIColor colorWithRed:0.318 green:0.318 blue:0.318 alpha:1];
		song_title.textAlignment=NSTextAlignmentLeft;
		song_title.numberOfLines=1;
		//title.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
		[song_title setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
		song_title.frame=CGRectMake(160, 5, 150, 30);
		song_title.backgroundColor=[UIColor clearColor];
		song_title.lineBreakMode=NSLineBreakByWordWrapping;
		//[song_title setText:@"Mystique by riri mestikasdasd"];
		[miniplayer addSubview:song_title];
		
		singer=[[UILabel alloc]init];
		singer.backgroundColor=[UIColor clearColor];
		singer.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		singer.highlightedTextColor=[UIColor colorWithRed:0.318 green:0.318 blue:0.318 alpha:1];
		singer.textAlignment=NSTextAlignmentLeft;
		singer.numberOfLines=1;
		//title.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
		[singer setFont:[UIFont fontWithName:@"OpenSans" size:13]];
		singer.frame=CGRectMake(160, 25, 150, 30);
		singer.backgroundColor=[UIColor clearColor];
		singer.lineBreakMode=NSLineBreakByWordWrapping;
		//[singer setText:@"Mystique by riri mestikasdasd"];
		[miniplayer addSubview:singer];
		
		slider = [[[UISlider alloc] initWithFrame:CGRectMake(160, 50.0, 100.0, 10)] autorelease];
		
		[slider setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlStateNormal];
		[slider setThumbImage:[UIImage imageNamed:@"playerprogressthumb"] forState:UIControlEventTouchUpInside];
		[slider setMinimumTrackImage: [UIImage imageNamed:@"playerprogressprogress"] forState: UIControlStateNormal];
		[slider setMaximumTrackImage: [UIImage imageNamed:@"playerprogressbg"] forState: UIControlStateNormal];
		slider.minimumValue=0;
		slider.value=0;
		[miniplayer addSubview:slider];
		
		time = [[[UILabel alloc] initWithFrame:CGRectMake(270, 50, 80.0, 30.0)] autorelease];
		time.text = @"00:00";
		time.textColor = [UIColor whiteColor];
		time.backgroundColor = [UIColor clearColor];
		[time setFont:[UIFont fontWithName:@"OpenSans" size:13]];
		[miniplayer addSubview:time];
		
		btnPlayPause = [[[UIButton alloc] initWithFrame:CGRectMake(155.0, 0, 69.0, 47.0)] autorelease];
		[btnPlayPause setBackgroundImage:[UIImage imageNamed:@"playerplaybtn"] forState:UIControlStateNormal];
		[btnPlayPause setBackgroundImage:[UIImage imageNamed:@"playerpausebtn"] forState:UIControlStateSelected];
		[btnPlayPause addTarget:self action:@selector(doPlayPause) forControlEvents:UIControlEventTouchUpInside];
		[player_button addSubview:btnPlayPause];
		
		btnNext = [[[UIButton alloc] initWithFrame:CGRectMake(215.0, 5, 40.0, 40.0)] autorelease];
		[btnNext setBackgroundImage:[UIImage imageNamed:@"playernextbtn"] forState:UIControlStateNormal];
		[btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
		[player_button addSubview:btnNext];
		
		btnPrev = [[[UIButton alloc] initWithFrame:CGRectMake(120, 5, 40.0, 40.0)] autorelease];
		[btnPrev setBackgroundImage:[UIImage imageNamed:@"playerprevbtn"] forState:UIControlStateNormal];
		[btnPrev addTarget:self action:@selector(doPrev) forControlEvents:UIControlEventTouchUpInside];
		[player_button addSubview:btnPrev];

		
		
		
    }
    return self;
}
- (void)backtoBig:(UITapGestureRecognizer *)recognizer {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"bigPlayer" object:nil];
	[self.sidePanelController showCenterPanel:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    headerView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"header_view"]];
	
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(80,12, 200, 20)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor=[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    label.text=@"Melon Menu";
	[label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
	label.layer.shadowOpacity = 1.0;
	label.layer.shadowRadius = 1.0;
	label.layer.shadowColor = [UIColor blackColor].CGColor;
	label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	
	UIView *border_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320,1)];
	border_bottom.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	[headerView addSubview:border_bottom];
    [headerView addSubview:label];
    return headerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

	dummyData=[[NSMutableArray alloc]init];
	[dummyData addObject:@"New Release"];
	[dummyData addObject:@"Top Chart"];
	[dummyData addObject:@"Search Music"];
	[dummyData addObject:@"Promos"];
	[dummyData addObject:@"Music Videos"];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initPlaying:)
												name:@"playingmini"
											  object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hide) name:@"hide"object:nil];
	
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playingNewSong:)
//                                                 name:@"PlayNewSong"
//                                               object:nil];
    
	[MelonListRight reloadData];
	// Do any additional setup after loading the view.
    
}

- (void) playingNewSong:(NSNotification *)notification
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    LocalPlaylist1 * song = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
    [song_title setText: song.songTitle];
    [singer setText: song.artistName];
    singer.hidden = NO;
    [image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",song.songId]]]]];
}
- (void) doNext
{
    if (![[MelonPlayer sharedInstance] isGettingNewSong])
    {
        [[MelonPlayer sharedInstance] doNext];
    }
}

- (void) doPrev
{
    if (![[MelonPlayer sharedInstance] isGettingNewSong])
    {
        [[MelonPlayer sharedInstance] doPrev];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//return 62.5;
	return 44;
	
}
- (void) doPlayPause
{
    if (![[MelonPlayer sharedInstance] isGettingNewSong])
    {
        if ([[MelonPlayer sharedInstance] isPlaying])
        {
            [[MelonPlayer sharedInstance] pause];
        }
        else
        {
            [[MelonPlayer sharedInstance] play];
        }
        
    }
    return;
	
	if([self.statusa isEqualToString:@"1"]){
		btnPlayPause.selected = !btnPlayPause.selected;
		if ([MelonPlayer sharedInstance].isPlaying)
		{
			[[MelonPlayer sharedInstance] pause];
		}
		else
		{
			[[MelonPlayer sharedInstance] play];
		}
	}
	else if([self.statusa isEqualToString:@"0"]){
		btnPlayPause.selected = !btnPlayPause.selected;
		if ([localplayer sharedInstance].isPlaying)
		{
			[[localplayer sharedInstance] pause];
		}
		else
		{
			[[localplayer sharedInstance] play];
		}
	}
	
}
-(void)hide{
	[[localplayer sharedInstance] destroyStreamer];
	[miniplayer setHidden:YES];
}
-(void)setImage:(NSString*)songId{
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",songId];
	//NSLog(@"songID-------------------->%@",songId);
	[image setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
-(void)initPlaying:(NSNotification *)notification{
    
	NSMutableArray *dict = (NSMutableArray*)notification.object;
	NSLog(@"dict--->%@",dict);
	[song_title setText:[dict objectAtIndex:1]];
	[singer setText:[dict objectAtIndex:2]];
	[miniplayer setHidden:NO];
	if([[dict objectAtIndex:0] isEqualToString:@"1"]){
		self.statusa=[NSString stringWithFormat:@"1"];
		[self setImage:[dict objectAtIndex:3]];
		//[self createTimer];
		//NSLog(@"ini lagi play stream");
		//[self doPlayPause:1];
		if([MelonPlayer sharedInstance].isPlaying){
			btnPlayPause.selected = YES;
			//NSLog(@"i'm stream");
			
		}
		else{
			btnPlayPause.selected = NO;
		}
		//[self createTimer];

	}
	else{
		NSLog(@"local");
		self.statusa=[NSString stringWithFormat:@"0"];
		[self setImage:[dict objectAtIndex:3]];
		//[self createTimerLocal];
		NSLog(@"ini lagi play local");
		//[self doPlayPause:1];
		if([localplayer sharedInstance].isPlaying){
			btnPlayPause.selected = YES;
			//NSLog(@"i'm stream");
			
		}
		else{
			btnPlayPause.selected = NO;
		}
		//[self createTimer];

	}
    
    [self createTimer];
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    LocalPlaylist1 * song = (LocalPlaylist1 *) [appDelegate.nowPlayingPlaylistDefault objectAtIndex:appDelegate.nowPlayingSongIndex];
    [song_title setText: song.songTitle];
    [singer setText: song.artistName];
    singer.hidden = NO;
    [image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",song.songId]]]]];
    [self setImage:song.songId];
}
- (void) createTimer
{
    if ([MelonPlayer sharedInstance])
    {
		[progressUpdateTimer invalidate];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateProgress:)
                                                             userInfo:nil
                                                              repeats:YES];
        
    }
}
- (void) updateProgress: (NSTimer *) updateTimer
{
    if ([MelonPlayer sharedInstance].isPlaying)
    {
       btnPlayPause.selected = YES;
    }
    else
    {
       btnPlayPause.selected = NO;
    }
    
    //if ([MelonPlayer sharedInstance].streamer.bitRate != 0.0)
    //{
        double progress = [MelonPlayer sharedInstance].getSongPlayProgress;
        double duration = [MelonPlayer sharedInstance].getSongDuration;
        int mm = (int) (progress / 60);
        int ss = (int) fmod(progress, 60);
        
        
        if (duration > 0)
        {
            [time setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
            [slider setValue:(progress/duration) animated:YES];
        }
		
    //}
}
- (void) createTimerLocal
{
    if ([localplayer sharedInstance])
    {
		[progressUpdateTimer invalidate];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateProgressLocal:)
                                                             userInfo:nil
                                                              repeats:YES];
        
    }
}

- (void) updateProgressLocal: (NSTimer *) updateTimer
{
	if ([localplayer sharedInstance].isPlaying)
	{
		btnPlayPause.selected = YES;
		[slider setValue:[[localplayer sharedInstance] timeInterval] / [[localplayer sharedInstance] duration]];
		
		//[//playingTime setText:[NSString stringWithFormat:@"%@", [self formatTime:[localPlayer timeInterval]]]];
		//[playingTime setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
		//[songProgress setValue:(progress/duration) animated:YES];
	}
	else
	{
		btnPlayPause.selected = NO;
	}
	
	double progress = [[localplayer sharedInstance] timeInterval];
	double duration = [[localplayer sharedInstance] duration];
	int mm = (int) (progress / 60);
	int ss = (int) fmod(progress, 60);
	
	
	if (duration > 0)
	{
		[time setText:[NSString stringWithFormat:@"%02d:%02d", mm, ss]];
		[slider setValue:(progress/duration) animated:YES];
	}
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)viewWillAppear:(BOOL)animated{
	NSLog(@"view will appear at mokletdevRightViewController.");
}
-(void)viewWillDisappear:(BOOL)animated{
	//[super dealloc];
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dummyData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    mokletdevCellRight *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
	    cell=[[mokletdevCellRight alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	NSString *cellValue = [dummyData objectAtIndex:indexPath.row];
	cell.contentRight.text=cellValue;
	
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor =[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
    cell.selectedBackgroundView = selectionColor;
	
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
	
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSMutableArray *dataPass=[[NSMutableArray alloc]init];
	static NSString *CellIdentifier = @"Cell";
    
    mokletdevCellRight *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.separators.backgroundColor=[UIColor clearColor];
	if(indexPath.row==0){
		[dataPass addObject:@"mokletdevViewController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];	
	}
	if(indexPath.row==1){
		[dataPass addObject:@"topChartViewController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
	}
	if(indexPath.row==2){
		[dataPass addObject:@"mokletdevSearchMusicController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
	}
	if(indexPath.row==3){
		NSURL *url = [NSURL URLWithString:@"http://www.melon.co.id/event/ongoing/list.do"];
		[[UIApplication sharedApplication] openURL:url];
		
	}
	if(indexPath.row==4){
		[dataPass addObject:@"mokletdevVideoPlayer"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
	}
	[self.sidePanelController showCenterPanel:YES];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
