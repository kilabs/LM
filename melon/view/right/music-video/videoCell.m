//
//  videoCell.m
//  melon
//
//  Created by Arie on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "videoCell.h"

@implementation videoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.contentView.backgroundColor=[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
