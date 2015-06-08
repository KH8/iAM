//
//  AMAppearanceManager.h
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AMAppearanceManager : NSObject

- (id)init;

- (void)loadContext;

- (void)saveContext;

- (void)clearContext;

- (void)changeGlobalTintColor;

- (UIColor *)getGlobalTintColor;

- (NSString *)getGlobalTintColorKey;

- (void)changeGlobalColorTheme;

- (UIColor *)getGlobalColorTheme;

- (NSString *)getGlobalColorThemeKey;

- (void)setShowTutorial:(BOOL)value;

- (BOOL)getShowTutorial;

+ (UIColor *)getGlobalTintColor;

+ (UIColor *)getGlobalColorTheme;

+ (BOOL)getShowTutorial;

@end
