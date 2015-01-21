//
//  MainViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "YellowDraggablePin.h"

#define kAnimationDuration 0.3
#define kDatePickerViewAnimationVerticalOffset 260.0

@class PickupLocation;
@class Order;
@class PickupTimeButton;
@class CustomSegmentedControl;
@class PinMaskView;
@class CustomDatePicker;

@interface MainViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, MKReverseGeocoderDelegate, YellowDraggablePinDelegate> {
	// View
	UIButton *blackButton;
	UIButton *locateMeButton, *bookmarksButton, *clearButton;
	UITextField *addressTextField;
	PickupTimeButton *pickupTimeButton;
	MKMapView *mapView;
	UIView *footerView;
	UIButton *taxiButton;
	UIView *datePickerView;
	CustomDatePicker *datePicker;
	UIView *optionsView;
	UIImageView *optionsArrow;
	CustomSegmentedControl *mapTypeSegmentedControl;
	UIButton *infoButton;
	PinMaskView *pinMaskView;
	UIButton *plusButton, *minusButton, *notesButton;
	UIView *optionControls;
	UILabel *passengersCountLabel;
	
	// Model
	CLLocation *lastUserLocation;
	BOOL mapJustInitialized;
	BOOL pickupLocationIsCurrentLocation;
	Order *order;
	BOOL expanded;
	BOOL datePickerVisible;
	
	// Other
	MKReverseGeocoder *reverseGeocoder;
	NSTimer *pickupTimeTimer;
}

// View
@property (nonatomic, retain) IBOutlet UIButton *blackButton;
@property (nonatomic, retain) IBOutlet UIButton *locateMeButton, *bookmarksButton, *clearButton;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet PickupTimeButton *pickupTimeButton;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) UIButton *taxiButton;
@property (nonatomic, retain) IBOutlet UIView *datePickerView;
@property (nonatomic, retain) IBOutlet CustomDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIView *optionsView;
@property (nonatomic, retain) IBOutlet UIImageView *optionsArrow;
@property (nonatomic, retain) IBOutlet CustomSegmentedControl *mapTypeSegmentedControl;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet PinMaskView *pinMaskView;
@property (nonatomic, retain) IBOutlet UIButton *plusButton, *minusButton, *notesButton;
@property (nonatomic, retain) IBOutlet UIView *optionControls;
@property (nonatomic, retain) IBOutlet UILabel *passengersCountLabel;

// Model
@property (nonatomic, retain) CLLocation *lastUserLocation;
@property (nonatomic, retain) Order *order;
@property (nonatomic, assign) BOOL pickupLocationIsCurrentLocation;
@property (nonatomic, assign) BOOL expanded;

// Other
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) NSTimer *pickupTimeTimer;

- (void)initMap;
- (void)setPickupLocationToLocation:(CLLocation *)aLocation;
- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)aCoordinate;

@end
