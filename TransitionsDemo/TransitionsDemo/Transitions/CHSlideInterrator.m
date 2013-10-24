//
//  CHSlideInterrator.m
//  TransitionsDemo
//
//  Created by David Bonnet on 24/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHSlideInterrator.h"

@interface CHSlideInterrator ()

@property (nonatomic, assign) CGFloat   startScale;

@end


@implementation CHSlideInterrator

- (instancetype)initWithNavigationController:(UINavigationController *)nc
{
    self = [super init];
    if(self)
    {
        self.parent = nc;
        
        UIPinchGestureRecognizer *pg = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePinch:)];
        [[self.parent view] addGestureRecognizer:pg];
    }
    
    return self;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gr
{
    CGFloat scale = [gr scale];
    
    switch ([gr state])
    {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES; _startScale = scale;
            [self.parent popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percent = (1.0 - scale/_startScale);
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if([gr velocity] >= 0.0)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
            
            self.interactive = NO;
            break;
        }
        default:
            break;
    }
}

@end
