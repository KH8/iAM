//
//  AMAboutViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 21.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAboutViewController.h"
#import "AMAppearanceManager.h"

@interface AMAboutViewController ()

@property(weak, nonatomic) IBOutlet UITextView *descriptionText;
@property(weak, nonatomic) IBOutlet UIImageView *logoView;
@property(weak, nonatomic) IBOutlet UIImageView *logoColoredView;
@property(weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation AMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLogo];
    [self loadText];
    [self loadColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadLogo {
    [_logoView setImage:[[UIImage imageNamed:@"logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [_logoColoredView setImage:[[UIImage imageNamed:@"logo_colored.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
}

- (void)loadText {
    _descriptionText.text = [AMConfig appDescription];
    _descriptionText.textAlignment = NSTextAlignmentCenter;
    [_descriptionText sizeToFit];
}

- (void)loadColors {
    [_descriptionText setTextColor:[UIColor lightGrayColor]];
    UIColor *globalColorTheme = [AMAppearanceManager getGlobalColorTheme];
    UIColor *globalTintColor = [AMAppearanceManager getGlobalTintColor];
    [_navigationBar setTintColor:globalTintColor];
    [_navigationBar setBarTintColor:globalColorTheme];
    [_logoColoredView setTintColor:globalTintColor];
}

@end
