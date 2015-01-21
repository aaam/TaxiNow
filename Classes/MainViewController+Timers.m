//
//  MainViewController+Timers.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 25/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController+Timers.h"
#import "Order.h"
#import "PickupLocation.h"

@implementation MainViewController (Timers)

- (void)resizeMapTimerAction:(NSTimer *)theTimer {
	#define kMinimumMapRegionRadius 131.0
	// Fit the map view to the current location
	CLLocation *location = [theTimer userInfo];
	CLLocationCoordinate2D coordinate = location.coordinate;
	CLLocationAccuracy accuracy = location.horizontalAccuracy;
	if (accuracy < kMinimumMapRegionRadius) {
		accuracy = kMinimumMapRegionRadius;
	}
	[mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, accuracy, accuracy) animated:YES];
	mapJustInitialized = NO;
}

- (void)addAnnotationTimerAction:(NSTimer *)theTimer {
	[mapView addAnnotation:order.pickupLocation];
}

- (void)pickupTimeTimerAction:(NSTimer *)theTimer {
	// If the pickup time is in the past, reset it to the present date.
	NSDate *todayDate = [NSDate date];
	if ([self.order.pickupTime compare:todayDate] == NSOrderedAscending) {
		// Reset pickupTime
		self.order.pickupTime = todayDate;
	}
}

@end
