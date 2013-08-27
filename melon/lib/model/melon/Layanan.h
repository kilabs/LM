//
//  Layanan.h
//  melon
//
//  Created by MelOn Indonesia, PT on 7/11/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Layanan : NSManagedObject

@property (nonatomic, retain) NSString * allowedReservationYN;
@property (nonatomic, retain) NSString * allowedWithdrawalCancelYN;
@property (nonatomic, retain) NSString * allowedWithdrawalReservationYN;
@property (nonatomic, retain) NSString * autoRetentionYN;
@property (nonatomic, retain) NSString * chargeDate;
@property (nonatomic, retain) NSString * gracePeriodDown;
@property (nonatomic, retain) NSString * gracePeriodPlay;
@property (nonatomic, retain) NSString * gracePeriodStream;
@property (nonatomic, retain) NSString * limitDown;
@property (nonatomic, retain) NSString * limitDownCnt;
@property (nonatomic, retain) NSString * limitStream;
@property (nonatomic, retain) NSString * limitStreamCnt;
@property (nonatomic, retain) NSString * mobileOnlyYN;
@property (nonatomic, retain) NSString * ownershipType;
@property (nonatomic, retain) NSString * paymentProdCateId;
@property (nonatomic, retain) NSString * paymentProdCateName;
@property (nonatomic, retain) NSString * paymentProdId;
@property (nonatomic, retain) NSString * paymentProdImg;
@property (nonatomic, retain) NSString * paymentProdName;
@property (nonatomic, retain) NSString * paymentWayId;
@property (nonatomic, retain) NSString * paymentWayName;
@property (nonatomic, retain) NSString * payUserId;
@property (nonatomic, retain) NSString * payUserNickname;
@property (nonatomic, retain) NSString * postPaymentProdId;
@property (nonatomic, retain) NSString * postPaymentProdName;
@property (nonatomic, retain) NSString * ppStatusCd;
@property (nonatomic, retain) NSString * supportDrmYN;
@property (nonatomic, retain) NSString * supportNonDrmYN;
@property (nonatomic, retain) NSString * supportStreamYN;
@property (nonatomic, retain) NSString * useEndDate;
@property (nonatomic, retain) NSString * userPaymentProdId;
@property (nonatomic, retain) NSString * useStartDate;
@property (nonatomic, retain) NSString * postReserveDate;
@property (nonatomic, retain) NSString * reservedPaymentProdId;
@property (nonatomic, retain) NSString * reservedPaymentProdName;

@end
