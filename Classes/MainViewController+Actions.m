//
//  MainViewController+Actions.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 25/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController+Actions.h"
#import "NotesViewController.h"
#import "Order.h"
#import "PickupLocation.h"
#import "OrderViewController.h"
#import "AddBookmarkViewController.h"
#import "BookmarksViewController.h"
#import "UIFactory.h"
#import "PickupTimeButton.h"
#import "BackViewController.h"
#import "CustomDatePicker.h"
#import "BackNavigationController.h"
#import "SettingsViewController.h"
#import <AddressBook/AddressBook.h>

@interface MainViewController (PrivateMethods)

- (void)refreshPickupAddress;
- (void)hideDatePicker;

@end


@implementation MainViewController (Buttons)

- (IBAction)locateMeButtonAction:(id)sender {
	// Ignore the touch if the system didn't find the user position yet
	if (mapJustInitialized) {
		return;
	}
	
	// If the map found the user location
	if (mapView.userLocation != nil) {
		[self setPickupLocationToLocation:mapView.userLocation.location];
		// Reverse geocode the user location
		[self reverseGeocodeCoordinate:mapView.userLocation.location.coordinate];
		pickupLocationIsCurrentLocation = YES;
	}
}

- (IBAction)bookmarksButtonAction:(id)sender {
	UINavigationController *navigationController = [UIFactory newUIObjectFromNib:@"BookmarksController" owner:nil];
	((BookmarksViewController *)navigationController.topViewController).mainViewController = self;
	[self presentModalViewController:navigationController animated:YES];
	[navigationController release];
}

- (void)taxiButtonAction:(id)sender {
	// Check if the pickup address is valid
	NSDictionary *pickupAddress = order.pickupAddress;
	NSString *street = [pickupAddress objectForKey:(NSString *)kABPersonAddressStreetKey];
	NSString *postalCode = [pickupAddress objectForKey:(NSString *)kABPersonAddressZIPKey];
	NSString *locality = [pickupAddress objectForKey:(NSString *)kABPersonAddressCityKey];
	NSString *countryCode = [pickupAddress objectForKey:@"CountryCode"];	
	if ([pickupAddress count] == 0 || !street || !postalCode || !locality || !countryCode) {
		// Display error message
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Address", @"Error message title")
															message:NSLocalizedString(@"Please specify a more accurate pickup address (street, zip code, city).", @"Error message")
														   delegate:nil
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		[alertView show];
		[alertView release];
		
		return;
	}
	
	// Check if the user information is set
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *firstName = [userDefaults stringForKey:@"FirstName"];
	NSString *lastName = [userDefaults stringForKey:@"LastName"];
	NSString *phoneNumber = [userDefaults stringForKey:@"PhoneNumber"];
	if (firstName == nil || [firstName isEqualToString:@""] ||
		lastName == nil  || [lastName isEqualToString:@""] ||
	    phoneNumber == nil || [phoneNumber isEqualToString:@""]) {
		// Display error message
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hello, what's your name?", @"Error message title")
															message:NSLocalizedString(@"In order to be able to place orders, TaxiNow! needs to know your name along with your phone number.", @"Error message")
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		[alertView show];
		[alertView release];
		
		SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
		settingsViewController.style = frontViewStyle;
		
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
		[settingsViewController release];
		
		[self presentModalViewController:navigationController animated:YES];
		[navigationController release];
		
		
		return;
	}
	
	OrderViewController *orderViewController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
	order.status = SendingOrder;
	orderViewController.order = order;
	
	// Reset the order
	Order *newOrder = [[Order alloc] init];
	newOrder.pickupAddress = [[order.pickupAddress copy] autorelease];
	newOrder.pickupLocation = order.pickupLocation;
	// Update KVO
	[order removeObserver:self forKeyPath:@"pickupTime"];
	[order removeObserver:self forKeyPath:@"pickupAddress"];
	[order removeObserver:self forKeyPath:@"passengersCount"];
	[newOrder addObserver:self forKeyPath:@"pickupTime" options:NSKeyValueObservingOptionNew context:NULL];
	[newOrder addObserver:self forKeyPath:@"pickupAddress" options:NSKeyValueObservingOptionNew context:NULL];
	[newOrder addObserver:self forKeyPath:@"passengersCount" options:NSKeyValueObservingOptionNew context:NULL];
	self.order = newOrder;
	order.pickupTime = [NSDate date];
	[newOrder release];
		
	[self presentModalViewController:orderViewController animated:YES];
	[orderViewController release];
}

- (IBAction)notesButtonAction:(id)sender {
	NotesViewController *notesViewController = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
	notesViewController.order = self.order;
	[self presentModalViewController:notesViewController animated:YES];
	[notesViewController release];
}

- (IBAction)timeButtonAction:(id)sender {
	// Lazily create the date picket view
	if (!datePickerView) {
		[[UIFactory newUIObjectFromNib:@"DatePicker" owner:self] autorelease];
		[self.view addSubview:datePickerView];
		CGRect frame = datePickerView.frame;
		frame.origin.y = self.view.frame.size.height;
		datePickerView.frame = frame;
	}
		
	// Configure the date picker.
	// Only allow dates at most 1 day in the future
	NSDate *nowDate = [NSDate date];
	NSDate *pickupTimeDate = order.pickupTime;
	datePicker.minimumDate = nowDate;
	datePicker.maximumDate = [nowDate addTimeInterval:60.0*60.0*24.0];
	datePicker.tempDate = pickupTimeDate;
	[datePicker setDate:pickupTimeDate animated:NO];
	
	// Disable GUI
	locateMeButton.enabled = NO;
	bookmarksButton.enabled = NO;
	notesButton.enabled = NO;
	pickupTimeButton.userInteractionEnabled = NO;
	addressTextField.enabled = NO;
	
	// Animate the appearance of the date picker
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	blackButton.alpha = 0.75;
	datePickerView.frame = CGRectOffset(datePickerView.frame, 0.0, -kDatePickerViewAnimationVerticalOffset);
	[UIView commitAnimations];
	
	datePickerVisible = YES;
}

- (IBAction)datePickerDoneButton:(id)sender {
	order.pickupTime = datePicker.date;
	
	[self hideDatePicker];
}

- (IBAction)datePickerCancelButton:(id)sender {	
	[self hideDatePicker];
}

- (void)hideDatePicker {
	datePickerVisible = NO;

	// Enable GUI
	locateMeButton.enabled = YES;
	bookmarksButton.enabled = YES;
	notesButton.enabled = YES;
	pickupTimeButton.userInteractionEnabled = YES;
	addressTextField.enabled = YES;
	
	// Animate the disappearance of the date picker
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	blackButton.alpha = 0.0;
	datePickerView.frame = CGRectOffset(datePickerView.frame, 0.0, kDatePickerViewAnimationVerticalOffset);
	[UIView commitAnimations];
}

- (IBAction)clearAddressTextField:(id)sender {
	addressTextField.text = @"";
}

- (IBAction)blackButtonAction:(id)sender {
	if ([addressTextField isFirstResponder]) {
		[addressTextField resignFirstResponder];
	} else if (datePickerVisible) {
		[self hideDatePicker];
	}
}

- (IBAction)datePickerDateChanged:(UIDatePicker *)theDatePicker {
	datePicker.tempDate = theDatePicker.date;
}

- (IBAction)addressTextFieldEditingDidBegin:(id)sender {	
	// Hide the bookmarks button
	bookmarksButton.hidden = YES;
	// Show the clear button
	clearButton.hidden = NO;
	// Disable the other buttons
	pickupTimeButton.enabled = NO;
	notesButton.enabled = NO;
	locateMeButton.enabled = NO;
	
	// Show the black button
	[UIView beginAnimations:@"ShowBlackLayer" context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	blackButton.alpha = 0.75;
	[UIView commitAnimations];
}

- (IBAction)addressTextFieldEditingDidEnd:(id)sender {
	if ([addressTextField.text isEqualToString:@""]) {
		[self refreshPickupAddress];
	} else {
		pickupLocationIsCurrentLocation = NO;
		
		// Start a geocoding query
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		Geocoder *geocoder = [Geocoder sharedGeocoder];
		geocoder.query = addressTextField.text;
		geocoder.delegate = self;
		[geocoder start];
	}
	
	// Show the bookmarks button
	bookmarksButton.hidden = NO;
	// Hide the clear button
	clearButton.hidden = YES;
	// Enable the other buttons
	pickupTimeButton.enabled = YES;
	notesButton.enabled = YES;
	locateMeButton.enabled = YES;
	
	// Hide the black button
	[UIView beginAnimations:@"HideBlackLayer" context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	blackButton.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)geocoder:(Geocoder *)theGeocoder didGetPlaces:(NSArray *)places {
	NSDictionary *place = [places objectAtIndex:0];
	order.pickupAddress = [place objectForKey:@"address"];
	[self setPickupLocationToLocation:[place objectForKey:@"location"]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)geocoderDidFail:(Geocoder *)theGeocoder {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self refreshPickupAddress];
	pickupLocationIsCurrentLocation = YES;
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"No results found.", @"Error message when an address geocoding fails.")
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
	[alertView show];
	[alertView release];
}

- (void)addToBookmarksButtonAction:(id)sender {
	AddBookmarkViewController *addBookmarkViewController = [[AddBookmarkViewController alloc] initWithNibName:@"AddBookmarkViewController"
																									   bundle:nil];
	addBookmarkViewController.pickupLocation = order.pickupLocation;
	[self presentModalViewController:addBookmarkViewController animated:YES];
	[addBookmarkViewController release];
}

- (IBAction)expandButtonAction:(id)sender {
	self.expanded = !self.expanded;
}

- (IBAction)infoButtonAction:(id)sender {
	BackNavigationController *backNavigationController = [UIFactory newUIObjectFromNib:@"BackNavigationController" owner:nil];
	backNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:backNavigationController animated:YES];
	[backNavigationController release];
}

- (void)didSelectSegment:(NSUInteger)segmentIndex {
	[[NSUserDefaults standardUserDefaults] setInteger:segmentIndex forKey:@"MapType"];
	
	mapView.mapType = segmentIndex;
}

- (IBAction)plusButtonAction:(id)sender {
	NSInteger passengersCount = order.passengersCount;
	if (passengersCount < 5) {
		order.passengersCount = passengersCount + 1;
	}
}

- (IBAction)minusButtonAction:(id)sender {
	NSInteger passengersCount = order.passengersCount;
	if (passengersCount > 1) {
		order.passengersCount = passengersCount - 1;
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
	settingsViewController.style = frontViewStyle;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[settingsViewController release];
		
	[self presentModalViewController:navigationController animated:YES];
	[navigationController release];
}

@end
