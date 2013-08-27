//
//  mokletdevLoginViewController.h
//  melon
//
//  Created by Arie on 3/2/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MJSecondPopupDelegate;
@interface mokletdevLoginViewController : UIViewController<UITextFieldDelegate>
{
	UILabel *Logintext;
	UILabel *usr;
	UILabel *pass;
	
	UITextField *username;
	UITextField *password;
	
	UIButton *registeras_members;
	UILabel *forgetPassword;
	UIButton *login;
	
	
}
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
@end

@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(mokletdevLoginViewController*)secondDetailViewController;
@end