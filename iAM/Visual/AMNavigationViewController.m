//
//  AMNavigationViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 28.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//


#import "AMRevealViewUtils.h"
#import "AMNavigationViewController.h"

@interface AMNavigationViewController ()

@end

@implementation AMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSidebarMenu];
    [self loadIcons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadSidebarMenu {
    SWRevealViewController *revealController = [self revealViewController];
    [AMRevealViewUtils initRevealController:revealController
                            withRightButton:nil
                              andLeftButton:_sideMenuButton];
}

- (void)loadIcons {
    UIBarButtonItem *originalLeftButton = _navigationBarItem.leftBarButtonItem;
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = [[UIView appearance] tintColor];
    face.bounds = CGRectMake(26, 26, 26, 26);
    [face setImage:[[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
          forState:UIControlStateNormal];
    [face addTarget:originalLeftButton.target
             action:originalLeftButton.action
   forControlEvents:UIControlEventTouchDown];
    _navigationBarItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:face];
}

@end
