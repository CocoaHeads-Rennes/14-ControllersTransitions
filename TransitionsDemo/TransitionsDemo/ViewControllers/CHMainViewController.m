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

@interface CHMainViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) CHLogoController *logoVC;

@end

@implementation CHMainViewController

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
    else if(section == 1) return 1;
    
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
    //Basic
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //Slide push
            [self.navigationController pushViewController:self.logoVC animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //Modal
            [self addCloseButton];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.logoVC];
            
            [self presentViewController:nav animated:YES completion:NULL];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            //Modal
            [self addCloseButton];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.logoVC];
            nav.transitioningDelegate = self;
            nav.modalPresentationStyle = UIModalPresentationCustom;
            
            [self presentViewController:nav animated:YES completion:NULL];
        }
    }
}

///////////////////////////////////////////////////////////
#pragma mark - Actions

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

///////////////////////////////////////////////////////////
#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[CHModalFromTopTransition alloc] initForPresenting:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[CHModalFromTopTransition alloc] initForPresenting:NO];
}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    
//}


@end
