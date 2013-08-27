//
//  MAPIClient.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MAPIClient : NSManagedObject

@property (nonatomic, retain) NSString * channelCD;
@property (nonatomic, retain) NSString * clientName;
@property (nonatomic, retain) NSString * clientPassword;
@property (nonatomic, retain) NSString * clientType;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * status;



@end
