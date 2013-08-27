//
//  mokletdevLeftCell.m
//  melon
//
//  Created by Arie on 3/5/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevLeftCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation mokletdevLeftCell

@synthesize contentImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
        // Initialization code
		self.contentRight=[[UILabel alloc]init];
		self.contentRight.textColor=[UIColor whiteColor];
		self.contentRight.highlightedTextColor=[UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1];
		self.contentRight.frame=CGRectMake(10, 11, 200, 20);
		self.contentRight.backgroundColor=[UIColor clearColor];
		[self.contentRight setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
		self.contentRight.layer.shadowOpacity = 1.0;
		self.contentRight.layer.shadowRadius = 1.0;
		self.contentRight.layer.shadowColor = [UIColor blackColor].CGColor;
		self.contentRight.layer.shadowOffset = CGSizeMake(0.0, 0.7);
		
		self.contentRightImage=[[UIImageView alloc]init];
		self.contentRightImage.frame=CGRectMake(25, 10, 178.5, 32.5);
	
		
		contentImg = [[UIImageView alloc] init];
        contentImg.frame = CGRectMake(0.0, 0.0, 320, 54);
        [self.contentView addSubview:contentImg];
		
		//self.separators=[[UIView alloc]initWithFrame:CGRectMake(0, 8.5, 13.5, 54)];
		//self.separators.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-hornet"]];
		//self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-hornet"]];
		
		


    }
	[self.contentView addSubview:self.contentRight];
	//[self.contentView addSubview:self.contentRightImage];
	//[self.contentView addSubview:self.separators];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   
	
    // Configure the view for the selected state
}

@end
