//
//  AMAboutViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 21.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAboutViewController.h"
#import "AMAppearanceManager.h"
#import "AMConfig.h"
#import "AMView.h"

@interface AMAboutViewController ()

@property(weak, nonatomic) IBOutlet UITextView *descriptionText;
@property(weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation AMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadText];
    [self loadColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
}

- (IBAction)facebookTapped:(id)sender {
    NSString *facebookLink = @"https://m.facebook.com/tickgrid";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookLink]];
}

- (IBAction)appStoreTapped:(id)sender {
    NSString *appStoreLink = @"itms-apps://itunes.apple.com/us/app/tickgrid/id991810160?l=pl&ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
}

@end
