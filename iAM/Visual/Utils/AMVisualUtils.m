//
//  AMVisualUtils.m
//  iAM
//
//  Created by Krzysztof Reczek on 09.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMVisualUtils.h"
#import "AMAppearanceManager.h"

@implementation AMVisualUtils

+ (UIBarButtonItem *)createBarButton:(NSString *)pictureName
                              targer:(id)target
                            selector:(SEL)selector
                                size:(NSInteger)size {
    return [self createBarButton:pictureName
                          targer:target
                        selector:selector
                           color:[AMAppearanceManager getGlobalTintColor]
                            size:size];
}

+ (UIBarButtonItem *)createBarButton:(NSString *)pictureName
                              targer:(id)target
                            selector:(SEL)selector
                               color:(UIColor *)color
                                size:(NSInteger)size {
    UIImage *faceImage = [[UIImage imageNamed:pictureName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];

    face.tintColor = color;
    face.bounds = CGRectMake(size, size, size, size);
    [face setImage:faceImage
          forState:UIControlStateNormal];
    [face addTarget:target
             action:selector
   forControlEvents:UIControlEventTouchDown];

    return [[UIBarButtonItem alloc] initWithCustomView:face];
}

+ (UIBarButtonItem *)createBarButtonWithText:(NSString *)text
                                      targer:(id)target
                                    selector:(SEL)selector {
    return [self createBarButtonWithText:text
                                  targer:target
                                selector:selector
                                   color:[AMAppearanceManager getGlobalTintColor]];
}

+ (UIBarButtonItem *)createBarButtonWithText:(NSString *)text
                                      targer:(id)target
                                    selector:(SEL)selector
                                       color:(UIColor *)color {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
    button.title = text;
    button.tintColor = color;
    button.target = target;
    button.action = selector;
    return button;
}

+ (UIBarButtonItem *)createFlexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
}

+ (UIBarButtonItem *)createFixedSpaceWithSize:(float)value {
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    [fixedItem setWidth:value];
    return fixedItem;
}

+ (void)replaceObjectInToolBar:(UIToolbar *)aToolBar
                       atIndex:(NSInteger)anIndex
                    withObject:(NSObject *)anObject {
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in aToolBar.items) {
        [toolbarItems addObject:item];
    }
    toolbarItems[(NSUInteger) anIndex] = anObject;
    aToolBar.items = toolbarItems;
}

+ (void)clearObjectsInToolBar:(UIToolbar *)aToolBar {
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    aToolBar.items = toolbarItems;
}

+ (void)applyObjectsToToolBar:(UIToolbar *)aToolBar
                  fromAnArray:(NSMutableArray *)array {
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in array) {
        [toolbarItems addObject:item];
    }
    aToolBar.items = toolbarItems;
}

@end
