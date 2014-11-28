//
//  downloadQueueViewController.m
//  melon
//
//  Created by Arie on 5/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "downloadQueueViewController.h"
#import "DownloadList.h"
#import "downloadQueTableCell.h"
#import "YLProgressBar.h"
#import "LocalPlaylist.h"
#import "YRDropdownView.h"
#import "mokletdevAppDelegate.h"

@interface downloadQueueViewController ()

@end

@implementation downloadQueueViewController

BOOL isTimerOff = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Custom initialization
	// Do any additional setup after loading the view.
	UIImageView * latar = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
	[latar setImage:[UIImage imageNamed:@"bg"]];
	[self.view addSubview:latar];
	
	
	top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
	top_label.backgroundColor=[UIColor clearColor];
	
	TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
	TitleBig.text=NSLocalizedString(@"Download Queue",nil);
	TitleBig.textAlignment=NSTextAlignmentCenter;
	TitleBig.backgroundColor=[UIColor clearColor];
	[TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
	TitleBig.textColor = [UIColor whiteColor];
	TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
	TitleBig.shadowOffset = CGSizeMake(0, 1.0);
	TitleBig.hidden=NO;
	
	[top_label addSubview:TitleBig];
		
	q=[[[UITableView alloc]init] autorelease];
	q.dataSource=self;
	q.delegate=self;
	q.separatorColor=[UIColor colorWithRed:0.204 green:0.204 blue:0.204 alpha:1];
	q.frame=CGRectMake(0, plView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-44);
	[q setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:q];
	
	UIImage* image = [UIImage imageNamed:@"left"];
	CGRect frame = CGRectMake(-5, 0, 44, 44);
	UIButton* leftbutton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
	
	
	UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
	leftbuttonView.backgroundColor=[UIColor clearColor];
	[leftbuttonView addSubview:leftbutton];
	UIBarButtonItem* leftbarbutton = [[[UIBarButtonItem alloc] initWithCustomView:leftbuttonView] autorelease];
	[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage* image2 = [UIImage imageNamed:@"right"];
	CGRect frame2 = CGRectMake(50, 0, 44, 44);
	UIButton* rightbutton = [[[UIButton alloc] initWithFrame:frame2] autorelease];
	[rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
	[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *RightbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)] autorelease];
	RightbuttonView.backgroundColor=[UIColor clearColor];
	[RightbuttonView addSubview:rightbutton];
	
	UIBarButtonItem* rightbarButton = [[[UIBarButtonItem alloc] initWithCustomView:RightbuttonView]  autorelease];
	
	
	[self.navigationItem setRightBarButtonItem:rightbarButton];
	[self.navigationItem setLeftBarButtonItem:leftbarbutton];
	
	
	// Custom initialization
	self.view.backgroundColor=[UIColor clearColor];
	
	[self fetch];
	// Do any additional setup after loading the view.
	mySongDownloader = [songDownloader sharedInstance];
    // check available download
    if ([mySongDownloader songInQueueAvailable] && ![mySongDownloader isDownloading])
    {
        NSLog(@"periksa download item.");
        [mySongDownloader startContinueDownload];
        isTimerOff = YES;
        //[self startDownloadProgressTimer:Nil];
        [self startDownloadProgressTimer:[mySongDownloader getDowloadListIndex]];
    }
    
    //tracking google analytics
    self.screenName = NSLocalizedString(@"Screen Name Download Queue", nil);

}

- (void) viewDidUnload
{
    if (!isTimerOff)
    {
        [timerDownloadProgress invalidate];
        isTimerOff = YES;
    }
}

- (void) startDownloadProgressTimer:(NSInteger)path
{
    if (!isTimerOff)
    {
        return;
    }
	//[timerDownloadProgress invalidate];
    NSLog(@"function : startDownloadProgressTimer.-->%d",path);
	NSString *inStr = [NSString stringWithFormat:@"%d", path];
    
    isTimerOff = NO;
    
    timerDownloadProgress = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                             target:self
                                                           selector:@selector(updateDownloadProgress:)
                                                           userInfo:inStr
                                                            repeats:YES];
}

-(void)updateDownloadProgress:(NSTimer*)theTimer{
	int percent = (int) [mySongDownloader getDownloadProgressPercentage];
	//NSString *a=(NSString*)[theTimer userInfo];
	//NSInteger myInt = [a intValue];
	NSString *str;
	str = [NSString stringWithFormat:@"%d",percent];
	NSMutableString *myString = [NSMutableString string];
	[myString appendString:str];
    NSInteger ekaIdx = [[songDownloader sharedInstance] getDowloadListIndex];
	//NSIndexPath *as = [NSIndexPath indexPathForRow:myInt inSection:0]; // I wanted to update this cell specifically
    NSIndexPath *as = [NSIndexPath indexPathForRow:ekaIdx inSection:0];
	downloadQueTableCell *c = (downloadQueTableCell *)[q cellForRowAtIndexPath:as];
	if(percent<100){
		c.downloadProgress.progress=((float) percent)/100;
		//NSLog(@"download percentage for index %@ percent----->%d", (NSString*)[theTimer userInfo],percent);
		 c.downloadedData.text =[NSString stringWithFormat:@"%@\%% selesai", myString];
	}
	if(percent==100){
		[q reloadData];
	}
}
-(void)viewWillAppear:(BOOL)animated{
	[TitleBig setHidden:NO];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];
    
    [self installNotification];
    
    if ([mySongDownloader isDownloading])
    {
        isTimerOff = YES;
        [self startDownloadProgressTimer:[mySongDownloader getDowloadListIndex]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetch{
	self.soangQueue = [NSMutableArray arrayWithArray:[DownloadList MR_findAllSortedBy:@"tanggal" ascending:NO]];
	//[q reloadData];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.soangQueue count];
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * tableIdentifier = @"downloadQueueCell";
    downloadQueTableCell * cell = [q dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        cell = [[downloadQueTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
      DownloadList * currentList = [self.soangQueue objectAtIndex:indexPath.row];
	
    if (self.soangQueue.count > 0)
    {
      
        cell.songTitle.text = currentList.songTitle;
        cell.songArtist.text = currentList.artistName;
        cell.downloadOKCancelButton.hidden = false;
        cell.downloadOKCancelButton.tag = indexPath.row;
        if ((int) currentList.status.intValue == 0)    // tunggu
        {
			
            //cell.downloadOKCancelButton.hidden = true;
            cell.downloadedData.text = [NSString stringWithFormat:@"waiting to be downloaded"];
            [cell.downloadOKCancelButton addTarget:self action:@selector(batalDownload:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"dlcancel"] forState:UIControlStateNormal];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"dlcancelhl"] forState:UIControlStateHighlighted];
            cell.downloadProgress.progressTintColor = [UIColor clearColor];
            cell.downloadProgress.progress = 20;
			cell.downloadProgress.hidden=NO;
			
        }
        else if ((int) currentList.status.intValue == 1) // on progress
        {
			NSLog(@"Progress");
			
             
            isTimerOff = YES;
			[self startDownloadProgressTimer:indexPath.row];
            [cell.downloadOKCancelButton addTarget:self action:@selector(batalDownload:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"dlcancel"] forState:UIControlStateNormal];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"dlcancelhl"] forState:UIControlStateHighlighted];
            cell.downloadedData.text = [NSString stringWithFormat:@"%@\%% selesai", currentList.finished];
            cell.downloadProgress.progressTintColor = [UIColor cyanColor];
			cell.downloadProgress.progress =20;
			cell.downloadProgress.hidden=NO;
			
        }
        else if ((int) currentList.status.intValue == 2) // error
        {
		
			
            [cell.downloadOKCancelButton addTarget:self action:@selector(lagiDownload:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"retrieve"] forState:UIControlStateNormal];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"retrievehl"] forState:UIControlStateHighlighted];
            cell.downloadedData.text = [NSString stringWithFormat:@"Error"];
            cell.downloadProgress.progressTintColor = [UIColor redColor];
			cell.downloadedData.hidden=YES;
			cell.downloadProgress.hidden=NO;
			
        }
        else if ((int) currentList.status.intValue == 3) // selesai
        {
			
            //[cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"retrieve"] forState:UIControlStateNormal];
            //[cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"retrievehl"] forState:UIControlStateHighlighted];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"success"] forState:UIControlStateNormal];
            [cell.downloadOKCancelButton setImage:[UIImage imageNamed:@"successhl"] forState:UIControlStateHighlighted];
			[cell.downloadOKCancelButton addTarget:self action:@selector(playme:) forControlEvents:UIControlEventTouchUpInside];
			
			cell.downloadOKCancelButton.tag=indexPath.row;
            cell.downloadedData.text = [NSString stringWithFormat:@"Selesai"];
            cell.downloadProgress.progressTintColor = [UIColor greenColor];
			cell.downloadProgress.progress=100;
			cell.downloadProgress.hidden=YES;
			cell.downloadedData.hidden=YES;
        }
        //cell.downloadProgress.progress = mySongDownloader.getDownloadProgressPercentage;
        cell.downloadProgress.progress = currentList.finished.floatValue;
    }
	else{
		[timerDownloadProgress invalidate];
        isTimerOff = YES;
	}

    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) batalDownload: (id) sender
{
    // batalkan dan hapus dari daftar muat turun.
    [mySongDownloader setCancelCurrentDownload];
    //[self performSelector:@selector(henti) withObject:nil afterDelay:0];
    
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DownloadList * currentList = [self.soangQueue objectAtIndex:[sender tag]];
    
    DownloadList * listToRemove = [DownloadList MR_findFirstByAttribute:@"songId" withValue:currentList.songId inContext:localContext];
    if (listToRemove)
    {
        [listToRemove MR_deleteEntity];
        [localContext MR_saveNestedContexts];
    }
    NSLog(@"[sender tag] : %d", [sender tag]);
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.soangQueue removeObjectAtIndex:[sender tag]];
    [q deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.m4a", appDelegate.eUserId ,currentList.songId]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filepath error:NULL];
}

-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)playme:(id)sender{
	[YRDropdownView showDropdownInView:self.view
								 title:@"Informasi"
								detail:@"klik menu Semua Lagu untuk memainkan lagu yang sudah didownload"
								 image:[UIImage imageNamed:@"dropdown-alert_success"]
					   backgroundImage:[UIImage imageNamed:@"allow"]
							  animated:YES
							 hideAfter:3];

}

- (void) muatTurunSelesai:(NSNotification *) Notification
{
    [self performSelector:@selector(henti) withObject:nil afterDelay:0.5];
}

- (void) startTimer: (NSNotification *) Notification
{
    if ([mySongDownloader isDownloading])
    {
        [self startDownloadProgressTimer:[mySongDownloader getDowloadListIndex]];
    }
}

- (void) stopTimer: (NSNotification *) Notification
{
    [self henti];
}

- (void) henti
{
    if (!isTimerOff)
    {
        @try {
            [timerDownloadProgress invalidate];
            isTimerOff = YES;
        }
        @catch (NSException *exception) {
            NSLog(@"Error manakala hapus timer di downloadQueueViewController");
        }
        
    }
    
    [q reloadData];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self henti];
    [self removeNotification];
}

- (void) installNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(muatTurunSelesai:)
                                                name:@"SemuaMuatTurunSelesai"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(startTimer:)
                                                name:@"startDownload"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(stopTimer:)
                                                name:@"finishedDownloadASong"
                                              object:nil];
}

- (void) removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"SemuaMuatTurunSelesai"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"startDownload"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"finishedDownloadASong"
                                                 object:nil];
}

@end
