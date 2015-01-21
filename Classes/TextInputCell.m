//
//  TextInputCell.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextInputCell.h"


@implementation TextInputCell

// View
@synthesize textField;

- (void)dealloc {
	[textField release];
	
	[super dealloc];
}

@end
