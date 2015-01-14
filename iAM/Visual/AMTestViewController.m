//
// Created by Krzysztof Reczek on 14.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMTestViewController.h"
#import "AMPlayer.h"

@interface AMTestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property AMPlayer *player;

@end

@implementation AMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _player = [[AMPlayer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onTouchEvent:(id)sender {
    [_player playSound];
}

@end