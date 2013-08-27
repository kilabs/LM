//
//  mokletdevQuequeController.m
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevQuequeController.h"

@interface mokletdevQuequeController ()

@end

@implementation mokletdevQuequeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar addSubview:top_label];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    top_label=[[[UIView alloc]initWithFrame:CGRectMake(45, 0, 230, 44)] autorelease];
    top_label.backgroundColor=[UIColor clearColor];
    
    TitleBig=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 44)] autorelease];
    TitleBig.text=@"DOWNLOAD QUEUE";
    TitleBig.textAlignment=NSTextAlignmentCenter;
    TitleBig.backgroundColor=[UIColor clearColor];
    [TitleBig setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    TitleBig.textColor = [UIColor whiteColor];
    TitleBig.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
    TitleBig.shadowOffset = CGSizeMake(0, 1.0);
    TitleBig.hidden=NO;
    
    
    [top_label addSubview:TitleBig];
    
    
    //downloadQueue=[[[UITableView alloc]init] autorelease];
    //downloadHistory.delegate=self;
    //downloadHistory.dataSource=self;
    //downloadQueue.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    //[downloadHistory setSeparatorColor:[UIColor clearColor]];
    //downloadHistory.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"top100"]];
    //[self.view addSubview:downloadQueue];
    
    // Custom initialization
    self.view.backgroundColor=[UIColor whiteColor];
    UIImage* image = [UIImage imageNamed:@"left"];
    CGRect frame = CGRectMake(-5, 0, 44, 44);
    UIButton* leftbutton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [leftbutton setBackgroundImage:image forState:UIControlStateNormal];
    //[leftbutton setBackgroundImage:[UIImage imageNamed:@"left-push"] forState:UIControlStateHighlighted];
    //[leftbutton addTarget:self action:@selector(lefbuttonPush) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)] autorelease];
    leftbuttonView.backgroundColor=[UIColor clearColor];
    [leftbuttonView addSubview:leftbutton];
    UIBarButtonItem* leftbarbutton = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonView];
    
    UIImage* image2 = [UIImage imageNamed:@"right"];
    CGRect frame2 = CGRectMake(50, 0, 44, 44);
    UIButton* rightbutton = [[[UIButton alloc] initWithFrame:frame2] autorelease];
    [rightbutton setBackgroundImage:image2 forState:UIControlStateNormal];

    UIView *RightbuttonView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)] autorelease];
    RightbuttonView.backgroundColor=[UIColor clearColor];
    [RightbuttonView addSubview:rightbutton];
    
    UIBarButtonItem* rightbarButton = [[[UIBarButtonItem alloc] initWithCustomView:RightbuttonView] autorelease];
    
    
    [self.navigationItem setRightBarButtonItem:rightbarButton];
    [self.navigationItem setLeftBarButtonItem:leftbarbutton];
    
    UIView * topView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 100.0)] autorelease];
    topView.backgroundColor= [UIColor grayColor];
    [self.view addSubview:topView];
    
    UILabel * slTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, self.view.bounds.size.width -20.0, 20.0)] autorelease];
    slTitle.text = @"DOWNLOAD STATUS";
    [topView addSubview:slTitle];
    
    UIView * clearView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, topView.bounds.size.height, self.view.bounds.size.width, 40.0)] autorelease];
    clearView.backgroundColor= [UIColor blackColor];
    [self.view insertSubview:clearView belowSubview:topView];
    
    downloadQueueTable = [[[UITableView alloc] initWithFrame:CGRectMake(0.0, topView.bounds.size.height + clearView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - topView.bounds.size.height)] autorelease];
    downloadQueueTable.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:downloadQueueTable belowSubview:clearView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
