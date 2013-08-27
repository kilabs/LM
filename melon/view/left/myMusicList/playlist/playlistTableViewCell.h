//
//  playlistTableViewCell.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/14/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playlistTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * playlistTitle;
@property (nonatomic, strong) UILabel * total_Song;
@property (nonatomic, strong) UIView * container;
@property(nonatomic,strong)UIButton *edit;
@property(nonatomic,strong)UIButton *delete_;



@end
