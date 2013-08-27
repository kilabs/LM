//
//  Encryption.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 3/19/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "Encryption.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Encryption

#define IV_SIZE     16
#define CEK_SIZE    16
#define AES_BLOCK_BIT_SIZE  128
const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;

+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

+ (NSString *) encryptParam: (NSString *) param
{
    NSData * urldParam = [param dataUsingEncoding:NSUTF8StringEncoding];
    //NSMutableData * strdParam = [[NSMutableData alloc] init];
    
    Byte        pbIV[IV_SIZE] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};
    NSData * iV = [[NSData alloc] initWithBytes:pbIV length:sizeof(pbIV)/sizeof(pbIV[0] )];
    NSString * strKey = @"indiMelonStmSvc!";
    NSData * key = [strKey dataUsingEncoding:NSUTF8StringEncoding];
    iV = [self randomDataOfLength:kCCBlockSizeAES128];
    size_t outLength;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:param.length +
                  kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, 
                     kCCAlgorithmAES128, 
                     kCCOptionPKCS7Padding, 
                     key.bytes, 
                     key.length, 
                     iV.bytes,
                     urldParam.bytes, 
                     urldParam.length, 
                     cipherData.mutableBytes,
                     cipherData.length,
                     &outLength);
    
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    
    const unsigned char* dataiV = (const unsigned char*) [iV bytes];
    //assert(dataiV == nil);
    NSInteger       dataLength = [iV length];
    NSMutableString * IV = [NSMutableString stringWithCapacity:(dataLength *2)];
    for (int j = 0; j < dataLength; ++j)
    {
        [IV appendString:[NSString stringWithFormat:@"%02x", (unsigned char) dataiV[j]]];
    }
    
    const unsigned char* dataCipher = (const unsigned char*) [cipherData bytes];
    //assert(dataCipher == nil);
    dataLength = [cipherData length];
    NSMutableString *stringCipher = [NSMutableString stringWithCapacity:(dataLength *2)];
    for (int j = 0; j < dataLength; ++j)
    {
        [stringCipher appendString:[NSString stringWithFormat:@"%02x", (unsigned char) dataCipher[j]]];
    }
    
    return [NSString stringWithFormat:@"%@%@", IV, stringCipher];
}
@end
