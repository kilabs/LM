//
//  MusicVideoBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicVideoBrief : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * opposeCount;
@property (nonatomic, retain) NSString * previousRanking;
@property (nonatomic, retain) NSString * ranking;
@property (nonatomic, retain) NSString * recommendCount;
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

@end
