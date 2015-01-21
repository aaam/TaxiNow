//
//  CountryCodes.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountryCodes : NSObject {
	NSArray *countries;
}

+ (CountryCodes *)countryCodes;

- (NSString *)countryNameWithCountryCode:(NSInteger)countryCode;
- (NSString *)countryStringIDWithCountryCode:(NSInteger)countryCode;

@property (nonatomic, retain) NSArray *countries;

@end
