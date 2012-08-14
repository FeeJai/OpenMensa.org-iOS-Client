//
//  FirstViewController.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "MainScreenViewController.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController


#pragma mark - DataAPIDelegate

-(void)APIDataHasBeenUpdated {

    [table reloadData];
    [activityIndicator stopAnimating];

}

#pragma mark - UITableViewDataSource protocol


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return NSLocalizedString(@"Deine Mensa Favoriten:", @"favourite cafeterias");;
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    if (![api lastUpdate]) {
        NSLog(@"Waiting for Data on API before table with food can be viewed");
        return 0;
    } else {
        NSLog(@"Showing cafeterias on table");
    }
    
    if (section == 0) return [[favourites favouriteCafeterias] count];
    return 0;
}


-(UITableViewCell *)reuseOrCreateCellForTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier withStyle:(UITableViewCellStyle)style withIndicator:(BOOL)withIndicator {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell != nil) return cell;
    cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier];
    if (withIndicator) [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    //NSInteger section = indexPath.section, row = indexPath.row;
    
    cell = [self reuseOrCreateCellForTableView:tableView withIdentifier:@"cafeteriasCell" withStyle:UITableViewCellStyleSubtitle withIndicator:YES];

    
    NSDictionary* cafeteria = [[api cafeterias] objectAtIndex: (indexPath.row)];
            
    cell.textLabel.text = [cafeteria objectForKey:@"name"];
    cell.detailTextLabel.text = [cafeteria objectForKey:@"address"];

    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    //cell.detailTextLabel.textColor = [UIColor colorWithRed:0.953 green:0 blue:0 alpha:1.0];

    return cell;
}


#pragma mark - UITableViewDelegate protocol

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.section == 1) {
        if (indexPath.row < [self numberOfRowsInRecents] - 1) {
            // Recents
            TransactionViewController *viewController = [[[TransactionViewController alloc] initWithTransaction:[[UserData instance] recentTransactionForIndex:indexPath.row]] autorelease];
            [[self navigationController] pushViewController:viewController animated:YES];
        } else {
            // More button
            TransactionListController *viewController = [[[TransactionListController alloc] initWithTransactionsArray:[[UserData instance] transactions]] autorelease];
            [[self navigationController] pushViewController:viewController animated:YES];
        }
    }
    if (indexPath.section == 2) {
        // Recharge
        UIActionSheet *rechargeSelection = [Helper rechargeActionSheet];
        rechargeSelection.delegate = self;
        // When showing in self.view the touch area is limited by the tab bar!!! Perhaps submit to Apple ...
        [rechargeSelection showFromTabBar:self.tabBarController.tabBar];
        [rechargeSelection release];
    } */
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if (indexPath.section == 0)
        return nil;
    else */
        return indexPath;
}



#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Menü anzeigen", @"Menu");
        self.tabBarItem.image = [UIImage imageNamed:@"forkAndKnife"];
    }
    
    favourites = [FavouriteCafeteriaStorage instance];
    api = [DataAPI instance];
    [api setDelegate:self];

    [activityIndicator startAnimating];
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
