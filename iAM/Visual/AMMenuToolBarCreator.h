//
//  AMMenuToolBarCreator.h
//  iAM
//
//  Created by Krzysztof Reczek on 13.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMMenuToolBarCreator : NSObject

- (id)initWithParent: (UIViewController*)parent;

- (UIToolbar*)getToolBar;

- (UIBarButtonItem*)createBarButtonWithLabel: (UILabel *)label
                                    selector: (SEL)selector;
- (UILabel*)createBarButtonLabelWithText: (NSString *)text
                                    font: (UIFont*)font
                                   color: (UIColor*)color
                                 bgColor: (UIColor*)bgColor;
- (UIBarButtonItem*)createBarFlexibleSpace;
- (UIBarButtonItem*)createBarFixedSpaceWithSize: (NSInteger)size;

- (void)setSequenceButton: (UIBarButtonItem*)button;
- (void)setPropertiesButton: (UIBarButtonItem*)button;
- (void)setAboutButton: (UIBarButtonItem*)button;

@end
