//
//  AMVisualEffectView.m
//  iAM
//
//  Created by Krzysztof Reczek on 19.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMVisualEffectView.h"
#import "AMAppearanceManager.h"

@implementation AMVisualEffectView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[AMAppearanceManager getGlobalColorTheme]];
}

@end
