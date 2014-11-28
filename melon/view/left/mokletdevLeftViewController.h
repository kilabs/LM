//
//  mokletdevLeftViewController.h
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mokletdevLoginViewController.h"
#import <MessageUI/MessageUI.h>
#import "songListObject.h"
#import "EUserBrief.h"
#import <FacebookSDK/FacebookSDK.h>

@interface mokletdevLeftViewController : UIViewController<UITableViewDelegate, UITextFieldDelegate,UITableViewDataSource,MJSecondPopupDelegate,MFMailComposeViewControllerDelegate,FBLoginViewDelegate>
{
	UITableView *MelonListLeft;
	NSMutableArray *dummyData;
	    mokletdevLoginViewController *detailViewController;
		NSInteger selectedIndex;
    NSTimer * timerCheckLogin;

}
@property (nonatomic, retain) NSArray *arrayOriginal;
@property (nonatomic, retain) NSMutableArray *arForTable;

@property (nonatomic, retain) UILabel     * txtLogin;
@property (nonatomic, retain) UIButton    * btnLogin;
@property (nonatomic, retain) UIButton    * btnRegister;
@property (nonatomic, retain) UILabel     * txtUserName;
@property (nonatomic, retain) UITextField * inputUsername;
@property (nonatomic, retain) UILabel     * txtPassword;
@property (nonatomic, retain) UITextField * inputPassword;
@property (nonatomic, retain) UIView      * loginContainer;

@property (nonatomic, retain) UIButton    * facebookconnect, *twitterConnect;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, retain) UILabel     * UserNameTop;
@property (nonatomic, retain) UIButton *user_setting;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, strong) EUserBrief *userb;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) UILabel *user_active_now;
@property (nonatomic, strong) NSString *user_active;

-(void)miniMizeThisRows:(NSArray*)ar;
- (void) addDownloadList: (songListObject *) song;
@end
