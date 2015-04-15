//
//  AMAppearanceManager.m
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMAppearanceManager.h"
#import "AMVolumeSlider.h"
#import "AppDelegate.h"

@interface AMAppearanceManager ()

@property (nonatomic) NSString *globalTintColorKey;
@property (nonatomic) NSString *globalColorThemeKey;

@property (nonatomic) NSDictionary *tintColors;
@property (nonatomic) NSDictionary *colorThemes;

@property (nonatomic, strong) NSHashTable *staveDelegates;

@end

@implementation AMAppearanceManager

- (id)init {
    self = [super init];
    if (self) {
        [self initDictionaries];
        _globalTintColorKey = @"ORANGE";
        _globalColorThemeKey = @"DARK";
    }
    return self;
}

- (void)initDictionaries{
    _tintColors = @{ @"ORANGE" : [UIColor orangeColor],
                     @"YELLOW" : [UIColor yellowColor],
                     @"GREEN" : [UIColor greenColor],
                     @"CYAN" : [UIColor cyanColor],
                     @"BLUE" : [UIColor blueColor],
                     @"PURPLE" : [UIColor purpleColor],
                     @"MAGENTA" : [UIColor magentaColor],
                     @"RED" : [UIColor redColor],
                     @"BROWN" : [UIColor brownColor],
                     @"WHITE" : [UIColor whiteColor],
                     };
    _colorThemes = @{ @"DARK" : @1,
                      @"LIGHT" : @2,
                      };
}

- (void)loadContext{
    [self setupAppearance];
}

- (void)saveContext{
    
}

- (void)clearContext{
    
}

- (void)changeGlobalTintColor{
    NSInteger actualIndex = [self getIndexOfAKey:_globalTintColorKey
                                    inDictionary:_tintColors];
    actualIndex++;
    if(actualIndex > _tintColors.count - 1) {
        actualIndex = 0;
    }
    id key = [[_tintColors allKeys] objectAtIndex:actualIndex];
    _globalTintColorKey = key;
    [self setupAppearance];
}

- (NSInteger)getIndexOfAKey:(NSString*)key
               inDictionary:(NSDictionary*)dictionary{
    NSInteger i = 0;
    for (NSString *particularKey in [dictionary allKeys]) {
        if(key == particularKey){
            return i;
        }
        i++;
    }
    return -1;
}

- (NSString*)getGlobalTintColorKey{
    return _globalTintColorKey;
}

- (void)changeGlobalColorTheme{
    NSInteger actualIndex = [self getIndexOfAKey:_globalColorThemeKey
                                    inDictionary:_colorThemes];
    actualIndex++;
    if(actualIndex > _colorThemes.count - 1) {
        actualIndex = 0;
    }
    id key = [[_colorThemes allKeys] objectAtIndex:actualIndex];
    _globalColorThemeKey = key;
    [self setupAppearance];
}

- (NSString*)getGlobalColorThemeKey{
    return _globalColorThemeKey;
}

- (void)setupAppearance {
    UIImage *minImage = [[UIImage imageNamed:@"speakerCalm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *maxImage = [[UIImage imageNamed:@"speakerLoud.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [[AMVolumeSlider appearance] setMinimumValueImage:minImage];
    [[AMVolumeSlider appearance] setMaximumValueImage:maxImage];
    
    UIColor *globalColor = _tintColors[_globalTintColorKey];
    
    [[UIView appearance] setTintColor:globalColor];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:globalColor];
    [[UITextView appearance] setTextColor:globalColor];
}

@end
