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
    
    UIView *fView               = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] view];
    UIView *tView               = [[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] view];
    
    UIView *cView               = [transitionContext containerView];
    
    CGRect endFrame             = CGRectMake(20, 80, 280, fromVC.view.bounds.size.height-160);
    CGRect startFrame           = endFrame;
    startFrame.origin.y        -= (endFrame.size.height + endFrame.origin.y);
    
    if(self.presenting)
    {
        fView.userInteractionEnabled = NO;
        
        [cView addSubview:fView];
        [cView addSubview:tView];
        
        tView.frame = startFrame;
        
        [self presentingAnimationFromView:fView
                                   toView:tView
                            onContentView:cView
                                 endFrame:endFrame
                                 duration:[self transitionDuration:transitionContext]
                               completion:^(BOOL)
        {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        tView.userInteractionEnabled = YES;
        
        [cView addSubview:tView];
        [cView addSubview:fView];
        
        CGRect finalFrame   = endFrame;
        finalFrame.origin.y += 2*(endFrame.size.height + endFrame.origin.y);
        
        UIView *dim = [tView viewWithTag:1234];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            tView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [fView tintColorDidChange];
            
            dim.alpha = 0;
            
            fView.frame = finalFrame;
        }
                         completion:^(BOOL finished)
        {
            [dim removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)presentingAnimationFromView:(UIView*)fView toView:(UIView*)tView onContentView:(UIView*)cView endFrame:(CGRect)endFrame duration:(NSTimeInterval)duration completion:(void(^)(BOOL))completion
{
    UIView *dim = [[UIView alloc] initWithFrame:fView.bounds];
    dim.backgroundColor = [UIColor blackColor];
    dim.alpha = 0;
    dim.tag = 1234;
    [fView addSubview:dim];
    
    [UIView animateWithDuration:duration
                     animations:^
     {
         fView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
         [fView tintColorDidChange];
         
         dim.alpha = 0.6;
         
         tView.frame = endFrame;
     }
                     completion:^(BOOL finished)
     {
         if(completion) completion(finished);
     }];
}

- (void)dismissingAnimationFromView:(UIView*)fView toView:(UIView*)tView onContentView:(UIView*)cView endFrame:(CGRect)endFrame duration:(NSTimeInterval)duration completion:(void(^)(BOOL))completion
{
    
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"Animation ended : %i", transitionCompleted);
}

@end
