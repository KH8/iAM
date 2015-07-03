//
//  AMPanSlider.m
//  iAM
//
//  Created by Krzysztof Reczek on 03.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMPanSlider.h"

@implementation AMPanSlider

+ (void)initAppearance {
    UIImage *leftImage = [[UIImage imageNamed:@"left.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *rightImage = [[UIImage imageNamed:@"right.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [[AMPanSlider appearance] setMinimumValueImage:leftImage];
    [[AMPanSlider appearance] setMaximumValueImage:rightImage];
}

@end
