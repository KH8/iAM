//
//  AMAppearanceManager.m
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMAppearanceManager.h"
#import "AMApplicationDelegate.h"
#import "AMVolumeSlider.h"
#import "AMPanSlider.h"
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
            @"YELLOW" : [UIColor colorWithRed:0.94f green:0.77f blue:0.06f alpha:1.0f],
            @"GREEN" : [UIColor colorWithRed:0.30f green:0.75f blue:0.34f alpha:1.0f],
            @"CYAN" : [UIColor colorWithRed:0.0f green:0.71f blue:0.71f alpha:1.0f],
            @"BLUE" : [UIColor colorWithRed:0.16f green:0.50f blue:0.72f alpha:1.0f],
            @"PURPLE" : [UIColor colorWithRed:0.56f green:0.27f blue:0.68f alpha:1.0f],
            @"MAGENTA" : [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.0f],
            @"RED" : [UIColor colorWithRed:0.75f green:0.22f blue:0.17f alpha:1.0f],
            @"BROWN" : [UIColor colorWithRed:0.27f green:0.21f blue:0.18f alpha:1.0f],
            @"WHITE" : [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.0f],
            @"GRAY" : [UIColor colorWithRed:0.58f green:0.65f blue:0.65f alpha:1.0f],
            @"BLACK" : [UIColor colorWithRed:0.02f green:0.02f blue:0.02f alpha:1.0f],
    };
    _tintColorsArray = [_tintColors allKeys];
    _colorThemes = @{@"DARK" : [UIColor blackColor],
            @"LIGHT" : [UIColor whiteColor],
            @"GRAPHITE" : [UIColor colorWithRed:0.06f green:0.06f blue:0.06f alpha:1.0f],
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

- (UIColor *)getGlobalTintColor {
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

- (UIColor *)getGlobalColorTheme {
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
    [AMVolumeSlider initAppearance];
    [AMPanSlider initAppearance];
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
