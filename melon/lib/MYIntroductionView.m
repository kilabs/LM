//
//  MYIntroductionView.m
//  IntroductionExample
//
//  Copyright (C) 2013, Matt York
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "MYIntroductionView.h"
#import "mokletdevAppDelegate.h"

#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithWhite:0 alpha:0.9]
#define HEADER_VIEW_HEIGHT 50
#define PAGE_CONTROL_PADDING 2
#define TITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]
#define TITLE_TEXT_COLOR [UIColor whiteColor]
#define DESCRIPTION_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define DESCRIPTION_TEXT_COLOR [UIColor whiteColor]

@implementation MYIntroductionView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        [self buildUIWithFrame:frame headerViewVisible:YES];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = MYLanguageDirectionLeftToRight;
        [self buildUIWithFrame:frame headerViewVisible:YES];
        [self setHeaderText:headerText];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = MYLanguageDirectionLeftToRight;
        [self buildUIWithFrame:frame headerViewVisible:YES];
        [self setHeaderImage:headerImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels languageDirection:(MYLanguageDirection)languageDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = languageDirection;
        [self buildUIWithFrame:frame headerViewVisible:YES];
        [self setHeaderText:headerText];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels languageDirection:(MYLanguageDirection)languageDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = languageDirection;
        [self buildUIWithFrame:frame headerViewVisible:YES];
        [self setHeaderImage:headerImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = MYLanguageDirectionLeftToRight;
        [self buildUIWithFrame:frame headerViewVisible:NO];
        [self setHeaderText:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels languageDirection:(MYLanguageDirection)languageDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeClassVariables];
        Panels = [panels copy];
        LanguageDirection = languageDirection;
        [self buildUIWithFrame:frame headerViewVisible:NO];
        [self setHeaderText:nil];
    }
    return self;
}


-(void)initializeClassVariables{
    panelViews = [[NSMutableArray alloc] init];
}

#pragma mark - UI Builder Methods

-(void)buildUIWithFrame:(CGRect)frame headerViewVisible:(BOOL)headerViewVisible{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    [self buildBackgroundImage];
    [self buildHeaderViewWithFrame:frame visible:headerViewVisible];
    [self buildContentScrollViewWithFrame:frame];
    [self buildFooterView];
}

-(void)buildBackgroundImage{
    self.BackgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.BackgroundImageView.backgroundColor = [UIColor clearColor];
    self.BackgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.BackgroundImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.BackgroundImageView];
}

-(void)buildHeaderViewWithFrame:(CGRect)frame visible:(BOOL)visible{
    if (!visible) {
        self.HeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        return;
    }
    
    self.HeaderView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, HEADER_VIEW_HEIGHT)]; //Leave 5px padding on all sides
    self.HeaderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    self.HeaderView.backgroundColor = [UIColor clearColor];
    
    //Setup HeaderImageView
    self.HeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.HeaderView.frame.size.width, self.HeaderView.frame.size.height)];
    self.HeaderImageView.backgroundColor = [UIColor clearColor];
    self.HeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.HeaderView addSubview:self.HeaderImageView];
    self.HeaderImageView.hidden = YES;
    
    //Setup HeaderLabel
    self.HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.HeaderView.frame.size.width, self.HeaderView.frame.size.height)];
    self.HeaderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    self.HeaderLabel.textColor = [UIColor whiteColor];
    self.HeaderLabel.backgroundColor = [UIColor clearColor];
    self.HeaderLabel.textAlignment = NSTextAlignmentCenter;
    [self.HeaderView addSubview:self.HeaderLabel];
    self.HeaderLabel.hidden = YES;
    [self addSubview:self.HeaderView];
}

-(void)buildContentScrollViewWithFrame:(CGRect)frame{

    self.ContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.HeaderView.frame.origin.y + self.HeaderView.frame.size.height + 10, frame.size.width, 0)];
    self.ContentScrollView.pagingEnabled = YES;
    self.ContentScrollView.showsHorizontalScrollIndicator = NO;
    self.ContentScrollView.showsVerticalScrollIndicator = NO;
    self.ContentScrollView.delegate = self;
    

    
    //If panels exist, build views for them and add them to the ContentScrollView
    if (Panels) {
        if (Panels.count > 0) {
            
            if (LanguageDirection == MYLanguageDirectionLeftToRight) {
                [self buildContentScrollViewLeftToRight];
            }
            else if (LanguageDirection == MYLanguageDirectionRightToLeft) {
                [self buildContentScrollViewRightToLeft];
            }
        }
    }
}

-(void)buildContentScrollViewLeftToRight{
    //A running x-coordinate. This grows for every page
    CGFloat contentXIndex = 0;
    for (int ii = 0; ii < Panels.count; ii++) {
        
        //Create a new view for the panel and add it to the array
        [panelViews addObject:[self PanelViewForPanel:Panels[ii] atXIndex:&contentXIndex]];
        
        //Add the newly created panel view to ContentScrollView
        [self.ContentScrollView addSubview:panelViews[ii]];
    }
    
    
    [self makePanelVisibleAtIndex:0];
    
    //Dynamically sizes the content to fit the text content
    [self setContentScrollViewHeightForPanelIndex:0 animated:NO];
    
    //Add a view at the end. This is simply "something to scroll toward" on the final panel.
    [self appendCloseViewAtXIndex:&contentXIndex];
    
    //Finally, resize the content size of the scrollview to account for all the new views added to it
    self.ContentScrollView.contentSize = CGSizeMake(contentXIndex, self.ContentScrollView.frame.size.height);
    
    //Add the ContentScrollView to the introduction view
    [self addSubview:self.ContentScrollView];
    
    NSLog(@"buildContentScrollViewLeftToRight");
    
    //send to google analytics
    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
    
    [defaultTracker send:[[[GAIDictionaryBuilder createAppView]
                           set:NSLocalizedString(@"Screen Name Tutorial", nil) forKey:kGAIScreenName] build]];
}

-(void)buildContentScrollViewRightToLeft{
    //A running x-coordinate. This grows for every page
    CGFloat contentXIndex = 0;
    
    //Add a view at the end. This is simply "something to scroll toward" on the final panel.
    [self appendCloseViewAtXIndex:&contentXIndex];
    
    NSInteger panelViewIndex = 0;
    for (int ii = Panels.count-1; ii > -1; ii--) {
        
        //Create a new view for the panel and add it to the array
        [panelViews addObject:[self PanelViewForPanel:Panels[ii] atXIndex:&contentXIndex]];
        
        //Add the newly created panel view to ContentScrollView
        [self.ContentScrollView addSubview:panelViews[panelViewIndex]];
        panelViewIndex++;
    }
    
    
    [self makePanelVisibleAtIndex:panelViews.count-1];
    self.CurrentPanelIndex = panelViews.count-1;
    self.PageControl.currentPage = panelViews.count -1;
    
    //Dynamically sizes the content to fit the text content
    [self setContentScrollViewHeightForPanelIndex:Panels.count-1 animated:NO];
    
    //Finally, resize the content size of the scrollview to account for all the new views added to it
    self.ContentScrollView.contentSize = CGSizeMake(contentXIndex, self.ContentScrollView.frame.size.height);
    self.ContentScrollView.contentOffset = CGPointMake(contentXIndex-self.ContentScrollView.frame.size.width, 0);
    
    //Add the ContentScrollView to the introduction view
    [self addSubview:self.ContentScrollView];
    
    NSLog(@"buildContentScrollViewRightToLeft");
}

-(UIView *)PanelViewForPanel:(MYIntroductionPanel *)panel atXIndex:(CGFloat*)xIndex{
    
    //Build panel now that we have all the desired dimensions
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.ContentScrollView.frame.size.width, 0)];
    
    CGFloat imageHeight = MIN(panel.Image.size.height, self.frame.size.width - 10);
    
    //Build title container (if applicable)
    CGRect panelTitleLabelFrame;
    UILabel *panelTitleLabel;
    if (![panel.Title isEqualToString:@""]) {
        panelTitleLabelFrame = CGRectMake(10, imageHeight+5, self.ContentScrollView.frame.size.width - 20, [panel.Title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(self.ContentScrollView.frame.size.width - 20, 100) lineBreakMode:NSLineBreakByWordWrapping].height);
        panelTitleLabel = [[UILabel alloc] initWithFrame:panelTitleLabelFrame];
        panelTitleLabel.text = panel.Title;
        panelTitleLabel.font = TITLE_FONT;
        panelTitleLabel.textColor = TITLE_TEXT_COLOR;
        panelTitleLabel.backgroundColor = [UIColor clearColor];
        panelTitleLabel.textAlignment = NSTextAlignmentCenter;
        panelTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else {
        panelTitleLabelFrame = CGRectMake(10, imageHeight+5, self.ContentScrollView.frame.size.width - 20, 0);
        panelTitleLabel = [[UILabel alloc] initWithFrame:panelTitleLabelFrame];
    }
    [panelView addSubview:panelTitleLabel];
    
    //Build description container;
    UITextView *panelDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.ContentScrollView.frame.size.width, 10)];
    panelDescriptionTextView.scrollEnabled = NO;
    panelDescriptionTextView.backgroundColor = [UIColor clearColor];
    panelDescriptionTextView.textAlignment = NSTextAlignmentCenter;
    panelDescriptionTextView.textColor = DESCRIPTION_TEXT_COLOR;
    panelDescriptionTextView.font = DESCRIPTION_FONT;
    panelDescriptionTextView.text = panel.Description;
    panelDescriptionTextView.editable = NO;
    [panelView addSubview:panelDescriptionTextView];
    
    //Gather a few layout parameters
    
    //Get the maximum size the description text could be (screenHeight-panelParentContainerOrigin - footersize)
    CGFloat maxScrollViewHeight = self.frame.size.height - self.ContentScrollView.frame.origin.y - (36+PAGE_CONTROL_PADDING);
    
    
    NSInteger descriptionHeight = panelDescriptionTextView.contentSize.height;
    int contentWrappedScrollViewHeight = 0;
    if ((imageHeight + descriptionHeight + panelTitleLabelFrame.size.height) > maxScrollViewHeight) {
        contentWrappedScrollViewHeight = maxScrollViewHeight;
        imageHeight = contentWrappedScrollViewHeight-descriptionHeight - panelTitleLabelFrame.size.height - 10;
    }
    else if ((imageHeight+descriptionHeight + panelTitleLabelFrame.size.height) <= maxScrollViewHeight){
        contentWrappedScrollViewHeight = imageHeight + panelTitleLabelFrame.size.height + descriptionHeight;
    }

    panelView.frame = CGRectMake(*xIndex, 0, self.ContentScrollView.frame.size.width, contentWrappedScrollViewHeight);
    
    //Build image container
    UIImageView *panelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.ContentScrollView.frame.size.width - 10, imageHeight)];
    panelImageView.contentMode = UIViewContentModeScaleAspectFit;
    panelImageView.backgroundColor = [UIColor clearColor];
    panelImageView.image = panel.Image;
    panelImageView.layer.cornerRadius = 3;
    panelImageView.clipsToBounds = YES;
    [panelView addSubview:panelImageView];
    
    
    //Update frames based on the new/scaled image size we just gathered
    panelTitleLabel.frame = CGRectMake(10, imageHeight + 5, panelTitleLabel.frame.size.width, panelTitleLabel.frame.size.height);
    panelDescriptionTextView.frame = CGRectMake(0, imageHeight + panelTitleLabel.frame.size.height + 5, self.ContentScrollView.frame.size.width, descriptionHeight);
    
    //Update xIndex
    *xIndex += self.ContentScrollView.frame.size.width;
    
    return panelView;
}

-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.ContentScrollView addSubview:closeView];
    
     *xIndex += self.ContentScrollView.frame.size.width;
}

- (IBAction)changePage:(id)sender {
    UIPageControl *pager=sender;
    int page = pager.currentPage;
    CGRect frame = self.ContentScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.ContentScrollView scrollRectToVisible:frame animated:YES];
    
    [self makePanelVisibleAtIndex:(NSInteger)page];
    
    NSLog(@"Change Page %d",page);
    
}

-(void)buildFooterView{
    //Build Page Control
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - 185)/2, (self.ContentScrollView.frame.origin.y + self.ContentScrollView.frame.size.height + PAGE_CONTROL_PADDING), 185, 36)];
    self.PageControl.numberOfPages = Panels.count;
    [self.PageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.PageControl];
    
    //set page indicator color
    self.PageControl.pageIndicatorTintColor = [UIColor colorWithRed:(100.0/255) green:(100.0/255) blue:(100.0/255) alpha:1 ];
    self.PageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1 ];
    
    //Build Skip Button
    if (LanguageDirection == MYLanguageDirectionRightToLeft) {
        self.SkipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.PageControl.frame.origin.y, 80, self.PageControl.frame.size.height)];
        self.PageControl.currentPage = panelViews.count - 1;
    }
    else {
        self.SkipButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, self.PageControl.frame.origin.y, 80, self.PageControl.frame.size.height)];
    }
    
    [self.SkipButton setTitleColor: [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1 ] forState: UIControlStateNormal];
    [self.SkipButton setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [self.SkipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.SkipButton];
}

-(void)setContentScrollViewHeightForPanelIndex:(NSInteger)panelIndex animated:(BOOL)animated{
    CGFloat newPanelHeight = [panelViews[panelIndex] frame].size.height;
    
    if (animated){
        [UIView animateWithDuration:0.3 animations:^{
            self.ContentScrollView.frame = CGRectMake(self.ContentScrollView.frame.origin.x, self.ContentScrollView.frame.origin.y, self.ContentScrollView.frame.size.width, newPanelHeight);
            self.PageControl.frame = CGRectMake(self.PageControl.frame.origin.x, (self.ContentScrollView.frame.origin.y + self.ContentScrollView.frame.size.height + PAGE_CONTROL_PADDING), self.PageControl.frame.size.width, self.PageControl.frame.size.height);
            
            self.SkipButton.frame = CGRectMake(self.SkipButton.frame.origin.x, (self.ContentScrollView.frame.origin.y + self.ContentScrollView.frame.size.height + PAGE_CONTROL_PADDING), self.SkipButton.frame.size.width, self.SkipButton.frame.size.height);
        }];
    }
    else {
        self.ContentScrollView.frame = CGRectMake(self.ContentScrollView.frame.origin.x, self.ContentScrollView.frame.origin.y, self.ContentScrollView.frame.size.width, newPanelHeight);
        
        self.PageControl.frame = CGRectMake(self.PageControl.frame.origin.x, (self.ContentScrollView.frame.origin.y + self.ContentScrollView.frame.size.height + PAGE_CONTROL_PADDING), self.PageControl.frame.size.width, self.PageControl.frame.size.height);
        self.SkipButton.frame = CGRectMake(self.SkipButton.frame.origin.x, (self.ContentScrollView.frame.origin.y + self.ContentScrollView.frame.size.height + PAGE_CONTROL_PADDING), self.SkipButton.frame.size.width, self.SkipButton.frame.size.height);
        
    }
    
    self.ContentScrollView.contentSize = CGSizeMake(self.ContentScrollView.contentSize.width, newPanelHeight);
}

#pragma mark - Header Content

-(void)setHeaderText:(NSString *)headerText{
    self.HeaderLabel.hidden = NO;
    self.HeaderImageView.hidden = YES;
    self.HeaderLabel.text = headerText;
}

-(void)setHeaderImage:(UIImage *)headerImage {
    self.HeaderLabel.hidden = YES;
    self.HeaderImageView.hidden = NO;
    self.HeaderImageView.image = headerImage;
}

#pragma mark - Introduction Content

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.BackgroundImageView.image = backgroundImage;
}

#pragma mark - Show/Hide

-(void)showInView:(UIView *)view{
    //Add introduction view
    self.alpha = 0;
    [view addSubview:self];
    
    //Fade in
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}

-(void)makePanelVisibleAtIndex:(NSInteger)panelIndex{
    if (LanguageDirection == MYLanguageDirectionLeftToRight) {
        [UIView animateWithDuration:0.3 animations:^{
            for (int ii = 0; ii < panelViews.count; ii++) {
                if (ii == panelIndex) {
                    [panelViews[ii] setAlpha:1];
                }
                else {
                    [panelViews[ii] setAlpha:0];
                }
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            for (int ii = panelViews.count-1; ii > 0; ii--) {
                if (ii == panelIndex) {
                    [panelViews[ii] setAlpha:1];
                }
                else {
                    [panelViews[ii] setAlpha:0];
                }
            }
        }];
    }
}

-(void)skipIntroduction{
    if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
        [delegate introductionDidFinishWithType:MYFinishTypeSkipButton];
    }
    
    [self hideWithFadeOutDuration:0.3];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    if (LanguageDirection == MYLanguageDirectionLeftToRight) {
        self.CurrentPanelIndex = scrollView.contentOffset.x/self.ContentScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == (panelViews.count)) {
            if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
                [delegate introductionDidFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Format and show new content
            [self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
            [self makePanelVisibleAtIndex:(NSInteger)self.CurrentPanelIndex];
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
                    [delegate introductionDidChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
            }
        }
    }
    else if(LanguageDirection == MYLanguageDirectionRightToLeft){
        self.CurrentPanelIndex = (scrollView.contentOffset.x-320)/self.ContentScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == -1) {
            if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
                [delegate introductionDidFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Format and show new content
            [self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
            [self makePanelVisibleAtIndex:(NSInteger)self.CurrentPanelIndex];
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
                    [delegate introductionDidChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidScroll");
    if (LanguageDirection == MYLanguageDirectionLeftToRight) {
        if (self.CurrentPanelIndex == (panelViews.count - 1)) {
            self.alpha = ((self.ContentScrollView.frame.size.width*panelViews.count)-self.ContentScrollView.contentOffset.x)/self.ContentScrollView.frame.size.width;
        }
    }
    else if (LanguageDirection == MYLanguageDirectionRightToLeft){
        if (self.CurrentPanelIndex == 0) {
            self.alpha = self.ContentScrollView.contentOffset.x/self.ContentScrollView.frame.size.width;
        }
    }
}

@end
