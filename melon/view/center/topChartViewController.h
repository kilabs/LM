//
//  topChartViewController.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/1/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface topChartViewController : UIViewController
{
    UITableView             * topChartList;
    UIButton                * searchButton;
    
    NSInteger current_page;
	NSInteger selectedIndex;
	NSInteger total_page;
}

@property(nonatomic,retain) NSMutableArray *topChartMutableArray;
@property(nonatomic,retain) NSMutableArray *topChartMutableArrayResult;
//@property(nonatomic,strong) UIImageView * titleImage;

@end
