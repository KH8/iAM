//
//  AMVisualUtils.h
//  iAM
//
//  Created by Krzysztof Reczek on 09.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AMVisualUtils : NSObject

+ (UIBarButtonItem *)createBarButton:(NSString *)pictureName
                              targer:(id)target
                            selector:(SEL)selector
                                size:(NSInteger)size;

+ (UIBarButtonItem *)createBarButton:(NSString *)pictureName
                              targer:(id)target
                            selector:(SEL)selector
                               color:(UIColor *)color
                                size:(NSInteger)size;

+ (UIBarButtonItem *)createBarButtonWithText:(NSString *)text
                                      targer:(id)target
                                    selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonWithText:(NSString *)text
                                      targer:(id)target
                                    selector:(SEL)selector
                                       color:(UIColor *)color;

+ (void)replaceObjectInToolBar:(UIToolbar *)aToolBar
                       atIndex:(NSInteger)anIndex
                    withObject:(NSObject *)anObject;

@end
