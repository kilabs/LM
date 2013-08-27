//
//  NetraCell.h
//  NetraFrameWork
//
//  Created by Arie on 12/17/12.
//  Copyright (c) 2012 Netra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface netracell_ : UITableViewCell
{
	
	
	UIImageView *thumbnail;
	UIView *sparators;
}

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *excerpt;
@property(nonatomic,strong)UILabel *albumName;
@property(nonatomic,strong)UILabel *length;
@property(nonatomic,strong)UILabel *genre;
@property(nonatomic,strong)UIImageView *thumbnail;
@property(nonatomic,strong)UIButton *play;
@property(nonatomic,strong)UIButton *facebook;
@property(nonatomic,strong)UIButton *twitter;
@property(nonatomic,strong)UIButton *download;

@property(nonatomic,strong)UIButton *mail;
@property(nonatomic,strong)UIButton *share;
@property(nonatomic,strong)UIView *shareplace;
@property(nonatomic,strong)UIView *container;
@property(nonatomic,strong)UIButton *playmex;
@property(nonatomic,strong)UIButton *addto_play_list;
//@property(nonatomic, strong) UIButton * removeButton;

@end
