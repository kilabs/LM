//
//  intro.m
//  melon
//
//  Created by Arie on 5/13/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "intro.h"
#import "mokletdevAppDelegate.h"
#import "PlayerConfig.h"
@interface intro ()

@end

@implementation intro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor=[UIColor blackColor];
        // Custom initialization
        
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
	//STEP 1 Construct Panels
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"t1"] description:@""];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"t2"] title:@"" description:@""];
	 MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"t3"] title:@"" description:@""];
	 MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"t4"] title:@"" description:@""];

	
    
    //STEP 2 Create IntroductionView
    
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    
    /*A version with no header (ala "Path")*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
    
    /*A more customized version*/
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"" panels:@[panel, panel2,panel3,panel4,] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"Default"]];
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
}
-(void)introductionDidFinishWithType:(MYFinishType)finishType{
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	NSArray * playerConfiguration = [PlayerConfig MR_findAll];
	PlayerConfig * playerConfig = [playerConfiguration objectAtIndex:0];
	if (finishType == MYFinishTypeSkipButton) {
       playerConfig.firstUse   = [NSNumber numberWithInt:0];
		[localContext MR_save];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];

    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];
		playerConfig.firstUse   = [NSNumber numberWithInt:0];
		[localContext MR_save];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];

    }
    
    //One might consider making the introductionview a class variable and releasing it here.
    // I didn't do this to keep things simple for the sake of example.
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //tracking google analytics
    self.screenName = NSLocalizedString(@"Screen Name Tutorial", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
