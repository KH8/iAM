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

@end

@implementation AMMenuToolBarCreator

- (id)initWithParentFrame: (CGRect)frame {
    self = [super init];
    if (self) {
        [self initMenuToolBarWithParentFrame:frame];
        [self initMenuToolBarComponents];
    }
    return self;
}

- (void)initMenuToolBarWithParentFrame: (CGRect)frame {
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.size.height/2*-1 + 15,
                                                           frame.size.height/2 - 15,
                                                           frame.size.height,
                                                           30)];
    _toolbar.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
    _toolbar.barTintColor = [UIColor orangeColor];
}

- (void)initMenuToolBarComponents{
    NSArray *buttons = [NSArray arrayWithObjects:
                        [self createBarButtonWithText:@"SEQUENCES"
                                             selector:@selector(sequencesButtonAction:)
                                                 font:[UIFont boldSystemFontOfSize:14]
                                                color:[UIColor blackColor]
                                              bgColor:[UIColor clearColor]],
                        [self createBarFixedSpaceWithSize:60],
                        [self createBarButtonWithText:@"PROPERTIES"
                                             selector:@selector(propertiesButtonAction:)
                                                 font:[UIFont systemFontOfSize:14]
                                                color:[UIColor blackColor]
                                              bgColor:[UIColor clearColor]],
                        [self createBarFixedSpaceWithSize:60],
                        [self createBarButtonWithText:@"ABOUT"
                                             selector:@selector(aboutButtonAction:)
                                                 font:[UIFont systemFontOfSize:14]
                                                color:[UIColor blackColor]
                                              bgColor:[UIColor clearColor]],
                        [self createBarFlexibleSpace],nil];
    [_toolbar setItems: buttons animated:NO];
}

- (UIBarButtonItem*)createBarButtonWithText: (NSString *)text
                                   selector: (SEL)selector
                                       font: (UIFont*)font
                                      color: (UIColor*)color
                                    bgColor: (UIColor*)bgColor{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 0, 30)];
    [label setFont:font];
    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    [label setTextColor:color];
    [label setBackgroundColor:bgColor];
    
    [button addSubview:label];
    [button sizeToFit];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchDown];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem*)createBarFlexibleSpace{
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
    return _toolbar;
}

- (IBAction)sequencesButtonAction:(id)sender{
}

- (IBAction)propertiesButtonAction:(id)sender{
}

- (IBAction)aboutButtonAction:(id)sender{
}

@end
