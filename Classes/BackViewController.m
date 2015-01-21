//
//  BackViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BackViewController.h"
#import "SettingsViewController.h"
#import "LegalViewController.h"


@implementation BackViewController

// View
@synthesize tableView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	tableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
}

- (void)dealloc {
	[tableView release];
	
    [super dealloc];
}

// UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"NormalCell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = NSLocalizedString(@"Settings", @"Cell's text");
			break;
		case 1:
			cell.textLabel.text = NSLocalizedString(@"Legal", @"Cell's text");
			break;
		default:
			break;
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

// UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
	

	
	switch (indexPath.section) {
		case 0: {
			SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
			settingsViewController.style = backViewStyle;
			[self.navigationController pushViewController:settingsViewController animated:YES];
			[settingsViewController release];
			break;
		} case 1: {
			LegalViewController *legalViewController = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:nil];
			[self.navigationController pushViewController:legalViewController animated:YES];
			[legalViewController release];
			break;
		}
		default:
			break;
	}
}

@end
