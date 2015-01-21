//
//  CountrySelectionViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CountrySelectionViewController.h"
#import "CountryCodes.h"

@implementation CountrySelectionViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Select a Country", @"");
}

- (void)dealloc {
    [super dealloc];
}

// UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[CountryCodes countryCodes].countries count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"CountryCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CountryCell"] autorelease];
	}
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger countryCode = [userDefaults integerForKey:@"CountryCode"];
	NSDictionary *country = [[CountryCodes countryCodes].countries objectAtIndex:indexPath.row];
	if (countryCode == [[country objectForKey:@"CountryCode"] integerValue]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		selectedCellIndex = indexPath.row;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;	
	}
	cell.textLabel.text = [country objectForKey:@"CountryName"];
	return cell;
}

// UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];

	// Decheck the previously checked row
	UITableViewCell *cell = [theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	// Check the selected row
	selectedCellIndex = indexPath.row;
	cell = [theTableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	// Update preferences
	NSDictionary *country = [[CountryCodes countryCodes].countries objectAtIndex:indexPath.row];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setInteger:[[country objectForKey:@"CountryCode"] integerValue] forKey:@"CountryCode"];
}

@end
