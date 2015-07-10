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

@end
