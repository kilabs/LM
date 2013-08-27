//
//  mokletdevCellRight.m
//  melon
//
//  Created by Arie on 3/5/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "mokletdevCellRight.h"

@implementation mokletdevCellRight

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
	
        // Initialization code
		self.contentView.backgroundColor=[UIColor colorWithRed:0.282 green:0.282 blue:0.286 alpha:1];
		self.contentRight=[[UILabel alloc]init];
		self.contentRight.textColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
		self.contentRight.highlightedTextColor=[UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1];
		self.contentRight.frame=CGRectMake(80, 10, 200, 20);
		self.contentRight.backgroundColor=[UIColor clearColor];
		[self.contentRight setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
		self.contentRight.layer.shadowOpacity = 1.0;
		self.contentRight.layer.shadowRadius = 1.0;
		self.contentRight.layer.shadowColor = [UIColor blackColor].CGColor;
		self.contentRight.layer.shadowOffset = CGSizeMake(0.0, 1.0);

		
		self.separators=[[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, 1)];
		self.separators.backgroundColor=[UIColor colorWithRed:0.373 green:0.376 blue:0.376 alpha:1];
		//self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-hornet-right"]];
	
	
    }
	[self.contentView addSubview:self.contentRight];
	[self.contentView addSubview:self.separators];
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  

    // Configure the view for the selected state
}

@end
