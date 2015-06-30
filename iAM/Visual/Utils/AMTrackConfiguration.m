//
//  AMTrackConfiguration.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMTrackConfiguration.h"
#import "AMAppearanceManager.h"
#import "AMConfig.h"

@interface AMTrackConfiguration () {
}

@property UILabel *soundLabel;
@property AMVolumeSlider *slider;
@property UIButton *soundButton;
@property AMPlayer *player;
@property UIViewController *controller;
@property NSString *segueName;
@property NSString *popupSegueName;
@property NSDate *date;

@end

@implementation AMTrackConfiguration

- (id)initWithLabel:(UILabel *)soundLabel
             button:(UIButton *)soundButton
             slider:(AMVolumeSlider *)trackSlider
             player:(AMPlayer *)player
     viewController:(UIViewController *)parent
     soundSegueName:(NSString *)segueName
     popupSegueName:(NSString *)popupSegueName {
    self = [super init];
    if (self) {
        _date = [NSDate date];
        _soundLabel = soundLabel;
        _soundButton = soundButton;
        _slider = trackSlider;
        _player = player;
        _controller = parent;
        _segueName = segueName;
        _popupSegueName = popupSegueName;
        [self refresh];
    }
    return self;
}

- (void)refresh {
    [self loadColor];
    [self loadLabel];
    [self loadSlider];
    [self loadButton];
}

- (void)loadColor {
    UIColor *tintColor = [AMAppearanceManager getGlobalTintColor];
    [_soundButton setTintColor:tintColor];
    [_slider setTintColor:tintColor];
}

- (void)loadLabel {
    _soundLabel.text = [_player getSoundKey];
}

- (void)loadSlider {
    _slider.value = [[_player getVolumeFactor] floatValue];
    [_slider addTarget:self
                action:@selector(sliderVolumeChanged)
      forControlEvents:UIControlEventValueChanged];
}

- (void)loadButton {
    [_soundButton addTarget:self
                     action:@selector(assignSoundToTrack)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)assignSoundToTrack {
    NSString *segue = _popupSegueName;
    if ([AMConfig isSoundChangeAllowed]) {
        segue = _segueName;
    }
    [_controller performSegueWithIdentifier:segue
                                     sender:_controller];
}

- (void)sliderVolumeChanged {
    [_player setVolumeFactor:[[NSNumber alloc] initWithFloat:_slider.value]];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeDifference = [currentTime timeIntervalSinceDate:_date];
    if (timeDifference > 0.8) {
        [_player playSound];
        _date = [NSDate date];
    }
}

@end
