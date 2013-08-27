//
//  mokletdevServiceController.h
//  melon
//
//  Created by Arie on 3/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mokletdevServiceController : UIViewController
{
	UIView *top_label;
	UILabel *TitleBig;
	UITableView *melonHistoryList;
}
@property(nonatomic,strong) UILabel *UserHistory;
@property(nonatomic,strong) UILabel *productname;
@property(nonatomic,strong) UILabel *periode_start;
@property(nonatomic,strong) UILabel *periode_end;
@property(nonatomic,strong) UILabel *productSelanjutnya;
@property(nonatomic,strong) UILabel *kredit;
@end
