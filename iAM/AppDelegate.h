//
//  AppDelegate.h
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMConfigurationManager.h"
#import "AMAppearanceManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong, nonatomic) AMConfigurationManager *configurationManager;
@property(readonly, strong, nonatomic) AMAppearanceManager *appearanceManager;

@end

