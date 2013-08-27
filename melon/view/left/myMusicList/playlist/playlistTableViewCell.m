//
//  playlistTableViewCell.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/14/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "playlistTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation playlistTableViewCell

@synthesize playlistTitle;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.playlistTitle=[[UILabel alloc]init];
		self.playlistTitle.textColor=[UIColor darkGrayColor];
		//self.playlistTitle.highlightedTextColor=[UIColor lightGrayColor];
		self.playlistTitle.frame=CGRectMake(10.0, 10.0, 300, 20);
		self.playlistTitle.backgroundColor=[UIColor clearColor];
		[self.playlistTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
		// Initialization code
        self.total_Song=[[UILabel alloc]init];
		self.total_Song.textColor=[UIColor darkGrayColor];
		//self.playlistTitle.highlightedTextColor=[UIColor lightGrayColor];
		self.total_Song.frame=CGRectMake(10.0, 30.0, 300, 20);
		self.total_Song.backgroundColor=[UIColor clearColor];
		self.total_Song.text=@"32";
		[self.total_Song setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
		self.container=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 54)];
		
		self.delete_=[UIButton buttonWithType:UIButtonTypeCustom];
		self.delete_.frame=CGRectMake(120.5, 64, 34, 34);
		//twitter.backgroundColor=[UIColor blackColor];
		[self.delete_ setBackgroundImage:[UIImage imageNamed:@"delete_playlist"] forState:UIControlStateNormal];
		[self.delete_ setBackgroundImage:[UIImage imageNamed:@"delete_playlist"] forState:UIControlStateHighlighted];
		
		self.edit=[UIButton buttonWithType:UIButtonTypeCustom];
		self.edit.frame=CGRectMake(180.5, 64, 34, 34);
		//twitter.backgroundColor=[UIColor blackColor];
		[self.edit setBackgroundImage:[UIImage imageNamed:@"edit_playlist"] forState:UIControlStateNormal];
		[self.edit setBackgroundImage:[UIImage imageNamed:@"edit_playlist"] forState:UIControlStateHighlighted];
		
		[self.contentView addSubview:self.delete_];
		[self.contentView addSubview:self.edit];
		[self.contentView addSubview:self.container];
		[self.container addSubview:playlistTitle];
		[self.container addSubview:self.total_Song];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
