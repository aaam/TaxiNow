//
//  Order.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Order.h"
#import "PickupLocation.h"

@implementation Order

@synthesize identifier;
@synthesize orderID;
@synthesize status;
@synthesize pickupTime;
@synthesize estimatedArrivalTime;
@synthesize notes;
@synthesize pickupAddress;
@synthesize pickupLocation;
@synthesize serviceByUrl;
@synthesize passengersCount;

- (id)init {
	if (self = [super init]) {
		identifier = floor([[NSDate date] timeIntervalSince1970]);
		self.status = OrderCreated;
		self.notes = @"";
		self.pickupAddress = [NSMutableDictionary dictionary];
		self.passengersCount = 1;
	}
	return self;
}

- (void)dealloc {
	[pickupTime release];
	[estimatedArrivalTime release];
	[notes release];
	[pickupAddress release];
	[pickupLocation release];
	[serviceByUrl release];
	
	[super dealloc];
}

// NSCopying

- (id)copyWithZone:(NSZone *)zone {
	Order *order = [[Order allocWithZone:zone] init];
	
	order.identifier = self.identifier;
	order.orderID = self.orderID;
	order.status = self.status;
	order.pickupTime = [[self.pickupTime copy] autorelease];
	order.estimatedArrivalTime = [[self.estimatedArrivalTime copy] autorelease];
	order.notes = self.notes;
	order.pickupAddress = self.pickupAddress;
	order.pickupLocation = [[self.pickupLocation copy] autorelease];
	order.serviceByUrl = [[self.serviceByUrl copy] autorelease];
	
	return order;
}

// NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	self.identifier = [decoder decodeIntegerForKey:@"identifier"];
	self.orderID = [decoder decodeIntegerForKey:@"orderID"];
	self.status = [decoder decodeIntegerForKey:@"status"];
	self.pickupTime = [decoder decodeObjectForKey:@"pickupTime"];
	self.estimatedArrivalTime = [decoder decodeObjectForKey:@"estimatedArrivalTime"];
	self.notes = [decoder decodeObjectForKey:@"notes"];
	self.pickupAddress = [decoder decodeObjectForKey:@"pickupAddress"];
	self.pickupLocation = [decoder decodeObjectForKey:@"pickupLocation"];
	self.serviceByUrl = [decoder decodeObjectForKey:@"serviceByUrl"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:identifier forKey:@"identifier"];
	[encoder encodeInteger:orderID forKey:@"orderID"];
	[encoder encodeInteger:status forKey:@"status"];
	[encoder encodeObject:pickupTime forKey:@"pickupTime"];
	[encoder encodeObject:estimatedArrivalTime forKey:@"estimatedArrivalTime"];
	[encoder encodeObject:notes forKey:@"notes"];
	[encoder encodeObject:pickupAddress forKey:@"pickupAddress"];
	[encoder encodeObject:pickupLocation forKey:@"pickupLocation"];
	[encoder encodeObject:serviceByUrl forKey:@"serviceByUrl"];
}

@end
