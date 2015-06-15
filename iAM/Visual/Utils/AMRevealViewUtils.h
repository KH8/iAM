//
//  AMRevealViewUtils.h
//  iAM
//
//  Created by Krzysztof Reczek on 10.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface AMRevealViewUtils : NSObject

+ (void)initRevealController:(SWRevealViewController *)controller
             withRightButton:(UIBarButtonItem *)rightButton
               andLeftButton:(UIBarButtonItem *)leftButton;

@end
