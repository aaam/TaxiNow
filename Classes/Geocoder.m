//
//  Geocoder.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 13/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Geocoder.h"
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "NSDictionary+DeepObjectForKey.h"

@interface Geocoder (PrivateMethods)

- (void)_start;

@end


@implementation Geocoder

// Model
@synthesize query;

// View
@synthesize delegate;

static Geocoder *sharedGeocoder = nil;

+ (Geocoder*)sharedGeocoder {
    @synchronized(self) {
        if (sharedGeocoder == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedGeocoder;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedGeocoder == nil) {
            sharedGeocoder = [super allocWithZone:zone];
            return sharedGeocoder;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

- (void)dealloc {
	[query release];
	
	[super dealloc];
}

- (void)start {
	// Asynchronously run the query
	[self performSelectorInBackground:@selector(_start) withObject:nil];
}

// Private Methods

- (void)_start {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *path = [NSMutableString string];
	[path appendFormat:@"/maps/geo?q=%@&key=%@&sensor=true&output=json", query,
	 @"ABQIAAAAtgfuViG4uBAFutuzkmFwGhR8kfN_d00SCBTER5AokbSf__uhnBTLmKTq9Z3Mjn60QDBpPMtwwGDyew&oe=utf8"];
	
	NSURL *queryUrl = [[NSURL alloc] initWithScheme:@"http"
											   host:@"maps.google.com"
											   path:path];
	
	NSString *resultsString = [NSString stringWithContentsOfURL:queryUrl
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	NSDictionary *jsonValue = [resultsString JSONValue];
		
	NSInteger code = [[[jsonValue objectForKey:@"Status"] objectForKey:@"code"] integerValue];
	if (code == 200) {
		NSMutableArray *newPlaces = [NSMutableArray array];
		
		NSArray *readPlaces = [jsonValue objectForKey:@"Placemark"];
		for (NSDictionary *readPlace in readPlaces) {
			NSString *countryName = [readPlace deepObjectForKey:@"CountryName"];
			NSString *countryCode = [readPlace deepObjectForKey:@"CountryNameCode"];
			NSString *localityName = [readPlace deepObjectForKey:@"LocalityName"];
			NSNumber *postalCodeNumber = [readPlace deepObjectForKey:@"PostalCodeNumber"];
			NSString *thoroughfareName = [readPlace deepObjectForKey:@"ThoroughfareName"];
			NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
			if (countryName) {
				[addressDictionary setObject:countryName forKey:(NSString *)kABPersonAddressCountryKey];
			}
			if (countryCode) {
				[addressDictionary setObject:countryCode forKey:@"CountryCode"];
			}
			if (localityName) {
				[addressDictionary setObject:localityName forKey:(NSString *)kABPersonAddressCityKey];
			}
			if (postalCodeNumber) {
				[addressDictionary setObject:postalCodeNumber forKey:(NSString *)kABPersonAddressZIPKey];
			}
			if (thoroughfareName) {
				[addressDictionary setObject:thoroughfareName forKey:(NSString *)kABPersonAddressStreetKey];
			}
			
			NSMutableDictionary *newPlace = [NSMutableDictionary dictionary];
			[newPlace setObject:addressDictionary forKey:@"address"];
			NSArray *coordinatesArray = [[readPlace objectForKey:@"Point"] objectForKey:@"coordinates"];
			CLLocationCoordinate2D coordinate2d;
			coordinate2d.longitude = [[coordinatesArray objectAtIndex:0] doubleValue];
			coordinate2d.latitude = [[coordinatesArray objectAtIndex:1] doubleValue];
			CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate2d
																 altitude:0.0
													   horizontalAccuracy:0.0
														 verticalAccuracy:0.0
																timestamp:[NSDate date]];
			[newPlace setObject:location forKey:@"location"];
			[newPlaces addObject:newPlace];
			[location release];
		}
		[delegate geocoder:self didGetPlaces:newPlaces];
	} else {
		[delegate geocoderDidFail:self];
	}
	
	[queryUrl release];
	
	[pool release];
}



@end
