//
//  addPlaylistForm.h
//  melon
//
//  Created by Arie on 5/19/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addplaylistFormDelegate;
@interface addPlaylistForm : UIViewController<UITextFieldDelegate>
{
	UIButton *tambah;
	UITextField *playlist;
}
@property (assign, nonatomic) id <addplaylistFormDelegate>delegate;
@end
@protocol addplaylistFormDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(addPlaylistForm*)add;
@end

