//
//  AMVolumeSlider.m
//  iAM
//
//  Created by Krzysztof Reczek on 09.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMVolumeSlider.h"

@implementation AMVolumeSlider

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds {
    CGRect r = [super maximumValueImageRectForBounds:bounds];
    r.size.height = 30;
    r.size.width = 30;
    r.origin.x += 90;
    r.origin.y += 46;
    return r;
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds {
    CGRect r = [super minimumValueImageRectForBounds:bounds];
    r.size.height = 30;
    r.size.width = 30;
    r.origin.x += 0;
    r.origin.y += 46;
    return r;
}

+ (void)initAppearance {
    UIImage *minImage = [[UIImage imageNamed:@"speakerCalm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *maxImage = [[UIImage imageNamed:@"speakerLoud.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [[AMVolumeSlider appearance] setMinimumValueImage:minImage];
    [[AMVolumeSlider appearance] setMaximumValueImage:maxImage];
}

@end
