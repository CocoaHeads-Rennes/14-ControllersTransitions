//
//  CHModalDynamicDropTransition.m
//  TransitionsDemo
//
//  Created by David Bonnet on 22/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalDynamicDropTransition.h"
#import "CHModalFromTopTransition_subclass.h"

@interface CHModalDynamicDropTransition ()

@property (nonatomic, strong) UIDynamicAnimator     *animator;

@end

@implementation CHModalDynamicDropTransition

///////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning

- (void)dismissingAnimationFromView:(UIView*)fView toView:(UIView*)tView onContentView:(UIView*)cView endFrame:(CGRect)endFrame duration:(NSTimeInterval)duration completion:(void(^)(BOOL))completion
{
    UIView *dim = [tView viewWithTag:1234];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:cView];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[fView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[fView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:fView];
    [self.animator addBehavior:itemBehaviour];
    
    [UIView animateWithDuration:duration*2
                     animations:^
     {
         tView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
         
         dim.alpha = 0;
         
         fView.frame = endFrame;
     }
                     completion:^(BOOL finished)
     {
         [dim removeFromSuperview];
         if(completion) completion(YES);
     }];
}

@end
