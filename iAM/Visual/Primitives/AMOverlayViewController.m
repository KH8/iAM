//
//  AMOverlayViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 09.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMOverlayViewController.h"
#import "AMPopupAnimator.h"

@implementation AMOverlayViewController

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    AMPopupAnimator *animator = [AMPopupAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    AMPopupAnimator *animator = [AMPopupAnimator new];
    return animator;
}

- (IBAction)panPerformed:(UIPanGestureRecognizer *)sender {
    [AMPopupAnimator animatePanGesture:sender
                          inController:self];
}

@end
