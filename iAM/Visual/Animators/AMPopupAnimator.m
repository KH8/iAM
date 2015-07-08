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
    return 0.3f;
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

+ (void)animatePanGesture:(UIPanGestureRecognizer *)sender
             inController:(UIViewController *)controller {
    CGPoint translate = [sender translationInView:controller.view];
    CGRect frame = controller.view.frame;
    if(sender.state == UIGestureRecognizerStateChanged) {
        if(translate.y < 0 ||
           translate.y > frame.size.height) {
            return;
        }
        CGRect newFrame = frame;
        newFrame.origin.y = translate.y;
        controller.view.frame = newFrame;
    }
    if(sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [sender velocityInView:controller.view].y;
        if (velocity > 100 ||
            translate.y > frame.size.height / 3) {
            [controller dismissViewControllerAnimated:YES
                                     completion:nil];
        } else {
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [controller.view setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
                             }
                             completion:nil];
        }
    }
}

@end
