//
//  CHMainViewController.m
//  TransitionsDemo
//
//  Created by David Bonnet on 21/10/13.
//  Copyright (c) 2013 Cocoaheads. All rights reserved.
//

#import "CHMainViewController.h"
#import "CHLogoController.h"

//Transitions
#import "CHModalFromTopTransition.h"
#import "CHModalSpringTransition.h"

#import "CECardsAnimationController.h"
#import "CEFlipAnimationController.h"

#import "CHModalDynamicDropTransition.h"

//Interractions
#import "CHSlideInterrator.h"
#import "CEHorizontalSwipeInteractionController.h"

typedef NS_ENUM(NSUInteger, CHContextTransition)
{
    CHContextTransition_None            = 0,
    CHContextTransition_ModalFromTop    = 1,
    
    CHContextTransition_ModalSpring     = 2,
    
    CHContextTransition_ModalCard       = 3,
    CHContextTransition_ModalFlip       = 4,
    
    CHContextTransition_ModalDrop       = 5
};

@interface CHMainViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CHLogoController      *logoVC;
@property (nonatomic, assign) CHContextTransition   contextTransition;

@end

@implementation CHMainViewController

///////////////////////////////////////////////////////////
#pragma mark - Actions




#pragma mark Modal presentation

- (void)presentControllerModallyWithTransition:(CHContextTransition)transition
{
    self.contextTransition = transition;
    [self addCloseButton];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.logoVC];
    
    if(transition != CHContextTransition_None)
    {
        nav.transitioningDelegate = self;
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    [self presentViewController:nav animated:YES completion:NULL];
}









///////////////////////////////////////////////////////////
#pragma mark - UIViewControllerTransitioningDelegate

#pragma mark Animation delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    id <UIViewControllerAnimatedTransitioning> transitionObject = nil;
    
    if(self.contextTransition == CHContextTransition_ModalFromTop)
    {
        transitionObject = [[CHModalFromTopTransition alloc] initForPresenting:YES];
    }
    else if(self.contextTransition == CHContextTransition_ModalSpring)
    {
        transitionObject = [[CHModalSpringTransition alloc] initForPresenting:YES];
    }
    else if(self.contextTransition == CHContextTransition_ModalCard)
    {
        transitionObject = [[CECardsAnimationController alloc] init];
    }
    else if(self.contextTransition == CHContextTransition_ModalFlip)
    {
        CEFlipAnimationController *flipAnimator = [[CEFlipAnimationController alloc] init];
        flipAnimator.reverse = YES;
        transitionObject = flipAnimator;
    }
    else if(self.contextTransition == CHContextTransition_ModalDrop)
    {
        transitionObject = [[CHModalDynamicDropTransition alloc] initForPresenting:YES];
    }
    
    return transitionObject;
}





- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id <UIViewControllerAnimatedTransitioning> transitionObject = nil;
    
    if(self.contextTransition == CHContextTransition_ModalFromTop)
    {
        transitionObject = [[CHModalFromTopTransition alloc] initForPresenting:NO];
    }
    else if(self.contextTransition == CHContextTransition_ModalSpring)
    {
        transitionObject = [[CHModalSpringTransition alloc] initForPresenting:NO];
    }
    else if(self.contextTransition == CHContextTransition_ModalCard)
    {
        CECardsAnimationController *cardAnimator = [[CECardsAnimationController alloc] init];
        cardAnimator.reverse = YES;
        transitionObject = cardAnimator;
    }
    else if(self.contextTransition == CHContextTransition_ModalFlip)
    {
        transitionObject = [[CEFlipAnimationController alloc] init];
    }
    else if(self.contextTransition == CHContextTransition_ModalDrop)
    {
        transitionObject = [[CHModalDynamicDropTransition alloc] initForPresenting:NO];
    }
    
    return transitionObject;
}





#pragma mark Interaction delegate

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    id <UIViewControllerInteractiveTransitioning> interactionObject = nil;
//    
//    if(self.contextTransition == CHContextTransition_ModalFlip)
//    {
//        CEHorizontalSwipeInteractionController *horSwipe = [[CEHorizontalSwipeInteractionController alloc] init];
//        
//        [horSwipe wireToViewController:self.presentedViewController forOperation:CEInteractionOperationDismiss];
//        
//        interactionObject = horSwipe;
//    }
//    
//    return interactionObject;
//}




////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return [[CHSlideInterrator alloc] initWithNavigationController:navigationController];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functionnal code

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Transitions demo";
    
    self.logoVC = [CHLogoController new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0) return 2;
    else if(section == 1) return 2;
    else if(section == 2) return 2;
    else if(section == 4) return 1;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Slide push";
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Modal";
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Modal from top";
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Spring modal from top";
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Modal card";
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Modal flip";
        }
    }
    else if(indexPath.section == 4)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Modal drop";
        }
    }
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) return @"Basic";
    else if(section == 1) return @"Simple custom";
    else if(section == 2) return @"Keyframe";
    else if(section == 3) return @"Collections";
    else if(section == 4) return @"Dynamics";
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Basic
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //Slide push
            self.navigationController.delegate              = self;
            self.navigationController.transitioningDelegate = self;
            
            [self.navigationController pushViewController:self.logoVC animated:YES];
        }
        else if(indexPath.row == 1)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_None];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_ModalFromTop];
        }
        else if(indexPath.row == 1)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_ModalSpring];
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_ModalCard];
        }
        else if(indexPath.row == 1)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_ModalFlip];
        }
    }
    else if(indexPath.section == 4)
    {
        if(indexPath.row == 0)
        {
            [self presentControllerModallyWithTransition:CHContextTransition_ModalDrop];
        }
    }
}

#pragma mark - Functional actions

- (void)addCloseButton
{
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(close:)];
    self.logoVC.navigationItem.leftBarButtonItem = close;
}

- (void)close:(id)sender
{
    [self.logoVC dismissViewControllerAnimated:YES completion:^{
        self.logoVC.navigationItem.leftBarButtonItem = nil;
    }];
}

@end
