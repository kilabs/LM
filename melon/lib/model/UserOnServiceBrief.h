//
//  UserOnServiceBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserOnServiceBrief : NSManagedObject

@property (nonatomic, retain) NSString * autoRetentionYN;
@property (nonatomic, retain) NSString * chargeDate;
@property (nonatomic, retain) NSString * limitDown;
@property (nonatomic, retain) NSString * limitDownCount;
@property (nonatomic, retain) NSString * limitStream;
@property (nonatomic, retain) NSString * limitStreamCount;
@property (nonatomic, retain) NSString * mobileOnlyYN;
@property (nonatomic, retain) NSString * ownershipType;
@property (nonatomic, retain) NSString * paymentProdCateId;
@property (nonatomic, retain) NSString * paymentProdCateName;
@property (nonatomic, retain) NSString * paymentProdId;
@property (nonatomic, retain) NSString * paymentProdName;
@property (nonatomic, retain) NSString * paymentProdImg;
@property (nonatomic, retain) NSString * paymentWayId;
@property (nonatomic, retain) NSString * paymentWayName;
@property (nonatomic, retain) NSString * payUserId;
@property (nonatomic, retain) NSString * payUserNickname;
@property (nonatomic, retain) NSString * postPaymentProdId;
@property (nonatomic, retain) NSString * postPaymentProdName;
@property (nonatomic, retain) NSString * supportDrmYN;
@property (nonatomic, retain) NSString * useEndDate;
@property (nonatomic, retain) NSString * userPaymentProdId;
@property (nonatomic, retain) NSString * useStartDate;
@property (nonatomic, retain) NSString * supportNonDrmYN;
@property (nonatomic, retain) NSString * supportStreamYN;

@end
