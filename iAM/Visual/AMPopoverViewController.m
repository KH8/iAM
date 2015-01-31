//
//  AMPopoverViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 31.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPopoverViewController.h"

@interface AMPopoverViewController ()

@end

@implementation AMPopoverViewController

- (void)viewDidLoad {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)gesturePerformed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion: nil];
}

@end
