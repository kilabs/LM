//
//  UserBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>


@interface UserBrief : NSObject
{
    NSString * autoRetentionYN;
    NSString * birthday;
    NSString * email;
    NSString * eventSmsYN;
    NSString * gender;
    NSString * hansetId;
    NSString * lastIp;
    NSString * msisdn;
    NSString * newsMailingYN;
    NSString * nickname;
    NSString * productYN;
    NSString * provinceId;
    NSString * param1;
    NSString * param2;
    NSString * param3;
    NSString * quizAnswer;
    NSString * quizId;
    NSString * receiveRoYN;
    NSString * regDate;
    NSString * updDate;
    NSString * status;
    NSString * telcoId;
    NSString * userId;
    NSString * userType;
    NSString * speedyId;
    NSString * webPassword;
}

@property (nonatomic, retain) NSString * autoRetentionYN;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * eventSmsYN;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * hansetId;
@property (nonatomic, retain) NSString * lastIp;
@property (nonatomic, retain) NSString * msisdn;
@property (nonatomic, retain) NSString * newsMailingYN;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * productYN;
@property (nonatomic, retain) NSString * provinceId;
@property (nonatomic, retain) NSString * param1;
@property (nonatomic, retain) NSString * param2;
@property (nonatomic, retain) NSString * param3;
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
@property (nonatomic, retain) NSString * webPassword;


-(id)initWithDictionary:(NSDictionary *)dictionary;
+ (UserBrief *) getInstance;

@end
