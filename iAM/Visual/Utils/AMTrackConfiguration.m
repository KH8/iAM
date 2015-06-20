//
//  AMTrackConfiguration.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMTrackConfiguration.h"
#import "AMAppearanceManager.h"

@interface AMTrackConfiguration() {
}

@property(weak, nonatomic) UILabel *soundLabel;
@property(weak, nonatomic) AMVolumeSlider *slider;
@property(weak, nonatomic) UIButton *soundButton;
@property(weak, nonatomic) AMPlayer *player;


@end

@implementation AMTrackConfiguration

- (id)initWithLabel:(UILabel *)soundLabel
             button:(UIButton *)soundButton
             slider:(AMVolumeSlider *)trackSlider
          andPlayer:(AMPlayer *)player {
    self = [super init];
    if (self) {
        _soundLabel = soundLabel;
        _soundButton = soundButton;
        _slider = trackSlider;
        _player = player;
    }
    return self;
}

- (void)loadColors {
    UIColor *tintColor = [AMAppearanceManager getGlobalTintColor];
    [_soundButton setTintColor:tintColor];
    [_slider setTintColor:tintColor];
}

- (void)loadLabels {
    _soundLabel.text = [_player getSoundKey];
}

- (void)loadSliders {
    _slider.value = [[_player getGeneralVolumeFactor] floatValue];
}

@end
