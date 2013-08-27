//
//  mokletdevGuideViewController.m
//  melon
//
//  Created by Arie on 3/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevGuideViewController.h"

@interface mokletdevGuideViewController ()

@end

@implementation mokletdevGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		scrollGuide=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-40)];
		scrollGuide.backgroundColor=[UIColor whiteColor];
		
		
    }
	[self.view addSubview:scrollGuide];
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

@end
