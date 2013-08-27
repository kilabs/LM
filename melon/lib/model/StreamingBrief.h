//
//  StreamingBrief.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/9/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamingBrief : NSObject
{
    @private
    NSString * bitRateCd;
    NSString * codecTypeCd;
    NSString * contentId;
    NSString * errorCode;
    NSString * fullTrack;
    NSString * playtime;
    NSString * sampling;
    NSString * sessionId;
}

@property (nonatomic, retain) NSString * bitRateCd;
@property (nonatomic, retain) NSString * codecTypeCd;
@property (nonatomic, retain) NSString * contentId;
@property (nonatomic, retain) NSString * errorCode;
@property (nonatomic, retain) NSString * fullTrack;
@property (nonatomic, retain) NSString * playtime;
@property (nonatomic, retain) NSString * sampling;
@property (nonatomic, retain) NSString * sessionId;

+ (StreamingBrief *) getInstance;

@end
