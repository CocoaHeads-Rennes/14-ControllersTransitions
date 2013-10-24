//
//  CHModalSpringTransition.m
//  TransitionsDemo
//
//  Created by David Bonnet on 22/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalSpringTransition.h"
#import "CHModalFromTopTransition_subclass.h"

@implementation CHModalSpringTransition

///////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.5;
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
                          delay:0.f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         fView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
         
         dim.alpha = 0.6;
         
         tView.frame = endFrame;
     }
                     completion:^(BOOL finished)
     {
         if(completion) completion(YES);
     }];
}


@end
