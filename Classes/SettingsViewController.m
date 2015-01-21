//
//  SettingsViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "TextInputCell.h"
#import "PhoneNumberView.h"
#import "CountryCodes.h"
#import "CountrySelectionViewController.h"
#import "MainViewController+Actions.h"

@interface SettingsViewController (PrivateMethods)

- (void)pushCountrySelectionViewController;

@end


@implementation SettingsViewController

// View
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize phoneNumberView;
@synthesize phoneNumberHeaderLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];
	
	firstDisplay = YES;
	
	self.navigationItem.title = NSLocalizedString(@"Settings",@"");
	
	if (self.style == frontViewStyle) {
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					target:self
																					action:@selector(doneButtonAction:)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];

		phoneNumberHeaderLabel.textColor = [UIColor colorWithRed:78/255.0 green:88/255.0 blue:107/255.0 alpha:1.0];
		phoneNumberHeaderLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		phoneNumberHeaderLabel.shadowOffset = CGSizeMake(0, 1);
	}
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[firstNameCell release];
	[lastNameCell release];
	[phoneNumberView release];
	[phoneNumberHeaderLabel release];
	
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	// Save the preferences
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:firstNameCell.textField.text forKey:@"FirstName"];
	[userDefaults setObject:lastNameCell.textField.text forKey:@"LastName"];
	[userDefaults setObject:phoneNumberView.textField.text forKey:@"PhoneNumber"];
	
	[super viewWillDisappear:animated];
}

// UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					firstNameCell.textField.text = [userDefaults objectForKey:@"FirstName"];
					cell = firstNameCell;
					if (firstDisplay) {
						[firstNameCell.textField becomeFirstResponder];
						firstDisplay = NO;
					}
					break;
				case 1:
					lastNameCell.textField.text = [userDefaults objectForKey:@"LastName"];
					cell = lastNameCell;
					break;
				default:
					break;
			}
			break;
		case 1:
			cell = [theTableView dequeueReusableCellWithIdentifier:@"CountryCodeCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CountryCodeCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.text = NSLocalizedString(@"Country Code", @"");
			}
			NSInteger countryCode = [userDefaults integerForKey:@"CountryCode"];
			cell.detailTextLabel.text = [[CountryCodes countryCodes] countryNameWithCountryCode:countryCode];
		default:
			break;
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows;
	
	switch (section) {
		case 0:
			rows = 2;
			break;
		case 1:
			rows = 1;
		default:
			break;
	}
	
	return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

// UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 1:
			switch (indexPath.row) {
				case 0:
					[theTableView deselectRowAtIndexPath:indexPath animated:YES];
					
					[self pushCountrySelectionViewController];
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGFloat height = 0;
	switch (section) {
		case 1:
			height = phoneNumberView.frame.size.height;
			break;
		default:
			break;
	}
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view=nil;
	switch (section) {
		case 1: {
			if (![phoneNumberView.textField isFirstResponder]) {
				NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
				NSInteger countryCode = [userDefaults integerForKey:@"CountryCode"];
				[phoneNumberView.button setTitle:[NSString stringWithFormat:@"+%d", countryCode]
										forState:UIControlStateNormal];
				phoneNumberView.textField.text = [userDefaults objectForKey:@"PhoneNumber"];
			}

			view = phoneNumberView;
			break;
		}
		default:
			break;
	}
	return view;
}

// Actions

- (IBAction)countryCodeButtonAction:(id)sender {
	[self pushCountrySelectionViewController];
}

// Notifications

- (void)keyboardDidShow:(NSNotification *)notification {
	CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height;
	
	CGRect frame = self.view.frame;
	frame.size.height -= keyboardHeight;
	tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
	CGRect frame = tableView.frame;
	frame.size.height += self.view.frame.size.height;
	tableView.frame = frame;
}

// UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:phoneNumberView.textField.text forKey:@"PhoneNumber"];
}

// Actions

- (void)doneButtonAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

// Private Methods

- (void)pushCountrySelectionViewController {	
	CountrySelectionViewController *countrySelection = [[CountrySelectionViewController alloc]
														initWithNibName:@"CountrySelectionViewController"
														bundle:nil];
	countrySelection.style = self.style;
	[self.navigationController pushViewController:countrySelection animated:YES];
	[countrySelection release];
}

@end
