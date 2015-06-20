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

@interface AMTrackConfiguration() {
}

@property(weak, nonatomic) UILabel *soundLabel;
@property(weak, nonatomic) AMVolumeSlider *slider;
@property(weak, nonatomic) UIButton *soundButton;
@property(weak, nonatomic) AMPlayer *player;
@property(weak, nonatomic) UIViewController *controller;
@property(weak, nonatomic) NSString *segueName;
@property(weak, nonatomic) NSString *popupSegueName;



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
        _soundLabel = soundLabel;
        _soundButton = soundButton;
        _slider = trackSlider;
        _player = player;
        _segueName = segueName;
        _popupSegueName = popupSegueName;
    }
    return self;
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
    _slider.value = [[_player getGeneralVolumeFactor] floatValue];
}

- (void)loadButton {
    [_soundButton targetForAction:@selector(assignSoundToTrack)
                       withSender:self];
}

- (void)assignSoundToTrack {
    NSString *segue = _popupSegueName;
    if ([AMConfig isSoundChangeAllowed]) {
        segue = _segueName;
    }
    [_controller performSegueWithIdentifier:segue
                                     sender:_controller];
}

@end
