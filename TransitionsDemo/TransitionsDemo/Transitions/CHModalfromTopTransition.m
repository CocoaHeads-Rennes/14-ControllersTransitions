//
//  CHModalfromTopTransition.m
//  TransitionsDemo
//
//  Created by David Bonnet on 21/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalFromTopTransition.h"

@implementation CHModalFromTopTransition

NSUInteger const dimViewTag = 1234;

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

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}


// This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //Get content
    UIView *fView               = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] view];
    UIView *tView               = [[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]   view];
    
    UIView *cView               = [transitionContext containerView];
    
    //Compute custom end frame and start frame
    CGRect endFrame             = CGRectMake(20, 80, 280, fView.bounds.size.height-160);
    CGRect startFrame           = endFrame;
    startFrame.origin.y        -= (endFrame.size.height + endFrame.origin.y);
    
    if(self.presenting)
    {
        //Present animation
        fView.userInteractionEnabled = NO;
        
        [cView addSubview:fView];
        [cView addSubview:tView];
        
        tView.frame = startFrame;
        
        [self presentingAnimationFromView:fView
                                   toView:tView
                            onContentView:cView
                                 endFrame:endFrame
                                 duration:[self transitionDuration:transitionContext]
                               completion:^(BOOL finished)
        {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        //Dismiss animation
        tView.userInteractionEnabled = YES;
        
        [cView addSubview:tView];
        [cView addSubview:fView];
        
        CGRect finalFrame   = endFrame;
        finalFrame.origin.y += 2*(endFrame.size.height + endFrame.origin.y);
        
        [self dismissingAnimationFromView:fView
                                   toView:tView
                            onContentView:cView
                                 endFrame:finalFrame
                                 duration:[self transitionDuration:transitionContext]
                               completion:^(BOOL finished)
        {
            [transitionContext completeTransition:YES];
        }];
    }
}







- (void)presentingAnimationFromView:(UIView*)fView
                             toView:(UIView*)tView
                      onContentView:(UIView*)cView
                           endFrame:(CGRect)endFrame
                           duration:(NSTimeInterval)duration
                         completion:(void(^)(BOOL))completion
{
    UIView *dim = [[UIView alloc] initWithFrame:fView.bounds];
    dim.backgroundColor = [UIColor blackColor];
    dim.alpha = 0;
    dim.tag = dimViewTag;
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







- (void)dismissingAnimationFromView:(UIView*)fView
                             toView:(UIView*)tView
                      onContentView:(UIView*)cView
                           endFrame:(CGRect)endFrame
                           duration:(NSTimeInterval)duration
                         completion:(void(^)(BOOL))completion
{
    UIView *dim = [tView viewWithTag:dimViewTag];
    
    [UIView animateWithDuration:duration
                     animations:^
     {
         tView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
         [fView tintColorDidChange];
         
         dim.alpha = 0;
         
         fView.frame = endFrame;
     }
                     completion:^(BOOL finished)
     {
         [dim removeFromSuperview];
         if(completion) completion(finished);
     }];
}




- (void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"Animation ended : %i", transitionCompleted);
}

@end
