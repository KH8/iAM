//
//  AMMenuToolBarCreator.m
//  iAM
//
//  Created by Krzysztof Reczek on 13.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMenuToolBarCreator.h"

@interface AMMenuToolBarCreator ()

@property (nonatomic) UIToolbar* toolbar;
@property (nonatomic) UIViewController* parent;

@property (nonatomic) UIBarButtonItem* sequenceButton;
@property (nonatomic) UIBarButtonItem* propertiesButton;
@property (nonatomic) UIBarButtonItem* aboutButton;

@end

@implementation AMMenuToolBarCreator

- (id)initWithParent: (UIViewController*)parent {
    self = [super init];
    if (self) {
        _parent = parent;
    }
    return self;
}

- (UIBarButtonItem*)createBarButtonWithLabel: (UILabel *)label
                                    selector: (SEL)selector{
    [label setUserInteractionEnabled:NO];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addSubview:label];
    [button sizeToFit];
    [button addTarget:_parent
               action:selector
     forControlEvents:UIControlEventTouchDown];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UILabel*)createBarButtonLabelWithText: (NSString *)text
                                    font: (UIFont*)font
                                   color: (UIColor*)color
                                 bgColor: (UIColor*)bgColor{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 0, 30)];
    [label setFont:font];
    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    [label setTextColor:color];
    [label setBackgroundColor:bgColor];
    
    return label;
}


- (UIBarButtonItem*)createBarFlexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
}

- (UIBarButtonItem*)createBarFixedSpaceWithSize: (NSInteger)size{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = size;
    return fixedSpace;
}

- (UIToolbar*)getToolBar{
    [self initMenuToolBarWithParentFrame:_parent.view.frame];
    [self initMenuToolBarComponents];
    return _toolbar;
}

- (void)initMenuToolBarWithParentFrame: (CGRect)frame {
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.size.height/2*-1 + 15,
                                                           frame.size.height/2 - 15,
                                                           frame.size.height,
                                                           30)];
    _toolbar.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
    _toolbar.barTintColor = [UIColor clearColor];
}

- (void)initMenuToolBarComponents{
    NSArray *buttons = [NSArray arrayWithObjects:
                        _sequenceButton,
                        [self createBarFlexibleSpace],
                        _propertiesButton,
                        [self createBarFlexibleSpace],
                        _aboutButton,
                        [self createBarFlexibleSpace],nil];
    
    [_toolbar setItems: buttons animated:NO];
}

- (void)setSequenceButton: (UIBarButtonItem*)button{
    _sequenceButton = button;
}

- (void)setPropertiesButton: (UIBarButtonItem*)button{
    _propertiesButton = button;
}

- (void)setAboutButton: (UIBarButtonItem*)button{
    _aboutButton = button;
}

@end
