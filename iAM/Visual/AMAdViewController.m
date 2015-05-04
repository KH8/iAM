//
//  AMAdViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 04.05.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAdViewController.h"

@interface AMAdViewController ()
{
    BOOL _bannerIsVisible;
    BOOL _swipeEnabled;
    ADBannerView *_adBannerTop;
}

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation AMAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackground];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initAd];
}

- (void)initBackground {
    [NSThread detachNewThreadSelector:@selector(runBackground) toTarget:self withObject:nil];
}

- (void)runBackground{
    _swipeEnabled = NO;
    int i = 10;
    
    while (!_swipeEnabled) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _timerLabel.text = [NSString stringWithFormat:@"Wait %d seconds.", i];
        });
        
        [NSThread sleepForTimeInterval:1.0F];
        i--;
        
        if(i<0){
            _timerLabel.text = @"Swipe to continue.";
            _swipeEnabled = YES;
        }
    }
}

- (void)initAd {
    _adBannerTop = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    _adBannerTop.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)swipedToTheRight:(id)sender {
    if(_swipeEnabled){
        [self performSegueWithIdentifier: @"sw_skip" sender: self];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_bannerIsVisible) {
        if (_adBannerTop.superview == nil) {
            [self.view addSubview:_adBannerTop];
        }
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, 0);
        [UIView commitAnimations];
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (_bannerIsVisible) {
        NSLog(@"Failed to retrieve ad");
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
}

@end
