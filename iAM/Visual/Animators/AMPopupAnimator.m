//
//  AMPopupAnimator.m
//  iAM
//
//  Created by Krzysztof Reczek on 07.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMPopupAnimator.h"

@implementation AMPopupAnimator

@synthesize presenting;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = fromViewController.view.frame;
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]);
        
        toViewController.view.frame = startFrame;
        toViewController.view.alpha = 0.5f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        endFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endFrame;
            fromViewController.view.alpha = 0.5f;
        } completion:^(BOOL finished) {
            toViewController.view.userInteractionEnabled = YES;
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
