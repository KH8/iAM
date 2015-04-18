//
//  AMConfirmationViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMConfirmationViewController.h"
#import "AppDelegate.h"

@interface AMConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AMConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadColors];
}

- (void)loadColors{
    [_textView setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)resetClicked:(id)sender {
    [self reset];
    [_delegate refreshView];
    [self closeView];
}

- (IBAction)cancelClicked:(id)sender {
    [self closeView];
}

- (void)reset{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate configurationManager] clearContext];
    [[appDelegate appearanceManager] clearContext];
    [[appDelegate configurationManager] loadContext];
    [[appDelegate appearanceManager] loadContext];
}

- (void)closeView{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
