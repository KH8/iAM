//
//  AMAppearanceManager.m
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMAppearanceManager.h"
#import "AMVolumeSlider.h"
#import "AMApplicationDelegate.h"
#import "AppDelegate.h"
#import "CDAppearance.h"

@interface AMAppearanceManager ()

@property(nonatomic) NSString *globalTintColorKey;
@property(nonatomic) NSString *globalColorThemeKey;

@property(nonatomic) NSDictionary *tintColors;
@property(nonatomic) NSDictionary *colorThemes;

@property(nonatomic) NSArray *tintColorsArray;
@property(nonatomic) NSArray *colorThemesArray;

@property(nonatomic) BOOL showTutorial;

@end

@implementation AMAppearanceManager

- (id)init {
    self = [super init];
    if (self) {
        [self initDictionaries];
        _globalTintColorKey = @"";
        _globalColorThemeKey = @"";
    }
    return self;
}

- (void)initDictionaries {
    _tintColors = @{@"ORANGE" : [UIColor orangeColor],
            @"YELLOW" : [UIColor yellowColor],
            @"GREEN" : [UIColor greenColor],
            @"CYAN" : [UIColor cyanColor],
            @"BLUE" : [UIColor blueColor],
            @"PURPLE" : [UIColor purpleColor],
            @"MAGENTA" : [UIColor magentaColor],
            @"RED" : [UIColor redColor],
            @"BROWN" : [UIColor brownColor],
            @"WHITE" : [UIColor whiteColor],
            @"GRAY" : [UIColor grayColor],
            @"BLACK" : [UIColor blackColor],
    };
    _tintColorsArray = [_tintColors allKeys];
    _colorThemes = @{@"DARK" : [UIColor blackColor],
            @"LIGHT" : [UIColor whiteColor],
            @"GRAPHITE" : [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f],
    };
    _colorThemesArray = [_colorThemes allKeys];
}

- (void)initAppearanceCoreDataEntitiesInContext:(NSManagedObjectContext *)context {
    CDAppearance *appearance = [NSEntityDescription insertNewObjectForEntityForName:@"CDAppearance"
                                                             inManagedObjectContext:context];
    appearance.tintColorKey = @"ORANGE";
    appearance.colorThemeKey = @"DARK";
    appearance.showTutorial = @YES;

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)loadContext {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[appDelegate configurationManager] managedObjectContext];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDAppearance"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        [self clearContext];
        [self initAppearanceCoreDataEntitiesInContext:context];
        fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    }
    CDAppearance *appearance = fetchedObjects[0];

    _globalTintColorKey = appearance.tintColorKey;
    _globalColorThemeKey = appearance.colorThemeKey;
    _showTutorial = appearance.showTutorial.boolValue;

    [self setupAppearanceOnce];
}

- (void)saveContext {
    [self clearContext];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[appDelegate configurationManager] managedObjectContext];
    CDAppearance *appearance = [NSEntityDescription insertNewObjectForEntityForName:@"CDAppearance"
                                                             inManagedObjectContext:context];
    appearance.tintColorKey = _globalTintColorKey;
    appearance.colorThemeKey = _globalColorThemeKey;
    appearance.showTutorial = [[NSNumber alloc] initWithBool:_showTutorial];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)clearContextWithEntity:(NSString *)entityString {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[appDelegate configurationManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityString inManagedObjectContext:context]];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    for (id entity in result)
        [context deleteObject:entity];
}

- (void)clearContext {
    [self clearContextWithEntity:@"CDAppearance"];
}

- (void)changeGlobalTintColor {
    NSInteger actualIndex = [self getIndexOfAKey:_globalTintColorKey
                                    inDictionary:_tintColors];
    actualIndex++;
    if (actualIndex > _tintColors.count - 1) {
        actualIndex = 0;
    }

    id key = _tintColorsArray[(NSUInteger) actualIndex];
    _globalTintColorKey = key;
}

- (NSInteger)getIndexOfAKey:(NSString *)key
               inDictionary:(NSDictionary *)dictionary {
    NSInteger i = 0;
    for (NSString *particularKey in [dictionary allKeys]) {
        if (key == particularKey) {
            return i;
        }
        i++;
    }
    return -1;
}

- (UIColor *)getGlobalTintColor{
    return _tintColors[_globalTintColorKey];
}

- (NSString *)getGlobalTintColorKey {
    return _globalTintColorKey;
}

- (void)changeGlobalColorTheme {
    NSInteger actualIndex = [self getIndexOfAKey:_globalColorThemeKey
                                    inDictionary:_colorThemes];
    actualIndex++;
    if (actualIndex > _colorThemes.count - 1) {
        actualIndex = 0;
    }

    id key = _colorThemesArray[(NSUInteger) actualIndex];
    _globalColorThemeKey = key;
}

- (UIColor *)getGlobalColorTheme{
    return _colorThemes[_globalColorThemeKey];
}

- (NSString *)getGlobalColorThemeKey {
    return _globalColorThemeKey;
}

- (void)setShowTutorial:(BOOL)value {
    _showTutorial = value;
}

- (BOOL)getShowTutorial {
    return _showTutorial;
}

- (void)setupAppearanceOnce {
    UIImage *minImage = [[UIImage imageNamed:@"speakerCalm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *maxImage = [[UIImage imageNamed:@"speakerLoud.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [[AMVolumeSlider appearance] setMinimumValueImage:minImage];
    [[AMVolumeSlider appearance] setMaximumValueImage:maxImage];
}

+ (UIColor *)getGlobalTintColor {
    return [[[AMApplicationDelegate getAppDelegate] appearanceManager] getGlobalTintColor];
}

+ (UIColor *)getGlobalColorTheme {
    return [[[AMApplicationDelegate getAppDelegate] appearanceManager] getGlobalColorTheme];
}

+ (BOOL)getShowTutorial {
    return [[[AMApplicationDelegate getAppDelegate] appearanceManager] getShowTutorial];
}

@end
