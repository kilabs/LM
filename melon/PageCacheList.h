//
//  PageCacheList.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/10/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PageCacheList : NSManagedObject

@property (nonatomic, retain) NSString * pageType;
@property (nonatomic, retain) NSDictionary * cacheData;

@end