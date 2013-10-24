//
//  CHSlideInterrator.h
//  TransitionsDemo
//
//  Created by David Bonnet on 24/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHSlideInterrator : UIPercentDrivenInteractiveTransition

@property(nonatomic, assign)                          UINavigationController  *parent;
@property(nonatomic, assign, getter = isInteractive)  BOOL                    interactive;


- (instancetype)initWithNavigationController:(UINavigationController *)nc;


@end
