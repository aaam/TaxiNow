//
//  Geocoder.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 13/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GeocoderDelegate;

@interface Geocoder : NSObject {
	// Model
	NSString *query; // Address
	
	// Other
	id <GeocoderDelegate> delegate;
}

// Model
@property (nonatomic, copy) NSString *query;

// Other
@property (nonatomic, assign) id <GeocoderDelegate> delegate;

+ (Geocoder*)sharedGeocoder;
- (void)start;

@end

@protocol GeocoderDelegate

// places is an array of dictionaries containing the following two keys:
//   address: a dictionary containing the Address Book keys and values for the place.
//   location: a CLLocation object
- (void)geocoder:(Geocoder *)theGeocoder didGetPlaces:(NSArray *)places;
- (void)geocoderDidFail:(Geocoder *)theGeocoder;

@end
