//
//  SearchCellSong.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCellSong : UITableViewCell

@property (nonatomic,strong) UILabel *SongTitle;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *Singer;
@property(nonatomic,strong)  UIButton *download;
@end
