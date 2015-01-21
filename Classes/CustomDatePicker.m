//
//  CustomDatePicker.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 31/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomDatePicker.h"


@implementation CustomDatePicker

@synthesize tempDate;

- (void)dealloc {
	[tempDate release];
	
	[super dealloc];
}

@end
