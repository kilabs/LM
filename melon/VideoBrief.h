//
//  VideoBrief.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/23/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoBrief : NSObject
{
@private
    NSString * albumName;
    NSString * artistId;
    NSString * artistName;
    NSString * opposeCnt;
    NSString * recommendCnt;
    NSString * songId;
    NSString * songName;
    NSString * songVodId;
    NSString * vodAdultYN;
    NSString * vodIssueDate;
    NSString * vodLImgPath;
    NSString * vodMImgPath;
    NSString * vodSImgPath;
    NSString * vodOrderIssueDate;
    NSString * vodTitle;
}

@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * opposeCnt;
@property (nonatomic, retain) NSString * recommendCnt;
@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songVodId;
@property (nonatomic, retain) NSString * vodAdultYN;
@property (nonatomic, retain) NSString * vodIssueDate;
@property (nonatomic, retain) NSString * vodLImgPath;
@property (nonatomic, retain) NSString * vodMImgPath;
@property (nonatomic, retain) NSString * vodSImgPath;
@property (nonatomic, retain) NSString * vodOrderIssueDate;
@property (nonatomic, retain) NSString * vodTitle;


+ (VideoBrief *) getInstance;
-(id) initWithDictionary:(NSDictionary *) dictionary;

@end
