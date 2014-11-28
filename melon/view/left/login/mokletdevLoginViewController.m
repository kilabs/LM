//
//  mokletdevLoginViewController.m
//  melon
//
//  Created by Arie on 3/2/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "mokletdevLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSStrinAdditions.h"
#import "UserBrief.h"
#include "GlobalDefine.h"
#import "AFNetworking.h"

#define kOFFSET_FOR_KEYBOARD 280.0

@interface mokletdevLoginViewController ()

@end

@implementation mokletdevLoginViewController

BOOL stayUp;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.frame=CGRectMake(0, 0, 300, 300);
		self.view.backgroundColor=[UIColor whiteColor];
		self.view.layer.cornerRadius=5;
		Logintext=[[UILabel alloc]init];
		Logintext.text=@"Login to LangitMusiks";
			[Logintext setFont:[UIFont fontWithName:@"MuseoSans-700" size:18]];
		Logintext.frame=CGRectMake(0, 0, 300, 40);
		Logintext.textAlignment=NSTextAlignmentCenter;
		Logintext.backgroundColor=[UIColor clearColor];
		UIView *line=[[UIView alloc]init];
		line.frame=CGRectMake(0, Logintext.frame.size.height-1, 300, 1);
		line.backgroundColor=[UIColor darkGrayColor];
		
		usr=[[UILabel alloc]init];
		usr.backgroundColor=[UIColor clearColor];
		usr.frame=CGRectMake(5, 75, 300, 20);
		[usr setFont:[UIFont fontWithName:@"MuseoSans-500" size:13]];
		usr.text=@"Username/MSISDN";
		
		username=[[UITextField alloc]initWithFrame:CGRectMake(5, 100,290,40)];
		username.delegate=self;
		username.textAlignment=NSTextAlignmentCenter;
		[username setFont:[UIFont fontWithName:@"MuseoSans-500" size:15]];
		[username setAdjustsFontSizeToFitWidth:YES];
		username.backgroundColor=[UIColor whiteColor];
		username.layer.cornerRadius=2.0f;
		username.placeholder=@"User Name";
		username.layer.masksToBounds=YES;
		username.layer.borderColor=[[UIColor lightGrayColor]CGColor];
		username.layer.borderWidth= 1.0f;
		username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [username addTarget:self action:@selector(usernameFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		
		pass=[[UILabel alloc]init];
		pass.backgroundColor=[UIColor clearColor];
		pass.frame=CGRectMake(5, 145, 300, 20);
		[pass setFont:[UIFont fontWithName:@"MuseoSans-500" size:13]];
		pass.text=@"Your Password";
		
		password=[[UITextField alloc]initWithFrame:CGRectMake(5, 170,290,40)];
		password.delegate=self;
		password.textAlignment=NSTextAlignmentCenter;
		[password setFont:[UIFont fontWithName:@"MuseoSans-500" size:15]];
		[password setAdjustsFontSizeToFitWidth:YES];
		password.backgroundColor=[UIColor whiteColor];
		password.layer.cornerRadius=2.0f;
		password.placeholder=@"Password";
		password.secureTextEntry = YES;
		password.layer.masksToBounds=YES;
		password.layer.borderColor=[[UIColor lightGrayColor]CGColor];
		password.layer.borderWidth= 1.0f;
		password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [password addTarget:self action:@selector(passwordFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
		login=[UIButton buttonWithType:UIButtonTypeRoundedRect];
		login.frame=CGRectMake(5, 250, 200, 44);
		[login setTitle:@"Login now!" forState:UIControlStateNormal];
		[login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
		
		
		[self.view addSubview:line];
		[self.view addSubview:Logintext];
		[self.view addSubview:usr];
		[self.view addSubview:username];
		[self.view addSubview:pass];
		[self.view addSubview:password];
		[self.view addSubview:login];
		
		
    }
    return self;
}

-(void)login:(id)sender{
	
	/*
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    
    // ------- :(
	 */
    //[self authenticateClient];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) authenticateClient
{
    NSString * strUrl = [NSString stringWithFormat:@"%@authentication/client", [NSString stringWithUTF8String:MAPI_SERVER]];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithUTF8String:CNAME], @"clientName",
                             [NSString stringWithUTF8String:CPASS], @"password",
                             nil];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: strUrl]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:strUrl parameters:params];
    
    AFJSONRequestOperation * operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSLog(@"responser->%@",responseObject);
        // code here
       // [self tryToLogin];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"authenticationMe failed: %@.", error);
    }];
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [operation release];
    [params release];
    [httpClient release];
}
/*
- (BOOL) tryToLogin
{
    NSString    * userName = username.text;
    NSData      * dataPW = [password.text dataUsingEncoding:NSASCIIStringEncoding];
    NSString    * passWord = [NSString base64StringFromData:dataPW length:[dataPW length]];
    NSString    * strUrl = [NSString stringWithFormat:@"%@authentication/user", [NSString stringWithUTF8String:MAPI_SERVER]];
    NSString* escapedUrl = [strUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * myURL = [self smartURLForString:escapedUrl];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             userName, @"userEmail",
                             passWord, @"password",
                             //@"c", @"DIR",
                             //@"iOS Client", @"_CNAME",
                             //@"DC6AE040A9200D384D4F08C0360A2607", @"_CPASS",
                             nil];
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:myURL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:strUrl parameters:params];
    AFJSONRequestOperation * operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject)
    {
        mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
//        for(id myDictionary in [responseObject objectForKey:@"User"])
//        {
//            appDelegate.user = [[UserBrief alloc] initWithDictionary:myDictionary];
//        }
//        
//        if (appDelegate.user.userId != nil)
//        {
//            NSLog(@"UserId: %@", appDelegate.user.userId);
//            [self LoginSucceeded:YES];
//        }
//        else
//        {
//            [self LoginSucceeded:NO];
//        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error while request on login: %@", error);
    }];
    
    [operation start];
    [operation release];
    [params release];
    [httpClient release];
    return YES;
}
*/
/*
- (void) LoginSucceeded: (BOOL) balikan
{
    if (balikan == YES)
    {
        [self.delegate cancelButtonClicked:self];
    }
    else if (balikan == NO)
    {
        
    }
}
*/
/*
- (BOOL) usernameFieldShouldReturn: (UITextField *) textField
{
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }

    [username resignFirstResponder];
    [password becomeFirstResponder];
    return NO;
}

- (BOOL) passwordFieldShouldReturn: (UITextField *) textField
{
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }
    
    [password resignFirstResponder];
    return NO;
}
*/


//- (void) textFieldDidBeginEditing:(UITextField *)textField
//{
//    stayUp = YES;
//    [self setViewMoveUp:YES];
//}

//- (void) textFieldDidEndEditing:(UITextField *)textField
//{
//    stayUp = NO;
//    [self setViewMoveUp:NO];
//}

- (void) keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
}

- (void) keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}

- (void) setViewMoveUp: (BOOL) moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect r = self.view.frame;
    if(moveUp)
    {
        if (r.origin.y == 0)
        {
            r.origin.y -= kOFFSET_FOR_KEYBOARD;
        }
    }
    else
    {
        if (stayUp == NO)
        {
            r.origin.y += kOFFSET_FOR_KEYBOARD;
        }
    }
    self.view.frame = r;
    [UIView commitAnimations];
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                NSLog(@"It looks like this is some unsupported URL scheme.");
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

@end
