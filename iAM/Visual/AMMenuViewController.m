//
//  AMMenuViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 19.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMMenuViewController.h"
#import "AMAppearanceManager.h"

@interface AMMenuViewController ()

@property(weak, nonatomic) IBOutlet UIButton *gridButton;
@property(weak, nonatomic) IBOutlet UIButton *listButton;
@property(weak, nonatomic) IBOutlet UIButton *propertiesButton;
@property(weak, nonatomic) IBOutlet UIButton *aboutButton;

@end

@implementation AMMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadTheme];
}

- (void)loadTheme {
    UIColor *globalTintColor = [AMAppearanceManager getGlobalTintColor];
    [_gridButton setTintColor:globalTintColor];
    [_listButton setTintColor:globalTintColor];
    [_propertiesButton setTintColor:globalTintColor];
    [_aboutButton setTintColor:globalTintColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
