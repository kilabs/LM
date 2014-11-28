//
//  mokletdevLeftViewController.m
//  melon
//
//  Created by Arie on 3/4/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "mokletdevLeftViewController.h"
#import "mokletdevLeftCell.h"
#import "AFNetworking.h"
#include "GlobalDefine.h"
#import "NSStrinAdditions.h"
#import "mokletdevAppDelegate.h"
#import "DownloadList.h"
#import "localplayer.h"
#import "LocalPlaylist.h"
#import "LocalPlaylist1.h"
#import "MelonPlayer.h"
#import "mokletdevAppDelegate.h"
@interface mokletdevLeftViewController ()

@property (nonatomic, retain) NSString * tempWebPassword;
@property (nonatomic, retain) NSString * tempUserName;

@end

@implementation mokletdevLeftViewController

@synthesize userb;
@synthesize btnLogin;
@synthesize btnRegister;
@synthesize txtLogin;
@synthesize txtUserName;
@synthesize inputUsername;
@synthesize txtPassword;
@synthesize inputPassword;
@synthesize loginContainer;
@synthesize facebookconnect;
@synthesize twitterConnect;
@synthesize userImage;
@synthesize UserNameTop;
@synthesize user_setting;
@synthesize headerView=_headerView;
@synthesize user_active_now;

@synthesize tempWebPassword;
@synthesize tempUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		self.view.backgroundColor=[UIColor colorWithRed:0.282 green:0.282 blue:0.286 alpha:1] ;
        
		// Do any additional setup after loading the view.
		user_active_now= [[UILabel alloc] initWithFrame: CGRectMake(10,14, 200, 20)];
		user_active_now.backgroundColor = [UIColor clearColor];
		user_active_now.textColor=[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
		user_active_now.text=NSLocalizedString(@"LangitMusik Menu", nil);
		[user_active_now setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
		user_active_now.layer.shadowOpacity = 1.0;
		user_active_now.layer.shadowRadius = 1.0;
		user_active_now.layer.shadowColor = [UIColor blackColor].CGColor;
		user_active_now.layer.shadowOffset = CGSizeMake(0.0, 1.0);
		
		
		
		// Custom initialization
		MelonListLeft = [[UITableView alloc]init];
		MelonListLeft.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
		MelonListLeft.backgroundColor=[UIColor clearColor];
		MelonListLeft.dataSource=self;
		MelonListLeft.delegate=self;
		MelonListLeft.scrollEnabled = NO;
		MelonListLeft.separatorColor=[UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1];
		
		selectedIndex=-1;
		
		[self.view addSubview:MelonListLeft];
		
		MelonListLeft.hidden=NO;
		
		loginContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 640.0)];
		[loginContainer setBackgroundColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.0]];
		[self.view addSubview:loginContainer];
		
		
		//Float32 left = 20.0;
		
		facebookconnect = [UIButton buttonWithType:UIButtonTypeCustom];
		[facebookconnect setBackgroundImage:[UIImage imageNamed:@"facebook-connect"] forState:UIControlStateNormal];
		facebookconnect.frame=CGRectMake(10, 130,231,41);
		facebookconnect.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
		[facebookconnect addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
		//[btnLogin setTitle:@"Sign In" forState:UIControlStateNormal];
		//[btnLogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
		//[facebookconnect addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
		//[loginContainer addSubview:facebookconnect];
		
		twitterConnect = [UIButton buttonWithType:UIButtonTypeCustom];
		[twitterConnect setBackgroundImage:[UIImage imageNamed:@"twitter-login"] forState:UIControlStateNormal];
		twitterConnect.frame=CGRectMake(135, 130,104,40);
		twitterConnect.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
		//[btnLogin setTitle:@"Sign In" forState:UIControlStateNormal];
		//[btnLogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
		//[facebookconnect addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
		//[loginContainer addSubview:twitterConnect];
	
		
		
		txtLogin=[[UILabel alloc]init];
		txtLogin.text=@"Login";
		[txtLogin setFont:[UIFont fontWithName:@"MuseoSans-700" size:32]];
		txtLogin.frame=CGRectMake(20, 120.0, 280.0, 40.0);
		txtLogin.textAlignment=NSTextAlignmentLeft;
		txtLogin.textColor = [UIColor whiteColor];
		txtLogin.backgroundColor=[UIColor clearColor];
		
		
		
		txtUserName=[[[UILabel alloc]init] autorelease];
		txtUserName.text=@"Username/ID:";
		
		txtUserName=[[UILabel alloc]init];
		txtUserName.text=@"OR";
		
		
		[txtUserName setFont:[UIFont fontWithName:@"MuseoSans-700" size:12]];
		txtUserName.frame=CGRectMake(115, 140, 40, 20.0);
		txtUserName.textAlignment=NSTextAlignmentLeft;
		txtUserName.textColor = [UIColor whiteColor];
		txtUserName.backgroundColor=[UIColor clearColor];
		
		
		inputUsername=[[UITextField alloc]initWithFrame:CGRectMake(10, 151,230,40)];
		//inputUsername.delegate=self;
		inputUsername.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		inputUsername.leftViewMode = UITextFieldViewModeAlways;
		inputUsername.tag=1;
		inputUsername.textAlignment=NSTextAlignmentLeft;
		[inputUsername setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
		[inputUsername setAdjustsFontSizeToFitWidth:YES];
		inputUsername.backgroundColor=[UIColor whiteColor];
		inputUsername.layer.cornerRadius=2.0f;
		inputUsername.returnKeyType=UIReturnKeyNext;
		inputUsername.delegate = self;
		inputUsername.placeholder=NSLocalizedString(@"Phone Number", nil);
		inputUsername.layer.masksToBounds=YES;
		inputUsername.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"username"]];
		inputUsername.layer.borderWidth= 1.0f;
		inputUsername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		//[inputUsername addTarget:self action:@selector(usernameFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
		inputUsername.keyboardType = UIKeyboardTypePhonePad;
		inputUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
		inputUsername.autocorrectionType = UITextAutocorrectionTypeNo;
		
        inputPassword=[[UITextField alloc]initWithFrame:CGRectMake(10, 211,230,40)];
		//inputPassword.delegate=self;
		inputPassword.tag=2;
		
		inputPassword.textAlignment=NSTextAlignmentLeft;
		[inputPassword setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
		[inputPassword setAdjustsFontSizeToFitWidth:YES];
		inputPassword.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"username"]];
		inputPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		inputPassword.leftViewMode = UITextFieldViewModeAlways;
		inputPassword.delegate=self;
		inputPassword.layer.borderWidth= 1.0f;
		inputPassword.secureTextEntry=YES;
		inputPassword.layer.cornerRadius=2.0f;
		inputPassword.returnKeyType=UIReturnKeyDone;
		inputPassword.placeholder=NSLocalizedString(@"Password", nill);
		inputPassword.layer.masksToBounds=YES;
		inputPassword.layer.borderWidth= 1.0f;
		inputPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		//[inputPassword addTarget:self action:@selector(passwordFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		
		btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnLogin setBackgroundImage:[UIImage imageNamed:@"common-navbar"] forState:UIControlStateNormal];
		btnLogin.frame=CGRectMake(10, 270,230,36);
		btnLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
		[btnLogin setTitle:NSLocalizedString(@"Sign In", nill) forState:UIControlStateNormal];
		//[btnLogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
		[btnLogin addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
		[loginContainer addSubview:btnLogin];
        
        btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRegister setBackgroundImage:[UIImage imageNamed:@"common-navbar1"] forState:UIControlStateNormal];
		btnRegister.frame=CGRectMake(10, 320,230,36);
		btnRegister.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
		[btnRegister setTitle:NSLocalizedString(@"Register", nill) forState:UIControlStateNormal];
		[btnRegister addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
		[loginContainer addSubview:btnRegister];
		
		loginContainer.hidden = NO;
		MelonListLeft.hidden = YES;
		
		//[loginContainer addSubview:txtUserName];
		[loginContainer addSubview:inputUsername];
		[loginContainer addSubview:inputPassword];
		//[loginContainer addSubview:txtUserName];
		    }
    return self;
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
	
    NSLog(@"Logged In");

	
	
}


-(void)facebookLogin:(id)sender{
	// get the app delegate so that we can access the session property
    mokletdevAppDelegate *appDelegate = (mokletdevAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
		NSLog(@"appDelegate.session.isOpen");
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
			NSLog(@"!= FBSessionStateCreated");
        }
        NSLog(@"else");
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            //[self facebookLogin:nil];
			[self updateView];
        }];
    }

		
}
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    mokletdevAppDelegate *appDelegate = (mokletdevAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {

		NSLog(@"accesstoken sekarang--->%@",appDelegate.session.accessTokenData.accessToken);
		[self fetchDataFromFacebook:appDelegate.session.accessTokenData.accessToken];
	
    } else {
       NSLog(@"accesstoken--->%@",appDelegate.session.accessTokenData.accessToken);
    }
}
-(void)fetchDataFromFacebook:(NSString*)data{
	 //mokletdevAppDelegate *appDelegate = (mokletdevAppDelegate *)[[UIApplication sharedApplication]delegate];
	NSString *baseUrl=[NSString stringWithFormat:@"https://graph.facebook.com/me?fields=email,name,first_name,id&access_token=%@",data];
	NSURL *URL=[NSURL URLWithString:baseUrl];
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response Object------>%@",[responseObject objectForKey:@"email"]);
		NSString *emails;
		if([responseObject objectForKey:@"email"]==(NSString *)[NSNull null]){
		emails=@"";
		}
		else{
			emails=[responseObject objectForKey:@"email"];
		}
        NSLog(@"email from facebook: %@.", emails);
		[self facebooklogin:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"id"]] email:[NSString stringWithFormat:@"%@",emails]];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if(error){
			NSLog(@"%@",error);
		}
	}];
	//[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
	[operation release];

	}
- (void) Login
{
	[self tryToLogin:@"" withPassword:@""];
	
	
}


- (void) Register
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:NSLocalizedString(@"Register Message", nil)
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	
	//bool already=NO;
	
	//[self.sidePanelController setCenterPanelHidden:YES animated:YES duration:0.2f];
	[UIView animateWithDuration:0.2 animations:^{
		//username 20, 191,200,40
		///password 20, 271,200,40
		loginContainer.frame=CGRectMake(0, -50, 320, 640);
		//inputUsername.frame=CGRectMake(10, inputUsername.frame.origin.y, 295, inputUsername.frame.size.height);
		//inputPassword.frame=CGRectMake(10, inputPassword.frame.origin.y, 295, inputPassword.frame.size.height);
		//btnLogin.frame=CGRectMake(10, 310,295,36);
	}];
	
	/*
	 if(textField.tag==1){
	 if(already==NO){
	 [UIView animateWithDuration:0.2 animations:^{
	 inputUsername.frame=CGRectMake(inputUsername.frame.origin.x-10, inputUsername.frame.origin.y, inputUsername.frame.size.width+95, inputUsername.frame.size.height);
	 }];
	 already=YES;
	 }
	 }*/return YES;
	
	// _field.background = [UIImage imageNamed:@"focus.png"];
	// return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldEndEditing");
	//   _field.background = [UIImage imageNamed:@"nofocus.png"];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
	//[self.netraMutableArray removeAllObjects];
	//[searchResult reloadData];
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField.tag==1){
		
		[inputUsername resignFirstResponder];
		[inputPassword becomeFirstResponder];
	}
	if(inputPassword.tag==2){
		
		[UIView animateWithDuration:0.2 animations:^{
			//username 20, 191,200,40
			///password 20, 271,200,40
			//loginContainer.frame=CGRectMake(0, -50, 320, 640);
			loginContainer.frame=CGRectMake(0, 0, 320, 640);
			//inputUsername.frame=CGRectMake(10, inputUsername.frame.origin.y, 295, inputUsername.frame.size.height);
			//inputPassword.frame=CGRectMake(10, inputPassword.frame.origin.y, 295, inputPassword.frame.size.height);
			//btnLogin.frame=CGRectMake(10, 310,295,36);
		}];
		
		[inputPassword resignFirstResponder];
		
	}
	
    //[searchForm resignFirstResponder];
    return YES;
}
- (void) authenticateClient
{
    NSString * strUrl = [NSString stringWithFormat:@"%@authentication/client", [NSString stringWithUTF8String:MAPI_SERVER]];
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
							  [NSString stringWithUTF8String:CNAME], @"clientName",
							  [NSString stringWithUTF8String:CPASS], @"password",
							  nil] autorelease];
    
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: strUrl]];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:strUrl parameters:params];
    
    AFJSONRequestOperation * operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // code here
		
		NSLog(@"responseObject--->%@",responseObject);
        //NSLog(@"respon auth client: %@", [[[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding] autorelease]);
		
		[self tryToLogin:@"" withPassword:@""];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"authenticationMe failed: %@.", error);
    }];
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
}

- (void) tryToLogin: (NSString *) eUserName withPassword: (NSString *) ePassword
{
    mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString * userName;
    NSString * ekaPassW;
    
    if ([eUserName isEqualToString:@""])
    {
        userName = inputUsername.text;
        ekaPassW = inputPassword.text;
    }
    else
    {
        userName = eUserName;
        ekaPassW = ePassword;
    }
	
    //NSData      * dataPW = [inputPassword.text dataUsingEncoding:NSASCIIStringEncoding];
    NSData      * dataPW = [ekaPassW dataUsingEncoding:NSASCIIStringEncoding];
    NSString    * passWord = [NSString base64StringFromData:dataPW length:[dataPW length]];
    self.tempUserName = userName;
    self.tempWebPassword = passWord;
    appDelegate.eUserName = inputUsername.text;
    appDelegate.ePassword = inputPassword.text;
    appDelegate.eWebPassword = passWord;
    NSString    * strUrl = [NSString stringWithFormat:@"%@authentication/user", [NSString stringWithUTF8String:MAPI_SERVER]];
    NSString* escapedUrl = [strUrl
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * myURL = [self smartURLForString:escapedUrl];
    
    NSDictionary * params = [[[NSDictionary alloc] initWithObjectsAndKeys:
							  userName, @"userEmail",
							  passWord, @"password",
							  @"c", @"_DIR",
							  [NSString stringWithUTF8String:CNAME], @"_CNAME",
							  [NSString stringWithUTF8String:CPASS], @"_CPASS",
							  nil] autorelease];
    AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:myURL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:strUrl parameters:params];
    AFJSONRequestOperation * operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease] ;
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject)
     {
		 NSLog(@"responseObject login--->%@",responseObject);
		 
		 //[self.userb setTitle:[self.titleField text]];
		 //[self.note setKeywords:[self.keywordsField text]];
		 //[self.note setBody:[self.bodyView text]];
		 
		 [self.inputPassword resignFirstResponder];
		 [self.inputUsername resignFirstResponder];
		 NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
		 userb = [EUserBrief MR_createInContext:localContext];
		 //(NSString *)[NSNull null]
		 self.user_active_now.text=userName;
		 userb.ePassword=ekaPassW;
		 userb.Username=userName;
		 if( [responseObject objectForKey:@"autoRetentionYN"]==(NSString *)[NSNull null]){
			 userb.autoRetentionYN=@"";
		 }
		 else{
			 userb.autoRetentionYN  = [responseObject objectForKey:@"autoRetentionYN"];
		 }
		 if( [responseObject objectForKey:@"birthday"]==(NSString *)[NSNull null]){
			 userb.birthday =@"";
		 }
		 else{
			 userb.birthday      = [responseObject objectForKey:@"birthday"];
		 }
		 if( [responseObject objectForKey:@"email"]==(NSString *)[NSNull null]){
			 userb.email =@"";
		 }
		 else{
			 userb.email         = [responseObject objectForKey:@"email"];
		 }
		 
		 if( [responseObject objectForKey:@"eventSmsYN"]==(NSString *)[NSNull null]){
			 userb.eventSmsYN =@"";
		 }
		 else{
			 userb.eventSmsYN         = [responseObject objectForKey:@"eventSmsYN"];
		 }
		 if( [responseObject objectForKey:@"gender"]==(NSString *)[NSNull null]){
			 userb.gender =@"";
		 }
		 else{
			 userb.gender         = [responseObject objectForKey:@"eventSmsYN"];
		 }
		 
		 if( [responseObject objectForKey:@"handsetId"]==(NSString *)[NSNull null]){
			 userb.handsetId =@"";
		 }
		 else{
			 userb.handsetId      = [responseObject objectForKey:@"hansetId"];
		 }
		 
		 if( [responseObject objectForKey:@"lastIp"]==(NSString *)[NSNull null]){
			 userb.lastIp =@"";
		 }
		 else{
			 userb.lastIp        = [responseObject objectForKey:@"lastIp"];
		 }
		 if( [responseObject objectForKey:@"msisdn"]==(NSString *)[NSNull null]){
			 userb.msisdn =@"";
		 }
		 else{
			 userb.msisdn        = [responseObject objectForKey:@"msisdn"];
		 }
		 
		 if( [responseObject objectForKey:@"newsMailingYN"]==(NSString *)[NSNull null]){
			 userb.newsMailingYN =@"";
		 }
		 else{
			 userb.newsMailingYN = [responseObject objectForKey:@"newsMailingYN"];
		 }
		 if( [responseObject objectForKey:@"nickname"]==(NSString *)[NSNull null]){
			 userb.nickname =@"";
		 }
		 else{
			 userb.nickname = [responseObject objectForKey:@"nickname"];
		 }
		 
		 if( [responseObject objectForKey:@"productYN"]==(NSString *)[NSNull null]){
			 userb.productYN =@"";
		 }
		 else{
			 userb.productYN = [responseObject objectForKey:@"productYN"];
		 }
		 
		 if( [responseObject objectForKey:@"provinceId"]==(NSString *)[NSNull null]){
			 userb.provinceId =@"";
		 }
		 else{
			 userb.provinceId = [responseObject objectForKey:@"provinceId"];
		 }
		 if( [responseObject objectForKey:@"param1"]==(NSString *)[NSNull null]){
			 userb.param1 =@"";
		 }
		 else{
			 userb.param1 = [responseObject objectForKey:@"param1"];
		 }
		 if( [responseObject objectForKey:@"param2"]==(NSString *)[NSNull null]){
			 userb.param2 =@"";
		 }
		 else{
			 userb.param2 = [responseObject objectForKey:@"param2"];
		 }
		 if( [responseObject objectForKey:@"param3"]==(NSString *)[NSNull null]){
			 userb.param3 =@"";
		 }
		 else{
			 userb.param3 = [responseObject objectForKey:@"param3"];
		 }
		 
		 if( [responseObject objectForKey:@"quizAnswer"]==(NSString *)[NSNull null]){
			 userb.quizAnswer =@"";
		 }
		 else{
			 userb.quizAnswer = [responseObject objectForKey:@"quizAnswer"];
		 }
		 
		 if( [responseObject objectForKey:@"quizId"]==(NSString *)[NSNull null]){
			 userb.quizId =@"";
		 }
		 else{
			 userb.quizId = [responseObject objectForKey:@"quizId"];
		 }
		 
		 if( [responseObject objectForKey:@"receiveRoYN"]==(NSString *)[NSNull null]){
			 userb.receiveRoYN =@"";
		 }
		 else{
			 userb.receiveRoYN = [responseObject objectForKey:@"receiveRoYN"];
		 }
		 
		 if( [responseObject objectForKey:@"regDate"]==(NSString *)[NSNull null]){
			 userb.regDate =@"";
		 }
		 else{
			 userb.regDate = [[responseObject objectForKey:@"regDate"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"updDate"]==(NSString *)[NSNull null]){
			 userb.updDate =@"";
		 }
		 else{
			 userb.updDate = [[responseObject objectForKey:@"updDate"]stringValue];
		 }

		 if( [responseObject objectForKey:@"status"]==(NSString *)[NSNull null]){
			 userb.status =@"";
		 }
		 else{
			 userb.status = [responseObject objectForKey:@"status"];
		 }
		 
		 if( [responseObject objectForKey:@"telcoId"]==(NSString *)[NSNull null]){
			 userb.telcoId =@"";
		 }
		 else{
			 userb.telcoId = [[responseObject objectForKey:@"telcoId"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"userId"]==(NSString *)[NSNull null]){
			 userb.userId =@"";
		 }
		 else{
			 userb.userId = [[responseObject objectForKey:@"userId"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"userType"]==(NSString *)[NSNull null]){
			 userb.userType =@"";
		 }
		 else{
			 userb.userType = [responseObject objectForKey:@"userType"];
		 }
		 
		 if( [responseObject objectForKey:@"speedyId"]==(NSString *)[NSNull null]){
			 userb.speedyId =@"";
		 }
		 else{
			 userb.speedyId = [responseObject objectForKey:@"speedyId"];
		 }
		 
		 if( [responseObject objectForKey:@"webPassword"]==(NSString *)[NSNull null]){
			 userb.webPassword = passWord;
		 }
		 else{
			 userb.webPassword = [responseObject objectForKey:@"webPassword"];
		 }
		 
         appDelegate.eUserId = userb.userId;
         
		 [localContext MR_save];
		 
		 [loginContainer setHidden:YES];
		 [MelonListLeft setHidden:NO];
		 NSMutableArray *dataPass=[[NSMutableArray alloc]init];
		 [dataPass addObject:@"mokletdevViewController"];
		 [[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		 //[self.sidePanelController showCenterPanel:NO];
		 [dataPass removeAllObjects];
		 [dataPass release];

         [appDelegate ambilLayanan:userb.userId];
		 
		 
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error while request on login: %@", error);
		 NSLog(@"Error respons: %@", [[[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding] autorelease]);
         
         [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
                                      message:NSLocalizedString(@"Login Failed Message", nil)
                                     delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil] autorelease] show];
     }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];
	
}



-(void)facebooklogin:(NSString *)userId email:(NSString *)email{
	
	if([email isKindOfClass:[NSNull class]]){
		email=@"";
	}
	if([email isEqualToString:@"<null>"]){
	email=@"";
	}
	
	NSString* escapedUrl = [[NSString stringWithFormat:@"%@authentication/user/facebook/m?validationId=%@&email=%@&_DIR=c&_CNAME=%@&_CPASS=%@&_method=POST",[NSString stringWithUTF8String:MAPI_SERVER],userId,email,[NSString stringWithUTF8String:CNAME], [NSString stringWithUTF8String:CPASS]]
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"escapedUrl--->%@",escapedUrl);
	 NSURL * myURL = [self smartURLForString:escapedUrl];
	AFHTTPClient * httpClient = [[AFHTTPClient alloc] initWithBaseURL:myURL];
    [httpClient setDefaultHeader:@"User-Agent" value:@"MAPI Client 1"];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableURLRequest * request = [httpClient requestWithMethod:@"POST" path:escapedUrl parameters:nil];
    AFJSONRequestOperation * operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease] ;
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject)
     {
		 
		 NSLog(@"response object-->%@",responseObject);
		
		 
		 [self.inputPassword resignFirstResponder];
		 [self.inputUsername resignFirstResponder];
		 NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
		 userb = [EUserBrief MR_createInContext:localContext];
		 //(NSString *)[NSNull null]
		 self.user_active_now.text=[responseObject objectForKey:@"email"];
		 NSData      * dataPW = [[responseObject objectForKey:@"webPassword"] dataUsingEncoding:NSASCIIStringEncoding];
		 NSString    * passWord = [NSString base64StringFromData:dataPW length:[dataPW length]];
		 userb.ePassword=passWord;
		 userb.Username=[responseObject objectForKey:@"email"];
		 if( [responseObject objectForKey:@"autoRetentionYN"]==(NSString *)[NSNull null]){
			 userb.autoRetentionYN=@"";
		 }
		 else{
			 userb.autoRetentionYN  = [responseObject objectForKey:@"autoRetentionYN"];
		 }
		 if( [responseObject objectForKey:@"birthday"]==(NSString *)[NSNull null]){
			 userb.birthday =@"";
		 }
		 else{
			 userb.birthday      = [responseObject objectForKey:@"birthday"];
		 }
		 if( [responseObject objectForKey:@"email"]==(NSString *)[NSNull null]){
			 userb.email =@"";
		 }
		 else{
			 userb.email         = [responseObject objectForKey:@"email"];
		 }
		 
		 if( [responseObject objectForKey:@"eventSmsYN"]==(NSString *)[NSNull null]){
			 userb.eventSmsYN =@"";
		 }
		 else{
			 userb.eventSmsYN         = [responseObject objectForKey:@"eventSmsYN"];
		 }
		 if( [responseObject objectForKey:@"gender"]==(NSString *)[NSNull null]){
			 userb.gender =@"";
		 }
		 else{
			 userb.gender         = [responseObject objectForKey:@"eventSmsYN"];
		 }
		 
		 if( [responseObject objectForKey:@"handsetId"]==(NSString *)[NSNull null]){
			 userb.handsetId =@"";
		 }
		 else{
			 userb.handsetId      = [responseObject objectForKey:@"hansetId"];
		 }
		 
		 if( [responseObject objectForKey:@"lastIp"]==(NSString *)[NSNull null]){
			 userb.lastIp =@"";
		 }
		 else{
			 userb.lastIp        = [responseObject objectForKey:@"lastIp"];
		 }
		 if( [responseObject objectForKey:@"msisdn"]==(NSString *)[NSNull null]){
			 userb.msisdn =@"";
		 }
		 else{
			 userb.msisdn        = [responseObject objectForKey:@"msisdn"];
		 }
		 
		 if( [responseObject objectForKey:@"newsMailingYN"]==(NSString *)[NSNull null]){
			 userb.newsMailingYN =@"";
		 }
		 else{
			 userb.newsMailingYN = [responseObject objectForKey:@"newsMailingYN"];
		 }
		 if( [responseObject objectForKey:@"nickname"]==(NSString *)[NSNull null]){
			 userb.nickname =@"";
		 }
		 else{
			 userb.nickname = [responseObject objectForKey:@"nickname"];
		 }
		 
		 if( [responseObject objectForKey:@"productYN"]==(NSString *)[NSNull null]){
			 userb.productYN =@"";
		 }
		 else{
			 userb.productYN = [responseObject objectForKey:@"productYN"];
		 }
		 
		 if( [responseObject objectForKey:@"provinceId"]==(NSString *)[NSNull null]){
			 userb.provinceId =@"";
		 }
		 else{
			 userb.provinceId = [responseObject objectForKey:@"provinceId"];
		 }
		 if( [responseObject objectForKey:@"param1"]==(NSString *)[NSNull null]){
			 userb.param1 =@"";
		 }
		 else{
			 userb.param1 = [responseObject objectForKey:@"param1"];
		 }
		 if( [responseObject objectForKey:@"param2"]==(NSString *)[NSNull null]){
			 userb.param2 =@"";
		 }
		 else{
			 userb.param2 = [responseObject objectForKey:@"param2"];
		 }
		 if( [responseObject objectForKey:@"param3"]==(NSString *)[NSNull null]){
			 userb.param3 =@"";
		 }
		 else{
			 userb.param3 = [responseObject objectForKey:@"param3"];
		 }
		 
		 if( [responseObject objectForKey:@"quizAnswer"]==(NSString *)[NSNull null]){
			 userb.quizAnswer =@"";
		 }
		 else{
			 userb.quizAnswer = [responseObject objectForKey:@"quizAnswer"];
		 }
		 
		 if( [responseObject objectForKey:@"quizId"]==(NSString *)[NSNull null]){
			 userb.quizId =@"";
		 }
		 else{
			 userb.quizId = [responseObject objectForKey:@"quizId"];
		 }
		 
		 if( [responseObject objectForKey:@"receiveRoYN"]==(NSString *)[NSNull null]){
			 userb.receiveRoYN =@"";
		 }
		 else{
			 userb.receiveRoYN = [responseObject objectForKey:@"receiveRoYN"];
		 }
		 
		 if( [responseObject objectForKey:@"regDate"]==(NSString *)[NSNull null]){
			 userb.regDate =@"";
		 }
		 else{
			 userb.regDate = [[responseObject objectForKey:@"regDate"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"updDate"]==(NSString *)[NSNull null]){
			 userb.updDate =@"";
		 }
		 else{
			 userb.updDate = [[responseObject objectForKey:@"updDate"]stringValue];
		 }

		 if( [responseObject objectForKey:@"status"]==(NSString *)[NSNull null]){
			 userb.status =@"";
		 }
		 else{
			 userb.status = [responseObject objectForKey:@"status"];
		 }
		 
		 if( [responseObject objectForKey:@"telcoId"]==(NSString *)[NSNull null]){
			 userb.telcoId =@"";
		 }
		 else{
			 userb.telcoId = [[responseObject objectForKey:@"telcoId"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"userId"]==(NSString *)[NSNull null]){
			 userb.userId =@"";
		 }
		 else{
			  userb.userId = [[responseObject objectForKey:@"userId"]stringValue];
		 }
		 
		 if( [responseObject objectForKey:@"userType"]==(NSString *)[NSNull null]){
			 userb.userType =@"";
		 }
		 else{
			 userb.userType = [responseObject objectForKey:@"userType"];
		 }
		 
		 if( [responseObject objectForKey:@"speedyId"]==(NSString *)[NSNull null]){
			 userb.speedyId =@"";
		 }
		 else{
			 userb.speedyId = [responseObject objectForKey:@"speedyId"];
		 }
		 
		 if( [responseObject objectForKey:@"webPassword"]==(NSString *)[NSNull null]){
			 userb.webPassword = @"";
		 }
		 else{
			 userb.webPassword = passWord;
		 }
		 
         
         
		 [localContext MR_save];
		 
		 [loginContainer setHidden:YES];
		 [MelonListLeft setHidden:NO];
		 NSMutableArray *dataPass=[[NSMutableArray alloc]init];
		 [dataPass addObject:@"mokletdevViewController"];
		 [[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		 //[self.sidePanelController showCenterPanel:NO];
		 [dataPass removeAllObjects];
		 [dataPass release];
		
         mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
		 [appDelegate ambilLayanan:userb.userId];
		 
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error while request on login: %@", error);
		 NSLog(@"Error respons: %@", [[[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding] autorelease]);
         
         [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nill)
                                      message:NSLocalizedString(@"Login Failed Message", nil)
                                     delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil] autorelease] show];
     }];
    
    //[operation start];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    [httpClient release];

    
	
}

- (BOOL) usernameFieldShouldReturn: (UITextField *) textField
{
    if ([textField.text isEqualToString:@""])
    {
        return NO;
		NSLog(@"usernameFieldShouldReturn NO");
    }
    
    [inputUsername resignFirstResponder];
    [inputPassword becomeFirstResponder];
    return NO;
}

- (BOOL) passwordFieldShouldReturn: (UITextField *) textField
{
    if ([textField.text isEqualToString:@""])
    {
		NSLog(@"passwordFieldShouldReturn NO");
        return NO;
    }
    
    [inputPassword resignFirstResponder];
    return NO;
}
/*
 
 */
//#pragma -

-(void)viewWillAppear:(BOOL)animated{
	[self checkLogin];
	
}
-(void)viewDidAppear:(BOOL)animated{
	NSLog(@"dipanggil di kiri-->2");
	
}
-(void)checkLogin{
	NSLog(@"cek login--->");
	/////he kon iku sakjane wes onok user e gak sih?
	_users = [NSMutableArray arrayWithArray:[EUserBrief MR_findAllSortedBy:@"userId" ascending:YES]];
    //mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
    
	if([_users count]>0){
		NSLog(@"_users count--->%d",[_users count]);
		for(int i=0; i<[_users count];i++){
			EUserBrief *usersss=[_users objectAtIndex:0];
			NSLog(@"usersss---->%@",usersss.userId);
		}
		EUserBrief *usersss=[_users objectAtIndex:0];
		NSLog(@"usersss---->%@",usersss);
		self.user_active=usersss.userId;
		[user_active_now setText:[NSString stringWithFormat:@"%@",usersss.username]];
		loginContainer.hidden = YES;
		MelonListLeft.hidden = NO;
	/////whyyyyyyy neeeed to relogin??????????!!!!!
        /*
        appDelegate.eUserId = usersss.userId;
        appDelegate.ePassword = usersss.ePassword;
        appDelegate.eWebPassword = usersss.webPassword;
        appDelegate.eUserName = usersss.username;
                
        // loginkan ke server
        [self tryToLogin:appDelegate.eUserName withPassword:appDelegate.ePassword];
		*/
	}
	else{
		loginContainer.hidden = NO;
		MelonListLeft.hidden = YES;
		mokletdevAppDelegate *appDelegate =(mokletdevAppDelegate*) [[UIApplication sharedApplication]delegate];
		if (!appDelegate.session.isOpen) {
			// create a fresh session object
			NSLog(@"!appDelegate.session.isOpen");
			NSArray *permissions = [[NSArray alloc] initWithObjects:
									@"email",
									nil];
			appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
			
			// if we don't have a cached token, a call to open here would cause UX for login to
			// occur; we don't want that to happen unless the user clicks the login button, and so
			// we check here to make sure we have a token before calling open
			if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
				// even though we had a cached token, we need to login to make the session usable
				NSLog(@"FBSessionStateCreatedTokenLoaded");
				[appDelegate.session openWithCompletionHandler:^(FBSession *session,
																 FBSessionState status,
																 NSError *error) {
					// we recurse here, in order to update buttons and labels
					//[self updateView];
				}];
			}
		}

	}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSDictionary *dTmp= [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftWindow" ofType:@"plist"]] autorelease];
	self.arrayOriginal=[dTmp valueForKey:@"Object"];
	
	self.arForTable=[[NSMutableArray alloc] init];
	[self.arForTable addObjectsFromArray:self.arrayOriginal];
	
    //open left menu
	[self openAllMenu];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arForTable count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    headerView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"header_view"]];
	
	UIView *border_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320,2)];
	border_bottom.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	[headerView addSubview:border_bottom];
    [headerView addSubview:user_active_now];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    mokletdevLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
	    cell=[[[mokletdevLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell...
	NSString *cellValue = [[self.arForTable objectAtIndex:indexPath.row]objectForKey:@"name"];
	cell.contentRight.text=cellValue;
    NSString * myTag;
    myTag = [[self.arForTable objectAtIndex:indexPath.row] objectForKey:@"tag"];
    switch ([myTag intValue]) {
        case 11:
        case 12:
        case 13:
        case 21:
        case 22:
            cell.contentRight.frame = CGRectMake(40.0, 10.0, 200.0, 20.0);
            break;
            
        default:
            break;
    }
	//[self jumper:cellValue];
	//[cell.contentRightImage setImage:[UIImage imageNamed:cellValue]];
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor =[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
    cell.selectedBackgroundView = selectionColor;
	
	
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString *cellValue = [[self.arForTable objectAtIndex:indexPath.row]objectForKey:@"name"];
	 mokletdevAppDelegate * appDelegate = (mokletdevAppDelegate *) [[UIApplication sharedApplication] delegate];
	[self jumper:cellValue];
    
    if ([cellValue isEqualToString:@"Logout"])
    { 
		[appDelegate.session closeAndClearTokenInformation];
		NSLog(@"Logged out of facebook");
		NSHTTPCookie *cookie;
		NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		for (cookie in [storage cookies])
		{
			NSString* domainName = [cookie domain];
			NSRange domainRange = [domainName rangeOfString:@"facebook"];
			if(domainRange.length > 0)
			{
				[storage deleteCookie:cookie];
			}
		}
		
	
		[[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
        @try {
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            //[LocalPlaylist MR_truncateAll];
            [LocalPlaylist1 MR_truncateAll];
            [EUserBrief MR_truncateAllInContext:localContext];
            [Layanan MR_truncateAllInContext:localContext];
            [DownloadList MR_truncateAllInContext:localContext];
            [self.inputUsername setText:@""];
            [self.inputPassword setText:@""];
            [localContext MR_saveNestedContexts];
        }
        @catch (NSException *exception) {
            NSLog(@"error here while configuring data for logout.");
        }
        
        // xic
        @try {
            [appDelegate.nowPlayingPlaylistDefault removeAllObjects];
            [appDelegate.nowPlayingPlayOrder removeAllObjects];
            appDelegate.nowPlayingPlayOrderIndex = -1;
            appDelegate.nowPlayingSongIndex = -1;
            appDelegate.eUserName = @"";
            appDelegate.eUserId = @"";
            appDelegate.ePassword = @"";
            appDelegate.eWebPassword = @"";
        }
        @catch (NSException *exception) {
            NSLog(@"error here while emptying list.");
        }
	
		MelonListLeft.hidden = YES;
		loginContainer.hidden = NO;
	
		NSMutableArray *dataPass=[[NSMutableArray alloc]init];
		[dataPass addObject:@"mokletdevViewController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		self.user_active=@"";
		
		
		
    }
	//[self jumper:cell.textLabel.text];
	NSDictionary *d=[self.arForTable objectAtIndex:indexPath.row];
	
	
	if([d valueForKey:@"Object"]) {
		NSArray *ar=[d valueForKey:@"Object"];
		
		BOOL isAlreadyInserted=NO;
		
		for(NSDictionary *dInner in ar ){
			NSInteger index=[self.arForTable indexOfObjectIdenticalTo:dInner];
			
			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
			if(isAlreadyInserted) break;
			
			
		}
		
		if(isAlreadyInserted) {
			[self miniMizeThisRows:ar];
		} else {
			NSLog(@"123");
			NSUInteger count=indexPath.row+1;
			NSMutableArray *arCells=[NSMutableArray array];
			for(NSDictionary *dInner in ar ) {
				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
				
				[self.arForTable insertObject:dInner atIndex:count++];
				
			}
			[tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
			tableView.tag=[arCells objectAtIndex:0];
			
			
		}
	}
	
	
	
}

-(void)openAllMenu{
    NSLog(@"OPEN ALL MENU");
    
    for(int i=0; i < [self.arForTable count];i++) {
        NSDictionary *d=[self.arForTable objectAtIndex:i];
        
        
        if([d valueForKey:@"Object"]) {
            NSArray *ar=[d valueForKey:@"Object"];
            
            BOOL isAlreadyInserted=NO;
            
            for(NSDictionary *dInner in ar ){
                NSInteger index=[self.arForTable indexOfObjectIdenticalTo:dInner];
                
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
                
                
            }
            
            if(isAlreadyInserted) {
                [self miniMizeThisRows:ar];
            } else {
                NSLog(@"123");
                NSUInteger count=i+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    
                    [self.arForTable insertObject:dInner atIndex:count++];
                    
                }
                [MelonListLeft insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                MelonListLeft.tag=[arCells objectAtIndex:0];
                
                
            }
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
	NSLog(@"ar-->%@",ar);
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.arForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"Objects"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.arForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.arForTable removeObjectIdenticalTo:dInner];
			[MelonListLeft deleteRowsAtIndexPaths:[NSArray arrayWithObject:
												   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
												   ]
								 withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}
-(void)jumper:(NSString *)sender{
	//NSString *notificationName = @"MTPostNotificationTut";
    //NSString *key=sender;
	
	NSMutableArray *dataPass=[[NSMutableArray alloc]init];
	
	
	if([sender isEqualToString:NSLocalizedString(@"Service List", nil)])
	{
		[dataPass addObject:@"mokletdevServiceController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		NSLog(@"1");
	}
	
    else if([sender isEqualToString:NSLocalizedString(@"Download History", nil)])
	{
		[dataPass addObject:@"mokletdevHistoryController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		NSLog(@"2");
	}
	
    else if([sender isEqualToString:NSLocalizedString(@"Download Queue",nil)])
	{
		[dataPass addObject:@"downloadQueueViewController"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		NSLog(@"3");
	}
	
    else if([sender isEqualToString:NSLocalizedString(@"Playlist",nil)])
	{
		[dataPass addObject:@"mokletdevPlayList"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		NSLog(@"4");
	}
	
    else if([sender isEqualToString:NSLocalizedString(@"All Song",nil)])
	{
		[dataPass addObject:@"mokletdevAllSong"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object:dataPass];
		
		[self.sidePanelController showCenterPanel:YES];
		[dataPass removeAllObjects];
		[dataPass release];
		NSLog(@"5");
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
	NSLog(@"123 viewWillDisappear");
	[self didReceiveMemoryWarning];
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

- (void) addDownloadList:(songListObject *)song
{
    
}

@end
