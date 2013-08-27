//
//  topChartViewController.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/1/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "topChartViewController.h"
#import "AFNetworking.h"
#import "songListObject.h"
#import "NetraCell.h"

//const int kLoadingCellTag = 1273;
//bool firstLoad=1;

@interface topChartViewController ()

@end

@implementation topChartViewController

//@synthesize titleImage;
@synthesize topChartMutableArray;
@synthesize topChartMutableArrayResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topChartList=[[UITableView alloc]init];
		topChartList.delegate=self;
		topChartList.dataSource=self;
		topChartList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
        [self.view addSubview:topChartList];
		
		UIImage* image = [UIImage imageNamed:@"left"];
		CGRect frame = CGRectMake(20, 9, 26.5, 26.5);
		UIButton* leftbutton = [[UIButton alloc] initWithFrame:frame];
		[leftbutton setBackgroundImage:image forState:UIControlStateNormal];
		[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
		[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *leftbuttonView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 70, 44)];
		leftbuttonView.backgroundColor=[UIColor clearColor];
		[leftbuttonView addSubview:leftbutton];
		UIBarButtonItem* leftbarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonView];
		
		UIImage* image2 = [UIImage imageNamed:@"right"];
		CGRect frame2 = CGRectMake(55, 9, 26.5, 26.5);
		UIButton* rightbutton = [[UIButton alloc] initWithFrame:frame2];
		[rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
		[rightbutton setBackgroundImage:[UIImage imageNamed:@"right-push"] forState:UIControlStateHighlighted];
		[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
		
		UIImage* image3 = [UIImage imageNamed:@"search-button"];
		CGRect frame3 = CGRectMake(12, 10, 21.5, 23);
		searchButton = [[UIButton alloc] initWithFrame:frame3];
		[searchButton setBackgroundImage:image3 forState:UIControlStateNormal];
		[searchButton setBackgroundImage:[UIImage imageNamed:@"search-button-pressed"] forState:UIControlStateHighlighted];
		[searchButton addTarget:self action:@selector(searchSongs) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *RightbuttonView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 85, 44)];
		RightbuttonView.backgroundColor=[UIColor clearColor];
		[RightbuttonView addSubview:rightbutton];
		[RightbuttonView addSubview:searchButton];
        
		
		UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:RightbuttonView];
		
        
		[self.navigationItem setRightBarButtonItem:rightbarButton];
		[self.navigationItem setLeftBarButtonItem:leftbarbutton];
		
		
		[rightbarButton release];
		[rightbutton release];
		[leftbarbutton release];
		[leftbutton release];
		//self.navigationItem.title = @"Top Chart";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ambil data untuk topChart.
-(void)fetchChart{

	self.title=@"Top Chart";

	topChartList.hidden=YES;
	[self.topChartMutableArray removeAllObjects];
	//if(firstLoad==1){
		topChartList.hidden=YES;
	//}
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/songs/new?offset=%d&limit=10",current_page];
	NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily"];
	NSURL *URL=[NSURL URLWithString:baseUrl];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		total_page=[[responseObject objectForKey:@"totalSize"]intValue]/10;
        
		for(id netraDictionary in [responseObject objectForKey:@"dataList"]){
			
			songListObject *songListObjectData=[[songListObject alloc] initWithDictionary:netraDictionary];
			if (![self.topChartMutableArray containsObject:songListObjectData]) {
                [self.topChartMutableArray addObject:songListObjectData];
				
            }
			
			[songListObjectData release];
		}
		topChartList.hidden=NO;
		
		[topChartList reloadData];
		
		
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			NSLog(@"error---->%@",error);
			//[self.cell.loadingCell.hidden=YES];
			NSLog(@"Error: %@", [error localizedDescription]);
			[[[[UIAlertView alloc] initWithTitle:@"Error fetching Netra!"
										 message:@"Please try again later"
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
			
		}
		
	}];
	[operation start];
	[operation release];
	
}

// setel view table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row ==([self.topChartMutableArray count]))
	{
		return 44;
		[topChartList setSeparatorColor:[UIColor clearColor]];
		
	}
	else if (indexPath.row==selectedIndex){
		return 125;
	}
	else{
        return 77.5;
	}
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
        return self.topChartMutableArray.count + 1;
		
    }
	
    return self.topChartMutableArray.count;
	
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
	
	//if (cell.tag == kLoadingCellTag) {
		NSLog(@"kLoadingCellTag");
		current_page+=10;
		[self fetchChart];
		
        
	//}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row < self.topChartMutableArray.count) {
        return [self NetraCellForIndexPath:indexPath];
    } else {
		
        return [self loadingCell];
    }
}
- (UITableViewCell *)NetraCellForIndexPath:(NSIndexPath *)indexPath {
	NetraCell *cell       = [topChartList dequeueReusableCellWithIdentifier:@"Cell"];
	songListObject *dataObject=[self.topChartMutableArray objectAtIndex:indexPath.row];
	if (cell == nil)
	{
		cell= [[NetraCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
		//cell=[[[NetraCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ]autorelease];
	}
	int seconds = [dataObject.playtime intValue] % 60;
	int minutes = ([dataObject.playtime intValue] - seconds) / 60;
	NSLog(@"minutes---->%@",dataObject.playtime);
	cell.title.text=dataObject.songName;
	cell.excerpt.text=dataObject.artistName;
	cell.share.tag=indexPath.row;
	cell.albumName.text = dataObject.albumName;
	[cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	[cell.play addTarget:self action:@selector(playMe:) forControlEvents:UIControlEventTouchUpInside];
	[cell.share addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
	cell.play.tag=indexPath.row;
	NSString *baseUrls=[NSString stringWithFormat:@"http://melon.co.id/imageSong.do?songId=%@",dataObject.songId];
	[cell.thumbnail setImageWithURL:[NSURL URLWithString:baseUrls]
				   placeholderImage:[UIImage imageNamed:@"placeholder"]];
	
	UIView *selectionColor = [[UIView alloc] init];
	
	cell.length.text=[NSString stringWithFormat:@"%d : %d", minutes,seconds];
	
	cell.genre.text=dataObject.genreName;
	cell.length.hidden=YES;
    selectionColor.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-pushed"]];
    cell.selectedBackgroundView = selectionColor;
	cell.music.hidden=YES;
	cell.genre.hidden=YES;
	cell.facebook.hidden=YES;
	cell.twitter.hidden=YES;
	cell.twitter.tag=indexPath.row;
	[cell.twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
	[cell.facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
	if(selectedIndex==indexPath.row){
		cell.music.hidden=NO;
		cell.facebook.hidden=NO;
		cell.length.hidden=NO;
		cell.genre.hidden=NO;
		cell.twitter.hidden=NO;
    }
	return cell;
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
	//cell.tag = kLoadingCellTag;
    
    return cell;
}

@end
