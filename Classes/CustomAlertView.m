//
//  CustomAlertView.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"


@implementation CustomAlertView

@synthesize alertType;

- (void)dealloc {
	// Model
	[alertType release];
	
	[super dealloc];
}

@end
