//
//  LyricList.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 11/26/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LyricList : NSManagedObject

@property (nonatomic, retain) NSString * songId;
@property (nonatomic, retain) NSDictionary * songLyric;

@end