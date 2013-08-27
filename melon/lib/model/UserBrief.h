//
//  UserBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserBrief : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * eventSmsYN;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * hansetId;
@property (nonatomic, retain) NSString * msisdn;
@property (nonatomic, retain) NSString * newsMailingYN;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * provinceId;
@property (nonatomic, retain) NSString * quizAnswer;
@property (nonatomic, retain) NSString * quizId;
@property (nonatomic, retain) NSString * receiveRoYN;
@property (nonatomic, retain) NSString * regDate;
@property (nonatomic, retain) NSString * updDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * telcoId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userType;
@property (nonatomic, retain) NSString * speedyId;

@end
