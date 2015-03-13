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

- (id)initWithParentFrame: (CGRect)frame;

- (UIToolbar*)getToolBar;

@end
