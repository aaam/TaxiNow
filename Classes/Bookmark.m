//
//  Bookmark.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Bookmark.h"
#import "PickupLocation.h"

@implementation Bookmark

@synthesize name, pickupLocation;

- (id)initWithDictionary:(NSDictionary *)aDictionary {
	if (self = [self init]) {
		self.name = [aDictionary objectForKey:@"name"];
		self.pickupLocation = [[[PickupLocation alloc] initWithDictionary:[aDictionary objectForKey:@"pickupLocation"]] autorelease];
	}
	return self;
}

- (NSDictionary *)encode {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:name forKey:@"name"];
	[dictionary setObject:[pickupLocation encode] forKey:@"pickupLocation"];
	return dictionary;
}

- (void)dealloc {
	[name release];
	[pickupLocation release];
	
	[super dealloc];
}

@end
