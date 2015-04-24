//
//  AMStartViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 23.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMStartViewController.h"
#import "AMPageContentViewController.h"

@interface AMStartViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation AMStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initComponents];
}

- (void)viewDidAppear:(BOOL)animated{
    //[self skipScreen];
}

- (void)initData{
    _pageImages = @[@"tutorial_1.png",
                    @"tutorial_2.png",
                    @"tutorial_3.png",
                    @"tutorial_4.png",
                    @"tutorial_5.png"];
}

- (void)initComponents{
    _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMPageViewController"];
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

@end
