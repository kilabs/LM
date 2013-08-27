//
//  Encryption.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 3/19/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject

+ (NSData *)randomDataOfLength:(size_t)length;
+ (NSString *) encryptParam: (NSString *) param;

@end
