//
//  SearchCellSong.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "SearchCellSong.h"

@implementation SearchCellSong
@synthesize SongTitle;
@synthesize Singer;
@synthesize image;
@synthesize download;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
		SongTitle=[[UILabel alloc]initWithFrame:CGRectMake(75, 10, 200, 30)];
		SongTitle.backgroundColor=[UIColor clearColor];
		SongTitle.highlightedTextColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1];
		SongTitle.textColor=[UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1];
		[SongTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
		
		Singer=[[UILabel alloc]initWithFrame:CGRectMake(75, 30, 230, 30)];
		Singer.backgroundColor=[UIColor clearColor];
		Singer.highlightedTextColor=[UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1];
		Singer.textColor=[UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1];
		[Singer setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];
		
		image=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 65, 65)];
		image.backgroundColor=[UIColor clearColor];
        
        download=[UIButton buttonWithType:UIButtonTypeCustom];
		download.frame=CGRectMake(275, 20, 47, 35.5);
		[download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
		[download setBackgroundImage:[UIImage imageNamed:@"download-pushed"] forState:UIControlStateHighlighted];
        
        
		
    }
	[self.contentView addSubview:SongTitle];
	[self.contentView addSubview:Singer];
	[self.contentView addSubview:image];
    [self.contentView addSubview:download];
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

