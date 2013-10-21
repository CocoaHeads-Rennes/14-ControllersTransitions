//
//  CHModalfromTopTransition.h
//  TransitionsDemo
//
//  Created by David Bonnet on 21/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHModalFromTopTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL  presenting;         //Dismissing if NO

- (id)initForPresenting:(BOOL)presenting;

@end
