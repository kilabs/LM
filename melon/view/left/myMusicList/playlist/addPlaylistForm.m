//
//  addPlaylistForm.m
//  melon
//
//  Created by Arie on 5/19/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "addPlaylistForm.h"
#import "PlaylistBrief.h"
#import "AFNetworking.h"
#import "EUserBrief.h"
#include "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@interface addPlaylistForm ()

@end

@implementation addPlaylistForm
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
		self.view.frame=CGRectMake(0, 0, 300, 160);
		UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
		header.backgroundColor=[UIColor colorWithRed:0.871 green:0.871 blue:0.871 alpha:1];
		[self.view addSubview:header];
		
		UIView *border=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 300, 1)];
		border.backgroundColor=[UIColor colorWithRed:0.765 green:0.765 blue:0.765 alpha:1];
		[self.view addSubview:border];
		
		UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
		[title setFont: [UIFont fontWithName:@"OpenSans-Bold" size:18]];
		title.textAlignment=NSTextAlignmentCenter;
		title.textColor=[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1];
		title.backgroundColor=[UIColor clearColor];
		title.text=@"Tambah Playlist";
		[header addSubview:title];
		
		playlist=[[UITextField alloc]initWithFrame:CGRectMake(25, 60, 250, 33)];
		playlist.placeholder=@"contoh: playlistku atau Playlist Terkenal";

		playlist.returnKeyType=UIReturnKeyDone;
		//playlist.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
		playlist.backgroundColor=[UIColor whiteColor];
		[playlist setFont: [UIFont fontWithName:@"OpenSans-Bold" size:14]];
		playlist.delegate=self;
		
		playlist.layer.borderColor=[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1].CGColor;
		playlist.layer.borderWidth=0.7f;
		playlist.layer.sublayerTransform = CATransform3DMakeTranslation(10, 7, 0);
		[self.view addSubview:playlist];
		
		tambah=[UIButton buttonWithType:UIButtonTypeCustom];
		tambah.frame=CGRectMake(75, self.view.frame.size.height-54, 150, 44);
		[tambah.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
		[tambah setBackgroundImage:[[UIImage imageNamed:@"common-navbar"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
		tambah.clipsToBounds = YES;
		tambah.layer.cornerRadius = 3;//half of the width
		tambah.layer.borderColor=[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1].CGColor;
		tambah.layer.borderWidth=0.7f;
		[tambah setTitle:@"Tambah" forState:UIControlStateNormal];
		[tambah addTarget:self action:@selector(tambah) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:tambah];
		//[self.view addSubview:tambah];
        // Custom initialization
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
        [textField resignFirstResponder];
        return YES;
   
}
-(void)tambah{
	if(playlist.text.length<=0){
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
														  message:@"KOSONG"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		[message show];
	}
	else{
		[self addPlaylist:playlist.text];
			
	}
	
}
-(void)addPlaylist:(NSString*)playlistname{
	NSLog(@"playlist--->%@",playlistname);
	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];
	NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
							  playlistname, @"playlistName",
							  @"", @"songId",
							  nil] autorelease];

    
	// NSString * offset = [NSString stringWithFormat:@"%d", (current_page -1) * 10];
    //NSString * limit = @"10";
    
    NSString * sURL = [NSString stringWithFormat:@"%@%@/playlists?_CNAME=%@&&_CPASS=%@&_DIR=cu&_UNAME=%@&_UPASS=%@", [NSString stringWithUTF8String:MAPI_SERVER], user_now.userId, [NSString stringWithUTF8String:CNAME], [NSString stringWithUTF8String:CPASS], user_now.username,user_now.webPassword];
    NSLog(@"surls--->%@",sURL);
	NSURL *URL=[NSURL URLWithString:sURL];
	NSString *properlyEscapedURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"--->%@",properlyEscapedURL);
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:properlyEscapedURL parameters:params];
	NSLog(@"surls--->%@",request);
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response object-->%@",[responseObject objectForKey:@"message"]);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"commit" object:nil];
        		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        
		NSLog(@"error: %@", [error description]);
		
	}];
    
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];

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

@end
