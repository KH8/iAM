//
//  AMPageContentViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 23.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMPageContentViewController.h"

@interface AMPageContentViewController ()

@end

@implementation AMPageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImageView.image = [UIImage imageNamed:_imageFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
