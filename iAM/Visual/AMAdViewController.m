//
//  AMAdViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 04.05.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAdViewController.h"
#import "AMAppearanceManager.h"

@interface AMAdViewController () {
    BOOL _bannerIsVisible;
    BOOL _tapEnabled;
    ADBannerView *_adBannerTop;
}

@property(weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;

@end

@implementation AMAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackground];
    [self initTapRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initAd];
}

- (void)initBackground {
    [NSThread detachNewThreadSelector:@selector(runBackground) toTarget:self withObject:nil];
}

- (void)initTapRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    singleTap.numberOfTapsRequired = 1;
    [_adImage setUserInteractionEnabled:YES];
    [_adImage addGestureRecognizer:singleTap];
}

- (void)runBackground {
    _tapEnabled = NO;
    int i = 3;

    while (!_tapEnabled) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _timerLabel.text = [NSString stringWithFormat:@"Wait %d seconds.", i];
        });

        [NSThread sleepForTimeInterval:1.0F];
        i--;

        if (i < 0) {
            _timerLabel.text = @"Tap to continue.";
            _tapEnabled = YES;
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

- (IBAction)tapped:(id)sender {
    if (_tapEnabled) {
        [self performSegueWithIdentifier:@"sw_skip" sender:self];
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
