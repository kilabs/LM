//
//  mokletdevServiceController.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevServiceController.h"
#import "AFNetworking.h"
#import "mokletdevAppDelegate.h"
#import "GlobalDefine.h"

@interface mokletdevServiceController ()

@end

@implementation mokletdevServiceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		
		//[RightbuttonView addSubview:searchbutton];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];
    
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isGetLayanan)
    {
        NSString * str;
        str = [appDelegate.eLayanan.paymentProdName length] == 0 ? @" Tak ada produk. " : appDelegate.eLayanan.paymentProdName;
        //[self.productname setText: appDelegate.eLayanan.paymentProdName];
        [self.productname setText:str];
        str = [appDelegate.eLayanan.payUserNickname length] == 0 ? appDelegate.eUserName : appDelegate.eLayanan.payUserNickname;
		//[self.UserHistory setText: appDelegate.eLayanan.payUserNickname];
        [self.UserHistory setText:str];
		[self.periode_start setText: [NSString stringWithFormat:@"%@ -- %@", appDelegate.eLayanan.useStartDate, appDelegate.eLayanan.useEndDate]];
		//[self.periode_end setText: eLayanan.useEndDate];
		
		NSInteger limitDownload= [appDelegate.eLayanan.limitDown integerValue];
		NSInteger limitDownCnt= [appDelegate.eLayanan.limitDownCnt integerValue];
		NSLog(@"liimitDownload--->%d",limitDownload);
		if(limitDownload==-1){
			[self.kredit setText : @"Unlimited"];
		}
		else{
            NSString *inStr = [NSString stringWithFormat:@"%d", limitDownload-limitDownCnt];
			[self.kredit setText : inStr];
		}
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
    top_label.backgroundColor=[UIColor clearColor];
    
    TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
    TitleBig.text=@"Service List";
    TitleBig.textAlignment=NSTextAlignmentCenter;
    TitleBig.backgroundColor=[UIColor clearColor];
    [TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19]];
    TitleBig.textColor = [UIColor whiteColor];
    TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
    TitleBig.shadowOffset = CGSizeMake(0, 1.0);
	    
    [top_label addSubview:TitleBig];
    // Custom initialization
	
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    UIImage* image = [UIImage imageNamed:@"left"];
    CGRect frame = CGRectMake(-5, 0, 44, 44);
    UIButton* leftbutton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [leftbutton setBackgroundImage:image forState:UIControlStateNormal];
	[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
    //[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
    //[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
    leftbuttonView.backgroundColor=[UIColor clearColor];
    [leftbuttonView addSubview:leftbutton];
    UIBarButtonItem* leftbarbutton = [[[UIBarButtonItem alloc] initWithCustomView:leftbuttonView] autorelease];
    
    UIImage* image2 = [UIImage imageNamed:@"right"];
    CGRect frame2 = CGRectMake(50, 0, 44, 44);
    UIButton* rightbutton = [[[UIButton alloc] initWithFrame:frame2] autorelease];
    [rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];
	[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
    //[rightbutton setBackgroundImage:[UIImage imageNamed:@"right-push"] forState:UIControlStateHighlighted];
    //[rightbutton addTarget:self action:@selector(rightbuttonPush) forControlEvents:UIControlEventTouchUpInside];
    /*
     UIImage* image3 = [UIImage imageNamed:@"search-button"];
     CGRect frame3 = CGRectMake(5, 0, 44, 44);
     searchbutton = [[UIButton alloc] initWithFrame:frame3];
     [searchbutton setBackgroundImage:image3 forState:UIControlStateNormal];
     //[searchbutton setBackgroundImage:[UIImage imageNamed:@"search-button-pressed"] forState:UIControlStateHighlighted];
     [searchbutton addTarget:self action:@selector(searchSongs) forControlEvents:UIControlEventTouchUpInside];
     */
    UIView *RightbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)] autorelease];
    RightbuttonView.backgroundColor=[UIColor clearColor];
    [RightbuttonView addSubview:rightbutton];
    
    UIBarButtonItem* rightbarButton = [[[UIBarButtonItem alloc] initWithCustomView:RightbuttonView] autorelease];
    
    
    [self.navigationItem setRightBarButtonItem:rightbarButton];
    [self.navigationItem setLeftBarButtonItem:leftbarbutton];
	
	
	UIView *service_atas=[[UIView alloc]initWithFrame:CGRectMake(15, 70, 299.5, 254.5)];
	service_atas.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"service_list_atas"]];
	[self.view addSubview:service_atas];
	
	UIView *service_bawah=[[UIView alloc]initWithFrame:CGRectMake(15, 254.5+10, 299.5, 148.5)];
	//service_bawah.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"service_list_bawah"]];
    service_bawah.backgroundColor = [UIColor clearColor];
	[self.view addSubview:service_bawah];
	self.UserHistory=[[UILabel alloc]initWithFrame:CGRectMake(20, 55, 250, 30)];
	self.UserHistory.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
	self.UserHistory.text=@"--";
	self.UserHistory.textAlignment=NSTextAlignmentCenter;
	self.UserHistory.textColor=[UIColor whiteColor];
	self.UserHistory.backgroundColor=[UIColor clearColor];
	
	self.productname=[[UILabel alloc]initWithFrame:CGRectMake(140, 88, 120, 30)];
	self.productname.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	self.productname.text=@"--";
	self.productname.textColor=[UIColor whiteColor];
	self.productname.backgroundColor=[UIColor clearColor];
	
	self.periode_start=[[UILabel alloc]initWithFrame:CGRectMake(140, 120, 120, 30)];
	self.periode_start.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	self.periode_start.text=@"--";
	self.periode_start.textColor=[UIColor whiteColor];
	self.periode_start.backgroundColor=[UIColor clearColor];
	
//	self.periode_end=[[[UILabel alloc]initWithFrame:CGRectMake(220, 120, 120, 30)] autorelease];
//	self.periode_end.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
//	self.periode_end.text=@"23-08-2013";
//	self.periode_end.textColor=[UIColor whiteColor];
//	self.periode_end.backgroundColor=[UIColor clearColor];
    
	
	self.productSelanjutnya=[[[UILabel alloc]initWithFrame:CGRectMake(140, 160, 120, 30)] autorelease];
	self.productSelanjutnya.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	self.productSelanjutnya.text=@"--";
	self.productSelanjutnya.textColor=[UIColor whiteColor];
	self.productSelanjutnya.backgroundColor=[UIColor clearColor];
	
	self.kredit=[[UILabel alloc]initWithFrame:CGRectMake(140, 200, 120, 30)];
	self.kredit.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12];
	self.kredit.textColor=[UIColor whiteColor];
	self.kredit.backgroundColor=[UIColor clearColor];
	
	melonHistoryList=[[UITableView alloc]initWithFrame:CGRectMake(15, 80, 265, 70)];
	melonHistoryList.hidden=YES;
	
	[service_atas addSubview:self.productname];
	[service_atas addSubview:self.UserHistory];
	[service_atas addSubview:self.periode_start];
	[service_atas addSubview:self.periode_end];
	[service_atas addSubview:self.productSelanjutnya];
	[service_atas addSubview:self.kredit];
	
	[service_bawah addSubview:melonHistoryList];
    
//    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
//    
//    if (appDelegate.isGetLayanan)
//    {
//        NSString * str;
//        str = [appDelegate.eLayanan.paymentProdName length] == 0 ? @" Tak ada produk. " : appDelegate.eLayanan.paymentProdName;
//        //[self.productname setText: appDelegate.eLayanan.paymentProdName];
//        [self.productname setText:str];
//        str = [appDelegate.eLayanan.payUserNickname length] == 0 ? appDelegate.eUserName : appDelegate.eLayanan.payUserNickname;
//		//[self.UserHistory setText: appDelegate.eLayanan.payUserNickname];
//        [self.UserHistory setText:str];
//		[self.periode_start setText: [NSString stringWithFormat:@"%@ -- %@", appDelegate.eLayanan.useStartDate, appDelegate.eLayanan.useEndDate]];
//		//[self.periode_end setText: eLayanan.useEndDate];
//		
//		NSInteger limitDownload= [appDelegate.eLayanan.limitDown integerValue];
//		NSInteger limitDownCnt= [appDelegate.eLayanan.limitDownCnt integerValue];
//		NSLog(@"liimitDownload--->%d",limitDownload);
//		if(limitDownload==-1){
//			[self.kredit setText : @"Unlimited"];
//		}
//		else{
//            NSString *inStr = [NSString stringWithFormat:@"%d", limitDownload-limitDownCnt];
//			[self.kredit setText : inStr];
//		}
//        
//    }
    
 	//[self fetchData];
}
-(void)lefbuttonPush{
	//[searchbar resignFirstResponder];
	[self.sidePanelController showLeftPanel:YES];
}

- (void)rightbuttonPush {
	//	[searchbar resignFirstResponder];
	[self.sidePanelController showRightPanel:YES];
}


- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}
-(void)fetchData{
	[self fetchList];
    
   	NSMutableArray *users_active = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
	EUserBrief *user_now=[users_active objectAtIndex:0];

    NSString * userId = @"";
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    userId = [appDelegate eUserId];;
    
    if (userId == nil)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Galat"
                                     message:@"Silahkan login terlebih dahulu (kembali) untuk melihat download history ini."
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    NSString * sURL = [NSString stringWithFormat:@"%@users/%@/onservice", [NSString stringWithUTF8String:MAPI_SERVER], userId];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              userId, @"userId",
                              @"cu", @"_DIR",
                              @"iOS Client", @"_CNAME",
                              @"DC6AE040A9200D384D4F08C0360A2607", @"_CPASS",
                              user_now.userId, @"_UNAME",
                              user_now.ePassword, @"_UPASS",
                              nil] autorelease];
    
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.132:8000/mapi/users/758965/onservice?_CNAME=Android+Client&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=siraz@timun.com&_UPASS=MTIzNDU2"];
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily?offset=%d&limit=10",current_page];
	
	NSURL *URL=[NSURL URLWithString:sURL];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		//NSLog(@"[responseObject objectForKey:@paymentProdCateName]===>%@",[[responseObject objectAtIndex:0]objectForKey:@"paymentProdCateName"]);
		[self.productname setText:[[responseObject objectAtIndex:0]objectForKey:@"paymentProdName"]];
		[self.UserHistory setText: [NSString stringWithFormat:@"MELON SERVICE HISTORY %@",[[responseObject objectAtIndex:0]objectForKey:@"payUserNickname"]]];
		[self.periode_start setText:[[responseObject objectAtIndex:0]objectForKey:@"useStartDate"]];
		[self.periode_end setText:[[responseObject objectAtIndex:0]objectForKey:@"useEndDate"]];
		
		NSInteger limitDownload=[[[responseObject objectAtIndex:0]objectForKey:@"limitDown"]integerValue];
		NSInteger limitDownCnt=[[[responseObject objectAtIndex:0]objectForKey:@"limitDownCnt"]integerValue];
		NSLog(@"liimitDownload--->%d",limitDownload);
		if(limitDownload==-1){
			[self.kredit setText : @"Unlimited"];
		}
		else{
		NSString *inStr = [NSString stringWithFormat:@"%d", limitDownload-limitDownCnt];
			[self.kredit setText : inStr];
		}
	
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			[[[[UIAlertView alloc] initWithTitle:@"Galat"
										 message:@"Terjadi masalah ketika mengambil data dari server. Pastikan koneksi jaringan Anda dan coba kembali lagi."
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
			
		}
		
	}];
    
	[operation start];
    [httpClient release];

}
-(void)fetchList{
    
    NSString * userId = @"";
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    userId = [appDelegate eUserId];;
    
    if (userId == nil)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Galat"
                                     message:@"Silahkan login terlebih dahulu (kembali) untuk melihat download history ini."
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    NSString * sURL = [NSString stringWithFormat:@"%@users/%@/onservice/history", [NSString stringWithUTF8String:MAPI_SERVER], userId];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              @"c", @"_DIR",
                              @"iOS Client", @"_CNAME",
                              @"DC6AE040A9200D384D4F08C0360A2607", @"_CPASS",
                              @"cu", @"_UNAME",
                              [appDelegate eUserName], @"_UNAME",
                              [appDelegate eWebPassword], @"_UPASS",
                              nil] autorelease];
    
    
    //http://118.98.31.132:8000/mapi/users/1224/onservice/history?_CNAME=Android+Client&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=ibnufarid@gmail.com&_UPASS=cGFzc3dvcmQ=
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.132:8000/mapi/users/1224/onservice/history?_CNAME=Android+Client&_CPASS=DC6AE040A9200D384D4F08C0360A2607&_DIR=cu&_UNAME=ibnufarid@gmail.com&_UPASS=cGFzc3dvcmQ="];
	//NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/chart/daily?offset=%d&limit=10",current_page];
	
	NSURL *URL=[NSURL URLWithString:sURL];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:sURL parameters:params];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
	
    //AFHTTPRequestOperation * operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSLog(@"response object--->%@",responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			[[[[UIAlertView alloc] initWithTitle:@"Galat"
										 message:@"Terjadi masalah ketika mengambil data dari server. Pastikan Anda telah login dan koneksi jaringan Anda ada. Silahkan coba kembali lagi."
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] autorelease] show];
			
		}
		
	}];
    
	[operation start];
    [httpClient release];
}
@end
