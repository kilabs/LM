//
//  PlayerConfig.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 6/3/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerConfig : NSManagedObject

@property (nonatomic, retain) NSNumber * autoLogin;
@property (nonatomic, retain) NSNumber * firstUse;
@property (nonatomic, retain) NSNumber * lastUser;
@property (nonatomic, retain) NSNumber * lastVolume;
@property (nonatomic, retain) NSNumber * playOption;

@end
