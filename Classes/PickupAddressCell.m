//
//  PickupAddressCell.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 29/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PickupAddressCell.h"
#import <AddressBook/AddressBook.h>

@implementation PickupAddressCell

// Model
@synthesize pickupAddress;

- (void)dealloc {	
	// Model
	[pickupAddress release];
	
	[super dealloc];
}

// Getters and Setters

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.textLabel.text = NSLocalizedString(@"Address", @"Pickup Address cell's text");
		self.detailTextLabel.numberOfLines = 3;
	}
	return self;
}

- (void)setPickupAddress:(NSDictionary *)aDictionary {
	NSDictionary *tempPickupAddress = pickupAddress;
	pickupAddress = [aDictionary retain];
	[tempPickupAddress release];
	
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
			[address appendString:@"\n"];
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
			[address appendString:@"\n"];
		}
		[address appendString:country];
	}
	
	self.detailTextLabel.text = address;
}

@end
