//
//  ArtistBrief.h
//  Melon Player
//
//  Created by Rika Nofsiswandi Chaniago on 2/5/13.
//  Copyright (c) 2013 Rika Nofsiswandi Chaniago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArtistBrief : NSManagedObject

@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) NSString * artistLImgPath;
@property (nonatomic, retain) NSString * artistMImgPath;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * artistNameOrigin;
@property (nonatomic, retain) NSString * artistPriority;
@property (nonatomic, retain) NSString * artistRoleType;
@property (nonatomic, retain) NSString * artistRoleTypeCd;
@property (nonatomic, retain) NSString * artistSImgPath;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * bloodType;
@property (nonatomic, retain) NSString * deathday;
@property (nonatomic, retain) NSString * debutSong;
@property (nonatomic, retain) NSString * domesticYN;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * groupYN;
@property (nonatomic, retain) NSString * hobby;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * debutday;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * nationalityCd;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * performYears;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, retain) NSString * religion;
@property (nonatomic, retain) NSString * twitter;

@end
