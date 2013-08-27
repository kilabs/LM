//
//  songDownloader.h
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/25/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class DownloadList;

@interface songDownloader : NSObject
{
    //NSTimer * timerDownload;
    NSArray * downloadLists;
    int       currentDownloadListItemRow;
    long long dlProgress;
    float     dlProgressPercentage;
    bool      _isDownloading;
    bool      _isWaitingToDownload;
    bool      _isAllDownloadFinished;
    bool      _isCancel;
    int       donwloadListIndex;

}

+ (songDownloader*) sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
//@property (nonatomic, retain) DownloadList  * currentDownloadItem;
@property (nonatomic, strong) NSMutableArray * downloadLists;

- (void) addSongToDownloadList: (DownloadList *) downloadItem;
- (void) doDownload:(NSString*)songId userid:(NSString*)userId password:(NSString*)password email:(NSString*)email;
- (void) doDownloadAtIndex:(int) index;
- (int) getCurrentDownloadListItemRow;
//- (void) setCurrentDownloadListItemRow: (int) value;
- (float) getDownloadProgressPercentage;
- (BOOL) isDownloading;
- (BOOL) isWaitingtoDownload;
- (BOOL) isAllDownloadFinished;
- (void) setCancelCurrentDownload;
- (int) getDowloadListIndex;
- (BOOL) songInQueueAvailable;
- (void) startContinueDownload;


@end
