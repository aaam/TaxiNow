//
//  PhoneNumberView.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhoneNumberView.h"


@implementation PhoneNumberView

// View
@synthesize textField;
@synthesize button;

// Model
@dynamic phoneNumber;

- (NSString *)phoneNumber {
	return [NSString stringWithFormat:@"%@%@", button.titleLabel.text, textField.text];
}

- (void)dealloc {
	// View
	[textField release];
	[button release];
		
	[super dealloc];
}

@end
