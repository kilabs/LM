//
//  UserBrief.m
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import "UserBrief.h"


@implementation UserBrief

@synthesize autoRetentionYN;
@synthesize birthday;
@synthesize email;
@synthesize eventSmsYN;
@synthesize gender;
@synthesize hansetId;
@synthesize lastIp;
@synthesize msisdn;
@synthesize newsMailingYN;
@synthesize nickname;
@synthesize productYN;
@synthesize provinceId;
@synthesize param1;
@synthesize param2;
@synthesize param3;
@synthesize quizAnswer;
@synthesize quizId;
@synthesize receiveRoYN;
@synthesize regDate;
@synthesize updDate;
@synthesize status;
@synthesize telcoId;
@synthesize userId;
@synthesize userType;
@synthesize speedyId;
@synthesize webPassword;

static UserBrief * instance;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
	self=[super init];
    
	if(self){
        self.autoRetentionYN = [dictionary objectForKey:@"autoRetentionYN"];
		self.birthday    = [dictionary objectForKey:@"songId"];
		self.email       = [dictionary objectForKey:@"songName"];
		self.eventSmsYN  = [dictionary objectForKey:@"artistName"];
		self.gender      = [dictionary objectForKey:@"albumName"];
		self.hansetId    = [dictionary objectForKey:@"hansetId"];
        self.lastIp      = [dictionary objectForKey:@"lastIp"];
        self.msisdn      = [dictionary objectForKey:@"msisdn"];
        self.newsMailingYN  = [dictionary objectForKey:@"newsMailingYN"];
		self.nickname    = [dictionary objectForKey:@"nickname"];
        self.productYN   = [dictionary objectForKey:@"productYN"];
        self.provinceId  = [dictionary objectForKey:@"provinceId"];
        self.param1      = [dictionary objectForKey:@"param1"];
        self.param2      = [dictionary objectForKey:@"param2"];
        self.param3      = [dictionary objectForKey:@"param3"];
        self.quizAnswer  = [dictionary objectForKey:@"quizAnswer"];
        self.quizId      = [dictionary objectForKey:@"quizId"];
        self.receiveRoYN = [dictionary objectForKey:@"receiveRoYN"];
        self.regDate     = [dictionary objectForKey:@"regDate"];
        self.updDate     = [dictionary objectForKey:@"updDate"];
        self.status      = [dictionary objectForKey:@"status"];
        self.telcoId     = [dictionary objectForKey:@"telcoId"];
        self.userId      = [dictionary objectForKey:@"userId"];
        self.userType    = [dictionary objectForKey:@"userType"];
        self.speedyId    = [dictionary objectForKey:@"speedyId"];
        self.webPassword = [dictionary objectForKey:@"webPassword"];
	}
    instance = self;
	return self;
}

+ (UserBrief *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[UserBrief alloc] init];
        }
    }
    
    return  instance;
}

@end
