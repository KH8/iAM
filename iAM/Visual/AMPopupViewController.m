//
//  AMPopupViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 21.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPopupViewController.h"
#import "AMPopupAnimator.h"
#import "AMConfig.h"

@interface AMPopupViewController ()

@property(nonatomic) NSString *text;
@property(weak, nonatomic) IBOutlet UITextView *textView;
@property(weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation AMPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadText];
    [self loadColors];
    [self loadIcon];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)loadText {
    _textView.text = _text;
    _textView.textAlignment = NSTextAlignmentCenter;
    [_textView sizeToFit];
}

- (void)loadColors {
    [_textView setTextColor:[UIColor lightGrayColor]];
}

- (void)loadIcon {
    if (![AMConfig shouldAdBeDisplayed]) {
        [_icon setUserInteractionEnabled:NO];
        [_icon setAlpha:0.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setText:(NSString *)text {
    _text = text;
}

- (IBAction)buttonTapped:(id)sender {
    NSString *appStoreLink = @"itms-apps://itunes.apple.com/us/app/tickgrid/id991810160?l=pl&ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
}

@end
