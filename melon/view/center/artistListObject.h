//
//  artistListObject.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/6/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface artistListObject : NSObject
{
    NSString * genreId;
    NSString * genre;
    NSString * domesticYN;
    NSString * artistLImgPath;
    NSString * artistSImgPath;
    NSString * artistId;
    NSString * artistName;
    NSString * groupYN;
    NSString * nationalityCd;
    NSString * gender;
    NSString * artistMImgPath;
    NSString * nationality;
}


@property(nonatomic,strong) NSString * genreId;
@property(nonatomic,strong) NSString * genre;
@property(nonatomic,strong) NSString * domesticYN;
@property(nonatomic,strong) NSString * artistLImgPath;
@property(nonatomic,strong) NSString * artistSImgPath;
@property(nonatomic,strong) NSString * artistId;
@property(nonatomic,strong) NSString * artistName;
@property(nonatomic,strong) NSString * groupYN;
@property(nonatomic,strong) NSString * nationalityCd;
@property(nonatomic,strong) NSString * gender;
@property(nonatomic,strong) NSString * artistMImgPath;
@property(nonatomic,strong) NSString * nationality;



-(id)initWithDictionary:(NSDictionary *)dictionary;
@end