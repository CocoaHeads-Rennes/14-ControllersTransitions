//
//  CHModalfromTopTransition.m
//  TransitionsDemo
//
//  Created by David Bonnet on 21/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalFromTopTransition.h"

@implementation CHModalFromTopTransition

- (id)initForPresenting:(BOOL)presenting
{
    self = [super init];
    if(self)
    {
        self.presenting = presenting;
    }
    return self;
}

///////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}


// This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"Animate with context : %@", transitionContext);
    
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *cView               = [transitionContext containerView];
    
    CGRect endFrame             = CGRectMake(20, 80, 280, fromVC.view.bounds.size.height-160);
    CGRect startFrame           = endFrame;
    startFrame.origin.y -= (endFrame.size.height + endFrame.origin.y);
    
    if(self.presenting)
    {
        fromVC.view.userInteractionEnabled = NO;
        
        [cView addSubview:fromVC.view];
        [cView addSubview:toVC.view];
        
        toVC.view.frame = startFrame;
        toVC.view.clipsToBounds = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
         {
             fromVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
             toVC.view.frame = endFrame;
         }
                         completion:^(BOOL finished)
         {
             [transitionContext completeTransition:YES];
         }];
    }
    else
    {
        toVC.view.userInteractionEnabled = YES;
        
        [cView addSubview:toVC.view];
        [cView addSubview:fromVC.view];
        
        CGRect finalFrame   = endFrame;
        finalFrame.origin.y += 2*(endFrame.size.height + endFrame.origin.y);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            fromVC.view.frame = finalFrame;
        }
                         completion:^(BOOL finished)
        {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"Animation ended : %i", transitionCompleted);
}

@end
