//
//  songDownloader.m
//  melon
//
//  Created by Rika Nofsiswandi Chaniago on 4/25/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "songDownloader.h"
#import "DownloadList.h"
#import "mokletdevAppDelegate.h"
#import "GlobalDefine.h"
#import "AFNetworking.h"
#import "LocalPlaylist.h"

@implementation songDownloader
static songDownloader * instance = nil;

@synthesize  downloadLists = _downloadLists;
NSString * myPath;

+ (songDownloader*) sharedInstance
{
    NSLog(@"function: sharedInstance.");
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[songDownloader alloc] init];
        }
    }
    
    return  instance;
}

- (void) dealloc
{
    NSLog(@"function: dealloc.");
    [downloadLists release];
    [super dealloc];
    
}

- (void) doDownload:(NSString*)songId userid:(NSString*)userId password:(NSString*)password email:(NSString*)email
{
	////cek statusmu lagi download apa tidak? jika lagi download ,, teruskan
	//jika tidak== lakukanlah pengecekan di database, yang id nya 0,
	// lakukan download proses dan beri flag, dari 0 ke 1/ sedang di proses
	//jika berhasil update flag dari 1-3
	//jika gagal update status dari 1-2
	//cek antrian di tukang download.... masih  adakah? jika ada lakukan ulang proses no 1
	//jika tidak. maka download status di set menjadi false..
	// jika retry ubah status  dari 2 menjadi 0 dan lakuakan downlaod, update tanggalnya juga, sehingga menjadi thread download terbaru
	//_isDownloading = NO;
    //_isWaitingToDownload = YES;
    //_isAllDownloadFinished = NO;
    //_isCancel = NO;
	if(!_isDownloading){
        _isDownloading = YES;
        _isWaitingToDownload = YES;
        _isAllDownloadFinished = NO;
        _isCancel = NO;
        [self getDownloadId:songId userid:userId password:password email:email];
	}
	else{
		NSLog(@"Lagi download Lainnya");
        return;
	}
	
	
}
- (void) getDownloadId:(NSString*)songId userid:(NSString*)userId password:(NSString*)password email:(NSString*)email
{
	//http://118.98.31.135:8000/mapi/purchase/song/product?userId=1224&songId=111380672&drmType=D&bitRate=&otaDownYN=Y&_method=post&_DIR=cu&_UNAME=useremail&_UPASS=userpassword&_CNAME=client_name&_CPASS=client_pass
	NSString *client=[NSString stringWithFormat:@"iOS Client"];
	NSString *baseUrl=[NSString stringWithFormat:@"http://118.98.31.135:8000/mapi/purchase/song/product?userId=%@&songId=%@&drmType=D&bitRate=&otaDownYN=Y&_DIR=cu&_UNAME=%@&_UPASS=%@&_CNAME=%@&_CPASS=DC6AE040A9200D384D4F08C0360A2607",userId,songId,email,password,client];
	NSLog(@"baseUrl adalah-->%@",baseUrl);
	NSString *properlyEscapedURL = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//  NSString * sURL = [NSString stringWithFormat:@"%@download/history/drm", [NSString stringWithUTF8String:MAPI_SERVER]];
	
	NSURL *URL=[NSURL URLWithString:baseUrl];
	//NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    //[httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:properlyEscapedURL parameters:nil];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
    
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"------>%@",responseObject);
		 NSString * downloadId = [responseObject objectForKey:@"message"];
		
		NSLog(@"downloadId-->%@",downloadId);
		[self getSongFile:downloadId userId:userId songId:songId];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"downloadId failed: %@.", error);
        _isDownloading = NO;
        _isWaitingToDownload = NO;
        _isAllDownloadFinished = NO;
        _isCancel = YES;
                
    }];
    [operation start];
    [httpClient release];
}
- (void) getSongFile: (NSString *) downloadId userId:(NSString *)userId songId:(NSString *)songId
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startDownload" object:nil];
    
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSLog(@"function: getSongfile.");
	NSLog(@"to song file from server.");
    
    NSString * strUrl = [NSString stringWithFormat:@"%@drm/ri/downloadProc.jsp", [NSString stringWithUTF8String:DOWNLOAD_SERVER]];
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              downloadId, @"downId",
                              userId, @"userId",
							  songId,@"songId",
                              nil]
                             autorelease];
    //http://ri.melon.co.id:8200/drm/ri/downloadProc.jsp?downId=1628427&userId=1224&songId=1628427
    AFHTTPClient * httpClient = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: strUrl]] autorelease];
    [httpClient setDefaultHeader:@"User-Agent" value:@"IOS Client Download Agent"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:strUrl parameters:params];
    
    AFJSONRequestOperation * operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //NSString * songId = song.songId;
    //NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.eka", userId,songId]];
    NSLog(@"file path: %@", filepath);
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filepath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
		
		dlProgress = totalBytesRead / totalBytesExpectedToRead;
        dlProgressPercentage = (float) totalBytesRead / (float)totalBytesExpectedToRead * 100;
	
        if (_isCancel)
        {
            [operation cancel];
            _isDownloading = NO;
            _isWaitingToDownload = NO;
            _isAllDownloadFinished = NO;
            dlProgress = 0;
            dlProgressPercentage = 0;
            @try {
                NSError * err = NULL;
                NSFileManager * fm = [[NSFileManager alloc] init];
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * filepath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.eka", userId, songId]];
                BOOL result = [fm removeItemAtPath:filepath1 error:&err];
                if(!result)
                    NSLog(@"Error: %@", err);
                [fm release];
            }
            @catch (NSException *exception) {
                NSLog(@"exception while remove file.");
            }


            [self performSelector:@selector(MuatTurunBerikut) withObject:nil afterDelay:2];
        }
	
    }];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // code here
        
        NSLog(@"Download selesai.");
        NSLog(@"file path: %@", filepath);
        
        @try {
            NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filepath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.eka", userId, songId]];
            NSString * filepath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.m4a", userId, songId]];
            BOOL result = [fm moveItemAtPath:filepath1 toPath:filepath2 error:&err];
            if(!result)
            {
                NSLog(@"Error: %@", err);
                return ;
            }
            [fm release];
            myPath = [NSString stringWithString:filepath2];
        }
        @catch (NSException *exception) {
            NSLog(@"exception while rename file.");
        }
		/*
		 
		 */
		
		///file selesai di download, lalu, copy data dari DownloadList--->local list
		
		DownloadList *downloaded = [DownloadList MR_findFirstByAttribute:@"songId" withValue:songId];
		NSMutableArray *dataPass=[[NSMutableArray alloc]init];
		[dataPass addObject:downloaded.songTitle];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"downloadDone" object:dataPass];
		if(downloaded){
			
			LocalPlaylist *localPlaylist = [LocalPlaylist MR_createInContext:localContext];
			NSString *songF=[NSString stringWithFormat:@"%@-%@",downloaded.userId,downloaded.songId];
			localPlaylist.songId = songF;
			localPlaylist.filePath=myPath;
            localPlaylist.songTitle = downloaded.songTitle;
            localPlaylist.artistId = [NSString stringWithFormat:@"%@", downloaded.artistId];
            localPlaylist.artistName = downloaded.artistName;
            localPlaylist.albumId = [NSString stringWithFormat:@"%@", downloaded.albumId];
            localPlaylist.albumName = downloaded.albumName;
            localPlaylist.downId = downloadId;
            localPlaylist.userId = [NSString stringWithFormat:@"%@", downloaded.userId];
            localPlaylist.genreId = downloaded.genreId;
            localPlaylist.genreName = downloaded.genreName;
            localPlaylist.hitSongYN = downloaded.hitSongYN;
            localPlaylist.playTime = [NSString stringWithFormat:@"%@", downloaded.playTime];
			localPlaylist.realSongid=downloaded.songId;
            downloaded.finished = [NSNumber numberWithFloat:dlProgressPercentage];
            downloaded.status = [NSNumber numberWithInt:3];    // selesai
			
            @try {
                [localContext MR_save];
            }
            @catch (NSException *exception) {
                NSLog(@"Error while saving download to local playlist.");
            }
            @finally {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadASong" object:nil];
            }
			
		}
        
        _isDownloading = NO;
        _isWaitingToDownload = NO;
        _isAllDownloadFinished = NO;
        _isCancel = NO;
        
        // mulai download lagu berikutnya.
        [self MuatTurunBerikut];
        
//        NSMutableArray * downloadListItems = [NSMutableArray arrayWithArray:[DownloadList MR_findAllSortedBy:@"tanggal" ascending:NO]];
//        int e = -1;
//        for (int i = 0; i < [downloadListItems count]; i++)
//        {
//            DownloadList * downloadListItem = [downloadListItems objectAtIndex:i];
//            if (downloadListItem.status.integerValue < 3)
//            {
//                mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
//                [self doDownload:downloadListItem.songId userid:downloadListItem.userId password:appDelegate.eWebPassword email:appDelegate.eUserName];
//                
//                donwloadListIndex = i;
//                e = i;
//                break;
//            }
//        }
//         if (e < 0)
//         {
//             [self performSelector:@selector(SemuaMuatTurunSelesai) withObject:nil afterDelay:2];
//             //[[NSNotificationCenter defaultCenter] postNotificationName:@"SemuaMuatTurunSelesai" object:nil];
//         }
				
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"download failed: %@.", error);
        //DownloadList * currentListItem = [downloadLists objectAtIndex:currentDownloadListItemRow];
       // downloaded.status = 2;
        ///[self.managedObjectContext save:nil];
        _isDownloading = NO;
        _isWaitingToDownload = NO;
        _isAllDownloadFinished = NO;
        _isCancel = YES;
    }];
    [operation start];
    //[httpClient release];
}

- (void) MuatTurunBerikut
{
    NSMutableArray * downloadListItems = [NSMutableArray arrayWithArray:[DownloadList MR_findAllSortedBy:@"tanggal" ascending:NO]];
    int e = -1;
    for (int i = 0; i < [downloadListItems count]; i++)
    {
        DownloadList * downloadListItem = [downloadListItems objectAtIndex:i];
        if (downloadListItem.status.integerValue < 3)
        {
            mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
            [self doDownload:downloadListItem.songId userid:downloadListItem.userId password:appDelegate.eWebPassword email:appDelegate.eUserName];
            
            donwloadListIndex = i;
            e = i;
            break;
        }
    }
    if (e < 0)
    {
        [self performSelector:@selector(SemuaMuatTurunSelesai) withObject:nil afterDelay:2];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"SemuaMuatTurunSelesai" object:nil];
    }
}

- (void) SemuaMuatTurunSelesai
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SemuaMuatTurunSelesai" object:nil];
}

- (int) getCurrentDownloadListItemRow
{
  //  NSLog(@"function: getCurrentDownloadListItemRow %d.", currentDownloadListItemRow);
    return currentDownloadListItemRow;
}

- (void) setCurrentDownloadListItemRow: (int) value
{
   
    currentDownloadListItemRow = value;
}

- (float) getDownloadProgressPercentage
{
   // NSLog(@"function: getDownloadProgressPercentage %f.", dlProgressPercentage);
    return dlProgressPercentage;
}

- (BOOL) isDownloading
{
    //NSLog(@"function: isDownloading.");
    return _isDownloading;
}

- (BOOL) isWaitingtoDownload
{
    //NSLog(@"function: isWaitingtoDownload.");
    return _isWaitingToDownload;
}

- (BOOL) isAllDownloadFinished
{
    return _isAllDownloadFinished;
}

- (void) setCancelCurrentDownload
{
    _isCancel = YES;
}

- (int) getDowloadListIndex
{
    return donwloadListIndex;
}

- (BOOL) songInQueueAvailable
{
    NSMutableArray * downloadListItems = [NSMutableArray arrayWithArray:[DownloadList MR_findAllSortedBy:@"tanggal" ascending:NO]];
    int e = -1;
    for (int i = 0; i < [downloadListItems count]; i++)
    {
        DownloadList * downloadListItem = [downloadListItems objectAtIndex:i];
        if (downloadListItem.status.integerValue < 3)
        {
            e = i;
            break;
        }
    }
    
    return (e  < 0 ? NO : YES);
}

- (void) startContinueDownload
{
    NSMutableArray * downloadListItems = [NSMutableArray arrayWithArray:[DownloadList MR_findAllSortedBy:@"tanggal" ascending:NO]];
    int e = -1;
    for (int i = 0; i < [downloadListItems count]; i++)
    {
        DownloadList * downloadListItem = [downloadListItems objectAtIndex:i];
        if (downloadListItem.status.integerValue < 3)
        {
            mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
            [self doDownload:downloadListItem.songId userid:downloadListItem.userId password:appDelegate.eWebPassword email:appDelegate.eUserName];
            
            donwloadListIndex = i;
            e = i;
            break;
        }
    }
}

@end
