//
//  AMStartViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 23.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMStartViewController.h"
#import "AMPageContentViewController.h"
#import "AppDelegate.h"

@interface AMStartViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISwitch *showTutorialSwitch;
@property (weak, nonatomic) IBOutlet UILabel *showTutorialLabel;

@property BOOL viewShouldBeSkipped;

@end

@implementation AMStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGlobalSettings];
    [self hideComponents];
}

- (void)viewDidAppear:(BOOL)animated{
    if(_viewShouldBeSkipped){
        [self skipScreen];
        return;
    }
    [_showTutorialSwitch setOn:YES];
    [self initData];
    [self initComponents];
}

- (void)initGlobalSettings{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _viewShouldBeSkipped = !appDelegate.appearanceManager.getShowTutorial;
}

- (void)initData{
    _pageImages = @[@"tutorial_0.png",
                    @"tutorial_1.png",
                    @"tutorial_2.png",
                    @"tutorial_3.png",
                    @"tutorial_4.png"];
}

- (void)initComponents{
    _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMPageViewController"];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    AMPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 100);
    [_pageViewController.view setBackgroundColor:[UIColor clearColor]];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:_pageControl];
    [self.view bringSubviewToFront:_showTutorialSwitch];
    [self.view bringSubviewToFront:_showTutorialLabel];
    [self.view bringSubviewToFront:_startButton];
}

- (void)skipScreen {
    [self performSegueWithIdentifier: @"sw_skip" sender: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonPressed:(id)sender {
    [self skipScreen];
}

- (IBAction)showTutorialSwitchStateChanged:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.appearanceManager setShowTutorial:_showTutorialSwitch.state];
}

- (AMPageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([_pageImages count] == 0) || (index >= [_pageImages count])) {
        return nil;
    }
    
    AMPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMPageContentViewController"];
    pageContentViewController.imageFile = _pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((AMPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((AMPageContentViewController*) viewController).pageIndex;
    
    if ((index == NSNotFound) || (index == [_pageImages count])) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    _pageControl.numberOfPages = [_pageImages count];
    return [_pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    AMPageContentViewController *pageContentViewController = (AMPageContentViewController*)pvc.viewControllers[0];
    _pageControl.currentPage = pageContentViewController.pageIndex;
    
    if(pageContentViewController.pageIndex != 4) {
        [self hideComponents];
        return;
    }
    [self showComponents];
}

- (IBAction)onPageSelectionHasChanged:(id)sender {
    AMPageContentViewController *pageContentViewController = (AMPageContentViewController*)_pageViewController.viewControllers[0];
    _pageControl.currentPage = pageContentViewController.pageIndex;
}

- (void)hideComponents{
    _showTutorialSwitch.userInteractionEnabled = NO;
    _showTutorialSwitch.alpha = 0;
    _showTutorialLabel.userInteractionEnabled = NO;
    _showTutorialLabel.alpha = 0;
    _startButton.userInteractionEnabled = NO;
    _startButton.alpha = 0;
}

- (void)showComponents{
    _showTutorialSwitch.userInteractionEnabled = YES;
    _showTutorialSwitch.alpha = 1;
    _showTutorialLabel.userInteractionEnabled = YES;
    _showTutorialLabel.alpha = 1;
    _startButton.userInteractionEnabled = YES;
    _startButton.alpha = 1;
}

@end
