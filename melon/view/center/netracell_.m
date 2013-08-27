//
//  NetraCell.m
//  NetraFrameWork
//
//  Created by Arie on 12/17/12.
//  Copyright (c) 2012 Netra. All rights reserved.
//

#import "netracell_.h"
#import <QuartzCore/QuartzCore.h>

@implementation netracell_
@synthesize title;
@synthesize play;
@synthesize excerpt;
@synthesize thumbnail;
@synthesize albumName;
@synthesize length;
@synthesize download;
@synthesize share;
@synthesize playmex;
@synthesize shareplace;
@synthesize genre;
@synthesize facebook;
@synthesize twitter;
@synthesize mail;
@synthesize container;
@synthesize addto_play_list;
//@synthesize removeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.contentView.backgroundColor=[UIColor colorWithRed:0.2 green:0.196 blue:0.239 alpha:1];
		
		container=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 153/2)];
		container.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
		///ad separators
		sparators=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
		sparators.backgroundColor=[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
		
		
                        
		title=[[UILabel alloc]init];
		title.backgroundColor=[UIColor clearColor];
		title.textColor=[UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
		title.highlightedTextColor=[UIColor colorWithRed:0.318 green:0.318 blue:0.318 alpha:1];
		title.textAlignment=NSTextAlignmentLeft;
		title.numberOfLines=1;
		//title.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
		[title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
		title.frame=CGRectMake(85, 8, 190, 30);
		title.backgroundColor=[UIColor clearColor];
		title.lineBreakMode=NSLineBreakByWordWrapping;
		
		excerpt=[[UILabel alloc]init];
		excerpt.backgroundColor=[UIColor clearColor];
		
		excerpt.numberOfLines=1;
		excerpt.highlightedTextColor=[UIColor whiteColor];
		excerpt.lineBreakMode=NSLineBreakByWordWrapping;
		excerpt.textAlignment=NSTextAlignmentLeft;
		excerpt.textColor=[UIColor colorWithRed:0.416 green:0.416 blue:0.416 alpha:1] ;
		//title.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
		[excerpt setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
		excerpt.frame=CGRectMake(85, 27, 130, 30);
		excerpt.backgroundColor=[UIColor clearColor];
		
		albumName=[[UILabel alloc]init];
		albumName.backgroundColor=[UIColor clearColor];
		albumName.numberOfLines=1;
		albumName.highlightedTextColor=[UIColor whiteColor];
		albumName.lineBreakMode=NSLineBreakByWordWrapping;
		albumName.textAlignment=NSTextAlignmentLeft;
		//title.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
		[albumName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
		albumName.frame=CGRectMake(85, 45, 130, 30);
		albumName.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] ;
		albumName.backgroundColor=[UIColor clearColor];
		
		
		thumbnail=[[UIImageView alloc]init];
		thumbnail.layer.borderColor=[[UIColor colorWithRed:0.835 green:0.835 blue:0.835 alpha:1]CGColor];
		thumbnail.frame=CGRectMake(0, 0, 76, 76);
		
		
		//thumbnail.layer.borderWidth = 1.0;
		play=[UIButton buttonWithType:UIButtonTypeCustom];
		//play.frame=CGRectMake(25, 25, 26, 26);
        play.frame = CGRectMake(0, 0, 76.5, 76.5);
		[play setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
		//[play setBackgroundImage:[UIImage imageNamed:@"play-state"] forState:UIControlEventTouchUpInside];
		//[play setBackgroundImage:[UIImage imageNamed:@"play-state"] forState:UIControlStateHighlighted];
        [play setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
		
		download=[UIButton buttonWithType:UIButtonTypeCustom];
		download.frame=CGRectMake(275, 20, 47, 35.5);
		//download.backgroundColor=[UIColor redColor];
		[download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
		[download setBackgroundImage:[UIImage imageNamed:@"download-pushed"] forState:UIControlStateHighlighted];
        
        //removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //removeButton.frame = CGRectMake(275, 20, 47, 35.5);
        //[removeButton setBackgroundImage:[UIImage imageNamed:@"dlcancel"] forState:UIControlStateNormal];
		//[removeButton setBackgroundImage:[UIImage imageNamed:@"dlcancelhl"] forState:UIControlStateHighlighted];
		//removeButton.hidden = YES;
        
		facebook=[UIButton buttonWithType:UIButtonTypeCustom];
		facebook.frame=CGRectMake(270, 44, 34, 34);
		//facebook.backgroundColor=[UIColor blackColor];
		[facebook setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
		[facebook setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateHighlighted];
		
		mail=[UIButton buttonWithType:UIButtonTypeCustom];
		mail.frame=CGRectMake(160, 82, 47, 35.5);
		//facebook.backgroundColor=[UIColor blackColor];
		[mail setBackgroundImage:[UIImage imageNamed:@"sendMail"] forState:UIControlStateNormal];
		[mail setBackgroundImage:[UIImage imageNamed:@"sendMail-pushed"] forState:UIControlStateHighlighted];
		
		twitter=[UIButton buttonWithType:UIButtonTypeCustom];
		twitter.frame=CGRectMake(235, 44, 34, 34);
		//twitter.backgroundColor=[UIColor blackColor];
		[twitter setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
		[twitter setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateHighlighted];
		
		playmex=[UIButton buttonWithType:UIButtonTypeCustom];
		playmex.frame=CGRectMake(235, 44, 34, 34);
		//twitter.backgroundColor=[UIColor blackColor];
		[playmex setBackgroundImage:[UIImage imageNamed:@"play_"] forState:UIControlStateNormal];
		[playmex setBackgroundImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
		[playmex setBackgroundImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateSelected];
		
		addto_play_list=[UIButton buttonWithType:UIButtonTypeCustom];
		addto_play_list.frame=CGRectMake(235, 44, 34, 34);
		//twitter.backgroundColor=[UIColor blackColor];
		[addto_play_list setBackgroundImage:[UIImage imageNamed:@"playlist"] forState:UIControlStateNormal];
		[addto_play_list setBackgroundImage:[UIImage imageNamed:@"playlist"] forState:UIControlStateHighlighted];
				
		//self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell"]];
		
		
		
    }
	
	//[self.contentView addSubview:music_detail];
	//[self.contentView addSubview:share_button_view];
	
	[container addSubview:title];
	[container addSubview:excerpt];
	
	[container addSubview:albumName];
	[container addSubview:download];
	[container addSubview:sparators];
	[container addSubview:thumbnail];
	[container addSubview:play];
	[self.contentView addSubview:facebook];
	[self.contentView addSubview:twitter];
	[self.contentView addSubview:playmex];
	[self.contentView addSubview:addto_play_list];
	[self.contentView addSubview:container];
	
	
	
	
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	// [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
}

@end
