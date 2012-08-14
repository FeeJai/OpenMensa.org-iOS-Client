//
//  ShowMenuNavigationControllerViewController.m
//  OpenMensa
//
//  Created by Felix Jankowski on 14.08.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "ShowMenuNavigationController.h"

#import "CafeteriaOverview.h"


@interface ShowMenuNavigationController ()

@end

@implementation ShowMenuNavigationController


-(void) viewDidLoad
{
    
    [super viewDidLoad];

    UIViewController *viewController1 = [[CafeteriaOverview alloc] initWithNibName:@"CafeteriaOverview" bundle:nil];
    [self pushViewController:viewController1 animated:NO];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Menü anzeigen", @"Menu");
        self.tabBarItem.image = [UIImage imageNamed:@"forkAndKnife"];
    }
    
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
