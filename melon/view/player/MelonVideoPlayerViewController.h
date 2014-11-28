//
//  MelonVideoPlayerViewController.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 5/2/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GAITrackedViewController.h"

@interface MelonVideoPlayerViewController : GAITrackedViewController
{
    UIButton                * backButton;
    MPMoviePlayerController * eVideoPlayer;
    NSString                * sUrl;
}

@property (nonatomic, strong) UILabel   * lblTitle;
@property (nonatomic, strong) UILabel   * lblArtist;
@property (nonatomic, strong) UILabel   * lblAlbum;

@property (nonatomic, strong) NSString  * videoTitle;
@property (nonatomic, strong) NSString  * videoArtist;
@property (nonatomic, strong) NSString  * videoAlbum;

- (void) setVideoUrl: (NSString *) sURL;


@end
