//
//  CLLocationManager+Hack.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#if TARGET_IPHONE_SIMULATOR
//#import "CLLocationManager+Hack.h"
//
//
//@implementation CLLocationManager (Hack)

//- (void)startUpdatingLocation {
//	[self performSelector:@selector(sendLocationUpdate) withObject:nil afterDelay:0.5];
//}
//
//- (void)sendLocationUpdate {
//	CLLocationCoordinate2D coordinate;
//	// Miland
//	coordinate.latitude = 45.476431;
//	coordinate.longitude = 9.171513;
//	
//	// Hollywood
////	coordinate.latitude = 40.748062;
////	coordinate.longitude = -73.985608;
//	
//	CLLocation *theLocationn = [[CLLocation alloc] initWithCoordinate:coordinate altitude:100.0 horizontalAccuracy:30 verticalAccuracy:50.0 timestamp:[NSDate date]];
//	[self.delegate locationManager:self didUpdateToLocation:theLocationn fromLocation:nil usingSupportInfo:nil];
//
//}

//@end
//#endif