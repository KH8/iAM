//
//  AMAboutViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 21.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAboutViewController.h"
#import "AMConfig.h"

@interface AMAboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

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

- (void)loadText{
    _descriptionText.text = [AMConfig appDescription];
    _descriptionText.textAlignment = NSTextAlignmentCenter;
    [_descriptionText sizeToFit];
}

- (void)loadColors{
    [_descriptionText setTextColor:[[UIView appearance] tintColor]];
}

@end
