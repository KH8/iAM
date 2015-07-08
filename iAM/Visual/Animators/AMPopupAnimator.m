//
//  AMPopupAnimator.m
//  iAM
//
//  Created by Krzysztof Reczek on 07.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMPopupAnimator.h"

@implementation AMPopupAnimator

const float DURATION = 0.25F;
const float INIT_ALPHA = 0.4F;
const float FINAL_ALPHA = 1.0F;

@synthesize presenting;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return DURATION;
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
        toViewController.view.alpha = INIT_ALPHA;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = FINAL_ALPHA;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        endFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endFrame;
            fromViewController.view.alpha = INIT_ALPHA;
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
        controller.view.alpha = [self getAlphaFactor:frame.size.height
                                          inPosition:translate.y];
    }
    if(sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [sender velocityInView:controller.view].y;
        if (velocity > 100 ||
            translate.y > frame.size.height / 3) {
            [controller dismissViewControllerAnimated:YES
                                     completion:nil];
        } else {
            [UIView animateWithDuration:DURATION
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [controller.view setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
                                 controller.view.alpha = FINAL_ALPHA;
                             }
                             completion:nil];
        }
    }
}

+ (CGFloat)getAlphaFactor:(CGFloat)height
               inPosition:(CGFloat)position {
    return FINAL_ALPHA - ( ( position / height ) * ( FINAL_ALPHA - INIT_ALPHA ) );
}

@end
