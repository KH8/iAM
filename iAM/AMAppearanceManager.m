//
//  AMAppearanceManager.m
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMAppearanceManager.h"
#import "AMVolumeSlider.h"

@interface AMAppearanceManager ()

@property (nonatomic) UIColor *globalTintColor;
@property (nonatomic) NSInteger colorTheme;

@property (nonatomic, strong) NSHashTable *staveDelegates;

@end

@implementation AMAppearanceManager

- (id)init {
    self = [super init];
    if (self) {
        _globalTintColor = [UIColor orangeColor];
        _colorTheme = 1;
    }
    return self;
}

- (void)loadContext{
    [self setupAppearance];
}

- (void)saveContext{
    
}

- (void)clearContext{
    
}

- (void)setGlobalTintColor:(UIColor*)color{
    _globalTintColor = color;
}

- (void)setGlobalColorTheme:(NSInteger)colorTheme{
    _colorTheme = colorTheme;
}

- (void)setupAppearance {
    UIImage *minImage = [[UIImage imageNamed:@"speakerCalm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *maxImage = [[UIImage imageNamed:@"speakerLoud.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [[AMVolumeSlider appearance] setMinimumValueImage:minImage];
    [[AMVolumeSlider appearance] setMaximumValueImage:maxImage];
    
    UIColor *globalColor = _globalTintColor;
    
    [[UIView appearance] setTintColor:globalColor];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:globalColor];
}

@end
