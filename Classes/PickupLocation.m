//
//  PickupLocation.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PickupLocation.h"

@implementation PickupLocation

@synthesize coordinate;

- (NSString *)title {
	return NSLocalizedString(@"Drag Me!", @"Pick Up Location Pin's title");
}

- (NSString *)subtitle {
	return NSLocalizedString(@"Pick Up Location", @"Pick Up Location Pin's subtitle");
}

// NSCopying

- (id)copyWithZone:(NSZone *)zone {
	PickupLocation *pickupLocation = [[PickupLocation allocWithZone:zone] init];
	
	pickupLocation.coordinate = coordinate;
	
	return pickupLocation;
}

// NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = [decoder decodeDoubleForKey:@"latitude"];
	theCoordinate.longitude = [decoder decodeDoubleForKey:@"longitude"];
	self.coordinate = theCoordinate;
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeDouble:coordinate.latitude forKey:@"latitude"];
	[encoder encodeDouble:coordinate.longitude forKey:@"longitude"];
}

// Dictionary Serialization

- (id)initWithDictionary:(NSDictionary *)aDictionary {
	if (self = [self init]) {
		CLLocationCoordinate2D theCoordinate;
		theCoordinate.latitude = [[aDictionary objectForKey:@"latitude"] doubleValue];
		theCoordinate.longitude = [[aDictionary objectForKey:@"longitude"] doubleValue];
		self.coordinate = theCoordinate;
	}
	return self;
}

- (NSDictionary *)encode {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
	[dictionary setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
	return dictionary;
}

@end
