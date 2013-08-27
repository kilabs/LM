//
//  downloadQueTableCell.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/14/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "downloadQueTableCell.h"
#import "YLProgressBar.h"

@implementation downloadQueTableCell

@synthesize songTitle;
@synthesize songArtist;
@synthesize downloadedData;
@synthesize downloadProgress;
@synthesize downloadOKCancelButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        songTitle = [[[UILabel alloc] init] autorelease];
        [songTitle setFrame:CGRectMake(10.0, 10.0, 250.0, 20.0)];
        songTitle.backgroundColor = [UIColor clearColor];
        songTitle.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:1.0];
        songTitle.highlightedTextColor = [UIColor colorWithHue:0.2083 saturation:1.0 brightness:0.80 alpha:1.0];
        songTitle.textAlignment = NSTextAlignmentLeft;
        songTitle.numberOfLines = 1;
        [songTitle setFont: [UIFont fontWithName:@"OpenSans-Bold" size:16]];
        songTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:songTitle];
        
        
        songArtist = [[[UILabel alloc] init] autorelease];
        [songArtist setFrame:CGRectMake(10.0, 30.0, 250.0, 16.0)];
        songArtist.backgroundColor = [UIColor clearColor];
        songArtist.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.50 alpha:1.0];
        songArtist.highlightedTextColor = [UIColor colorWithHue:0.2083 saturation:1.0 brightness:0.80 alpha:1.0];
        songArtist.textAlignment = NSTextAlignmentLeft;
        songArtist.numberOfLines = 1;
        [songArtist setFont: [UIFont fontWithName:@"OpenSans" size:12]];
        songArtist.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:songArtist];
        
        downloadedData = [[[UILabel alloc] init] autorelease];
        [downloadedData setFrame:CGRectMake(10.0, 42.0, 250.0, 16.0)];
        downloadedData.backgroundColor = [UIColor clearColor];
        downloadedData.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:1.0];
        downloadedData.highlightedTextColor = [UIColor colorWithHue:0.2083 saturation:1.0 brightness:0.80 alpha:1.0];
        downloadedData.textAlignment = NSTextAlignmentRight;
        downloadedData.numberOfLines = 1;
        [downloadedData setFont: [UIFont fontWithName:@"OpenSans" size:9]];
        downloadedData.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:downloadedData];
        
        downloadProgress = [[[YLProgressBar alloc] initWithFrame:CGRectMake(10.0, 60.0, 250.0, 6.0)] autorelease];
        downloadProgress.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:downloadProgress];

        downloadOKCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(264.0, 15.0, 50.0, 50.0)];
        downloadOKCancelButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:downloadOKCancelButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
