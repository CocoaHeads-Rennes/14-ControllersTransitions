//
//  CHModalFromTopTransition_subclass.h
//  TransitionsDemo
//
//  Created by David Bonnet on 24/10/2013.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHModalFromTopTransition.h"

@interface CHModalFromTopTransition ()

- (void)presentingAnimationFromView:(UIView*)fView toView:(UIView*)tView onContentView:(UIView*)cView endFrame:(CGRect)endFrame duration:(NSTimeInterval)duration completion:(void(^)(BOOL))completion;

- (void)dismissingAnimationFromView:(UIView*)fView toView:(UIView*)tView onContentView:(UIView*)cView endFrame:(CGRect)endFrame duration:(NSTimeInterval)duration completion:(void(^)(BOOL))completion;

@end
