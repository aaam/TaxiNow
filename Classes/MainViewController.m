//
//  MainViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "UIFactory.h"
#import "Order.h"
#import "PickupLocation.h"
#import "OrderViewController.h"
#import "PickupTimeButton.h"
#import "CustomSegmentedControl.h"
#import "PinMaskView.h"
#import <AddressBook/AddressBook.h>

@interface MainViewController (PrivateMethods)

- (void)createTaxiButton;

@end

@implementation MainViewController

// View
@synthesize blackButton;
@synthesize locateMeButton, bookmarksButton, clearButton;
@synthesize addressTextField;
@synthesize pickupTimeButton;
@synthesize mapView;
@synthesize footerView;
@synthesize taxiButton;
@synthesize datePickerView;
@synthesize datePicker;
@synthesize optionsView;
@synthesize optionsArrow;
@synthesize mapTypeSegmentedControl;
@synthesize infoButton;
@synthesize pinMaskView;
@synthesize plusButton, minusButton, notesButton;
@synthesize optionControls;
@synthesize passengersCountLabel;

// Model
@synthesize lastUserLocation;
@synthesize order;
@synthesize pickupLocationIsCurrentLocation;
@synthesize expanded;

// Other
@synthesize reverseGeocoder;
@synthesize pickupTimeTimer;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// At the beginning the pickup location is the current location
	pickupLocationIsCurrentLocation = YES;
	
	// Create the order
	self.order = [[[Order alloc] init] autorelease];
	
	// Enlarge the infoButton hit mask
	CGRect frame = infoButton.frame;
	infoButton.frame = CGRectMake(CGRectGetMinX(frame) - 13.0, CGRectGetMinY(frame) - 13.0, CGRectGetWidth(frame) + 26.0, CGRectGetHeight(frame) + 26.0);	
	
	// Register for location updates
	[mapView.userLocation addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:NULL];
	// Set the map type according to the user's defaults
	MKMapType mapType = [userDefaults integerForKey:@"MapType"];
	mapView.mapType = mapType;
	[mapTypeSegmentedControl setSelectedSegment:mapType];
	
	// Register for pickupTime changes in order to update the GUI
	[order addObserver:self forKeyPath:@"pickupTime" options:NSKeyValueObservingOptionNew context:NULL];
	order.pickupTime = [NSDate date];
	
	// Register for pickupAddress changes in order to update the GUI
	[order addObserver:self forKeyPath:@"pickupAddress" options:NSKeyValueObservingOptionNew context:NULL];

	// Register for passengersCount changes in order to update the GUI
	[order addObserver:self forKeyPath:@"passengersCount" options:NSKeyValueObservingOptionNew context:NULL];

	// Run a timer to constantly update the pickup time
	self.pickupTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
															target:self
														  selector:@selector(pickupTimeTimerAction:)
														  userInfo:nil
														   repeats:YES];
	
	// Initialize the map
	[self initMap];
	
	// Create the button for ordering the taxi
	[self createTaxiButton];
	
//	if (![userDefaults stringForKey:@"FullName"]) {
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What is your name?", @"Error message title")
//															message:NSLocalizedString(@"In order to be able to place orders, TaxiNow! needs to know your full name. Do you want to enter it now?", @"Error message")
//														   delegate:nil
//												  cancelButtonTitle:nil
//												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
//		[alertView show];
//		[alertView release];		
//	}
}

- (void)viewDidAppear:(BOOL)animated {	
	[super viewDidAppear:animated];
	
	// Check if there's already an order pending
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *orderPath = [documentsDirectory stringByAppendingPathComponent:@"order.obj"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:orderPath]) {
		Order *savedOrder = [NSKeyedUnarchiver unarchiveObjectWithFile:orderPath];
		NSDate *now = [NSDate date];
		if ([savedOrder.pickupTime compare:now] == NSOrderedDescending ||
			[savedOrder.estimatedArrivalTime compare:now] == NSOrderedDescending ||
			(savedOrder.estimatedArrivalTime == nil &&
			 [(NSDate *)[savedOrder.pickupTime addTimeInterval:60*60] compare:now] == NSOrderedDescending)) {			
			OrderViewController *orderViewController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
			orderViewController.order = savedOrder;
			[self presentModalViewController:orderViewController animated:NO];
			[orderViewController release];
		}
	}
}

- (void)dealloc {
	// View
	[blackButton release];
	[locateMeButton release]; [bookmarksButton release]; [clearButton release];
	[addressTextField release];
	[pickupTimeButton release];
	[mapView release];
	[footerView release];
	[taxiButton release];
	[datePickerView release];
	[datePicker release];
	[optionsView release];
	[optionsArrow release];
	[mapTypeSegmentedControl release];
	[infoButton release];
	[pinMaskView release];
	[plusButton release];
	[minusButton release];
	[notesButton release];
	[optionControls release];
	[passengersCountLabel release];
	
	// Model
	[lastUserLocation release];
	
	// Other
	[reverseGeocoder release];
	[pickupTimeTimer release];
	
    [super dealloc];
}

- (void)createTaxiButton {
	#define kSaveButtonMinX 10.0
	#define kSaveButtonMinY 6.0
	#define kSaveButtonWidth 300.0
	#define kSaveButtonHeight 46.0
	CGRect frame = CGRectMake(kSaveButtonMinX, kSaveButtonMinY, kSaveButtonWidth, kSaveButtonHeight);
	UIImage *image = [UIImage imageNamed:@"WhiteButton.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"WhiteButtonPressed.png"];
	self.taxiButton = [[UIFactory newButtonWithTitle:NSLocalizedString(@"Order Taxi", @"Order Button's text")
										target:self
									  selector:@selector(taxiButtonAction:)
										 frame:frame
										 image:image
								  imagePressed:imagePressed] autorelease];
	[footerView addSubview:taxiButton];
}

- (void)initMap {
	mapJustInitialized = YES;
	CLLocationCoordinate2D europeCoordinate;
	europeCoordinate.latitude = 47.0;
	europeCoordinate.longitude = 15.0;
	//europeCoordinate.latitude = 47.0;
	//europeCoordinate.longitude = -95.0;
	[mapView setRegion:MKCoordinateRegionMake(europeCoordinate, MKCoordinateSpanMake(100.0,100.0))];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[addressTextField resignFirstResponder];
	
	return YES;
}

// MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
	YellowDraggablePin *yellowView = (YellowDraggablePin *)
									 [theMapView dequeueReusableAnnotationViewWithIdentifier:@"YellowDraggablePin"];
	
	if (yellowView == nil) {
		yellowView =
			[[[YellowDraggablePin alloc] initWithAnnotation:order.pickupLocation
											 reuseIdentifier:@"YellowDraggablePin"] autorelease];
		yellowView.canShowCallout = YES;
		yellowView.mapView = mapView;
		yellowView.delegate = self;
		[((UIButton *)yellowView.rightCalloutAccessoryView) addTarget:self
															   action:@selector(addToBookmarksButtonAction:)
													 forControlEvents:UIControlEventTouchUpInside];
		// Configure the pinmark
		pinMaskView.yellowDraggablePin = yellowView;
		pinMaskView.mapView = mapView;
		[yellowView addObserver:pinMaskView forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:NULL];
	} else {
		yellowView.annotation = order.pickupLocation;
	}
	
	return yellowView;
}

- (void)mapView:(MKMapView *)theMapView didAddAnnotationViews:(NSArray *)views {
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
		annotationView.enabled = NO;
	} else { // Pickup location
		[theMapView selectAnnotation:order.pickupLocation animated:YES];
	}
}

// YellowDraggablePinDelegate

- (void)didStartDragging {
	pickupLocationIsCurrentLocation = NO;
}

- (void)didFinishDragging:(CLLocationCoordinate2D)aCoordinate {
	// Reverse geocode the pin location
	[self reverseGeocodeCoordinate:aCoordinate];
}

// MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Add the country code to the dictionary
	NSMutableDictionary *dictionary = [placemark.addressDictionary mutableCopy];
	[dictionary setObject:placemark.countryCode forKey:@"CountryCode"];

	order.pickupAddress = dictionary;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"MKReverseGeocoder did fail with error: %@", error);
}

// Setters

- (void)setExpanded:(BOOL)isExpanded {
	// Lazily load the optionControls
	if (!notesButton) {
		[[UIFactory newUIObjectFromNib:@"OptionControls" owner:self] autorelease];
		[optionsView addSubview:optionControls];
		
		// Initialize the controls values
		[mapTypeSegmentedControl setSelectedSegment:mapView.mapType];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		pickupTimeButton.pickupTimeLabel.text = [dateFormatter stringFromDate:order.pickupTime];
		[dateFormatter release];		
	}
	
	[UIView beginAnimations:nil context:NULL];
	optionsView.frame = CGRectOffset(optionsView.frame, 0.0, (isExpanded ? 1 : -1) * 131.0);
	optionsArrow.image = isExpanded ? [UIImage imageNamed:@"CustomUpArrow.png"] : [UIImage imageNamed:@"CustomDownArrow.png"];
	plusButton.enabled = isExpanded;
	minusButton.enabled = isExpanded;
	notesButton.enabled = isExpanded;
	pickupTimeButton.enabled = isExpanded;
	[UIView commitAnimations];
	
	expanded = isExpanded;
}

- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)aCoordinate {
	if (reverseGeocoder != nil) {
		[reverseGeocoder cancel];
		self.reverseGeocoder = nil;
	}
	
	if (reverseGeocoder == nil) {
		self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:aCoordinate] autorelease];
		self.reverseGeocoder.delegate = self;
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[reverseGeocoder start];
}

// Private Methods

- (void)setPickupLocationToLocation:(CLLocation *)aLocation {
	// Update the last user location
	self.lastUserLocation = aLocation;
	
	// Fit the map view to the current location
	NSTimer *timer = [NSTimer timerWithTimeInterval:0.0
											 target:self
										   selector:@selector(resizeMapTimerAction:)
										   userInfo:aLocation
											repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	
	// If a pickup location does not exist already, create it
	if (order.pickupLocation == nil) {
		order.pickupLocation = [[[PickupLocation alloc] init] autorelease];
		// If we add the annotation right away the blue dot animation is cancelled.
		// Therefore we add it using a timer after a certain delay.

		NSTimer *timer = [NSTimer timerWithTimeInterval:0.0
												 target:self
											   selector:@selector(addAnnotationTimerAction:)
											   userInfo:nil
												repeats:NO];		
		[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	// Update the coordinate of the pickup location
	order.pickupLocation.coordinate = aLocation.coordinate;
}


@end
