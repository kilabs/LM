//
//  downloadQueTableCell.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/14/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLProgressBar;

@interface downloadQueTableCell : UITableViewCell

@property (nonatomic, strong) UILabel * songTitle;
@property (nonatomic, strong) UILabel * songArtist;
@property (nonatomic, strong) UILabel * downloadedData;
//@property (nonatomic, strong) UIProgressView    * downloadProgress;
@property (nonatomic, retain) YLProgressBar * downloadProgress;
@property (nonatomic, strong) UIButton      * downloadOKCancelButton;

@end
