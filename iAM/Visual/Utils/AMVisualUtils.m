//
//  AMVisualUtils.m
//  iAM
//
//  Created by Krzysztof Reczek on 09.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMVisualUtils.h"

@implementation AMVisualUtils

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

@end
