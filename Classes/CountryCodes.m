//
//  CountryCodes.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CountryCodes.h"

@implementation CountryCodes

@synthesize countries;

static CountryCodes *countryCodes = nil;

+ (CountryCodes *)countryCodes {
    if (countryCodes == nil) {
        countryCodes = [[super allocWithZone:NULL] init];
    }
    return countryCodes;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self countryCodes] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

- (void)dealloc {
	[countries release];
	
	[super dealloc];
}

- (id)init {
	if (self = [super init]) {
		self.countries = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCodes" ofType:@"plist"]];
		// Sort the countries by countryName
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CountryName" ascending:YES];
		self.countries = [countries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
	}
	return self;
}

- (NSString *)countryNameWithCountryCode:(NSInteger)countryCode {
	for (NSDictionary *countryDictionary in countries) {
		if ([[countryDictionary objectForKey:@"CountryCode"] integerValue] == countryCode) {
			return [countryDictionary objectForKey:@"CountryName"];
		}
	}
	return nil;
}

- (NSString *)countryStringIDWithCountryCode:(NSInteger)countryCode {
	for (NSDictionary *countryDictionary in countries) {
		if ([[countryDictionary objectForKey:@"CountryCode"] integerValue] == countryCode) {
			return [countryDictionary objectForKey:@"CountryStringID"];
		}
	}
	return nil;
}

@end
