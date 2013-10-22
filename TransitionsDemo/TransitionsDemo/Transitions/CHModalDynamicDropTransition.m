//
//  CHModalDynamicDropTransition.m
//  TransitionsDemo
//
//  Created by David Bonnet on 22/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalDynamicDropTransition.h"

@interface CHModalDynamicDropTransition ()

@property (nonatomic, strong) UIDynamicAnimator     *animator;

@end

@implementation CHModalDynamicDropTransition

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
        
        UIView *dim = [[UIView alloc] initWithFrame:fromVC.view.bounds];
        dim.backgroundColor = [UIColor blackColor];
        dim.alpha = 0;
        dim.tag = 1234;
        [fromVC.view addSubview:dim];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
         {
             fromVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
             
             dim.alpha = 0.6;
             
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
        
        UIView *dim = [toVC.view viewWithTag:1234];

        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:cView];
        
        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
        gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
        [self.animator addBehavior:gravityBehaviour];
        
        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[fromVC.view]];
        [itemBehaviour addAngularVelocity:-M_PI_2 forItem:fromVC.view];
        [self.animator addBehavior:itemBehaviour];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]*2
                         animations:^
         {
             toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
             
             dim.alpha = 0;
             
             fromVC.view.frame = finalFrame;
         }
                         completion:^(BOOL finished)
         {
             [dim removeFromSuperview];
             [transitionContext completeTransition:YES];
         }];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"Animation ended : %i", transitionCompleted);
}

@end
