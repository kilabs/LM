//
//  EUserBrief.h
//  melon
//
//  Created by Arie on 5/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EUserBrief : NSManagedObject

@property (nonatomic, retain) NSString * autoRetentionYN;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * ePassword;
@property (nonatomic, retain) NSString * eventSmsYN;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * handsetId;
@property (nonatomic, retain) NSString * lastIp;
@property (nonatomic, retain) NSString * msisdn;
@property (nonatomic, retain) NSString * newsMailingYN;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * param1;
@property (nonatomic, retain) NSString * param2;
@property (nonatomic, retain) NSString * param3;
@property (nonatomic, retain) NSString * productYN;
@property (nonatomic, retain) NSString * provinceId;
@property (nonatomic, retain) NSString * quizAnswer;
@property (nonatomic, retain) NSString * quizId;
@property (nonatomic, retain) NSString * receiveRoYN;
@property (nonatomic, retain) NSString * regDate;
@property (nonatomic, retain) NSString * speedyId;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * telcoId;
@property (nonatomic, retain) NSString * updDate;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userType;
@property (nonatomic, retain) NSString * webPassword;
@property (nonatomic, retain) NSString * username;

@end
