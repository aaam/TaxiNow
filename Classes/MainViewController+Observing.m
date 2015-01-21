//
//  MainViewController+Observing.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 28/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController+Observing.h"
#import "Order.h"
#import <AddressBook/AddressBook.h>
#import "PickupTimeButton.h"

@interface MainViewController (PrivateMethods)

- (void)refreshPickupAddress;

@end

@implementation MainViewController (Observing)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {	
	if (object == mapView.userLocation && [keyPath isEqualToString:@"location"]) {
		// If the pick up location shouldn't be the current location, just return
		if (!pickupLocationIsCurrentLocation) {
			return;
		}
		
		CLLocation *location = [change valueForKey:NSKeyValueChangeNewKey];
		// Ignore the update if location is null
		if ([location isKindOfClass:[NSNull class]]) {
			return;
		}
		CLLocationCoordinate2D locationCoordinate2D = location.coordinate;
		CLLocationCoordinate2D lastUserCoordinate2D = lastUserLocation.coordinate;
		
		// If the blue dot actually moved (or it is the first time it is shown)
		if (lastUserLocation == nil ||
			(lastUserCoordinate2D.longitude != locationCoordinate2D.longitude ||
			 lastUserCoordinate2D.latitude != locationCoordinate2D.latitude)) {
			
			[self setPickupLocationToLocation:location];
			// Reverse geocode the user location
			[self reverseGeocodeCoordinate:location.coordinate];
		}
	} else if (object == order) {
		if ([keyPath isEqualToString:@"pickupTime"]) {
			// Update GUI
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle:NSDateFormatterLongStyle];
			[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
			pickupTimeButton.pickupTimeLabel.text = [dateFormatter stringFromDate:order.pickupTime];
			[dateFormatter release];
		} else if ([keyPath isEqualToString:@"pickupAddress"]) {
			if (![addressTextField isFirstResponder]) {
				// Update GUI
				[self refreshPickupAddress];
			}
		} else if ([keyPath isEqualToString:@"passengersCount"]) {
			// Update GUI
			NSInteger passengersCount = order.passengersCount;
			passengersCountLabel.text = [NSString stringWithFormat:@"%d %@", passengersCount,
										 passengersCount == 1 ? NSLocalizedString(@"Passenger", @"Label's text") :
										 NSLocalizedString(@"Passengers", @"Label's text")];
		}
	}
}

// UtilityMethods

- (void)refreshPickupAddress {
	NSDictionary *pickupAddress = order.pickupAddress;
	
	NSString *street = [pickupAddress objectForKey:(NSString *)kABPersonAddressStreetKey];
	NSString *zip = [pickupAddress objectForKey:(NSString *)kABPersonAddressZIPKey];
	NSString *city = [pickupAddress objectForKey:(NSString *)kABPersonAddressCityKey];
	NSString *country = [pickupAddress objectForKey:(NSString *)kABPersonAddressCountryKey];
	
	NSMutableString *address = [NSMutableString string];
	
	if (street) {
		[address appendString:street];
	}
	
	if (zip) {
		if (![address isEqualToString:@""]) {
			[address appendString:@", "];
		}
		[address appendString:zip];
	}
	if (city) {
		if (![address isEqualToString:@""]) {
			[address appendString:@" "];
		}
		[address appendString:city];
	}
	if (country) {
		if (![address isEqualToString:@""]) {
			[address appendString:@", "];
		}
		[address appendString:country];
	}
	
	addressTextField.text = address;
}

@end
