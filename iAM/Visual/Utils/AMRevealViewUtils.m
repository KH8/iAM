//
//  AMRevealViewUtils.m
//  iAM
//
//  Created by Krzysztof Reczek on 10.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMRevealViewUtils.h"

@implementation AMRevealViewUtils

+ (void)initRevealController:(SWRevealViewController *)controller
             withRightButton:(UIBarButtonItem *)rightButton
               andLeftButton:(UIBarButtonItem *)leftButton {
    float menuWindowSize = (float) ([UIScreen mainScreen].bounds.size.height / 7.0);
    [controller panGestureRecognizer];
    [controller tapGestureRecognizer];
    [controller setRearViewRevealWidth:0];
    [controller setRearViewRevealOverdraw:0];
    [controller setRightViewRevealWidth:0];
    [controller setRightViewRevealOverdraw:0];
    
    if(leftButton!=nil) {
        [controller setRearViewRevealWidth:menuWindowSize + 5];
        [controller setRearViewRevealOverdraw:20];
        
        [leftButton setTarget:controller];
        [leftButton setAction:@selector(revealToggle:)];
    }
    if(rightButton!=nil) {
        [controller setRightViewRevealWidth:280];
        [controller setRightViewRevealOverdraw:20];
        
        [rightButton setTarget:controller];
        [rightButton setAction:@selector(rightRevealToggle:)];
    }
}

@end
