//
//  ImaginerList.h
//  melon
//
//  Created by Arie on 5/12/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImaginerList : NSManagedObject

@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSString * realSongid;
@property (nonatomic, retain) NSString * status;

@end
