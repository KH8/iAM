//
//  AMPopupViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 21.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPopupViewController.h"

@interface AMPopupViewController ()

@property (nonatomic) NSString *text;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AMPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadText];
    [self loadColors];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)loadText{
    _textView.text = _text;
    _textView.textAlignment = NSTextAlignmentCenter;
    [_textView sizeToFit];
}

- (void)loadColors{
    [_textView setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setText:(NSString*)text{
    _text = text;
}

- (IBAction)swipedDown:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
