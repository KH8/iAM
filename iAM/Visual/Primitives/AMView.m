//
//  AMView.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMView.h"
#import "AMAppearanceManager.h"

@implementation AMView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[AMAppearanceManager getGlobalColorTheme]];
}

@end
