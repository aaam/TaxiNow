//
//  PickupTimeButton.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PickupTimeButton.h"


@implementation PickupTimeButton

// View
@synthesize pickupTimeTextLabel, pickupTimeLabel;

- (void)dealloc {
	[pickupTimeTextLabel release]; [pickupTimeLabel release];
	
	[super dealloc];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	UIColor *whiteColor = [UIColor whiteColor];
	UIColor *darkShadow = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	CGSize shadowOffset = CGSizeMake(0.0, -1.0);
	
	pickupTimeTextLabel.textColor = whiteColor;
	pickupTimeTextLabel.shadowColor = darkShadow;
	pickupTimeTextLabel.shadowOffset = shadowOffset;
	
	pickupTimeLabel.textColor = whiteColor;
	pickupTimeLabel.shadowColor = darkShadow;
	pickupTimeLabel.shadowOffset = shadowOffset;
	
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	UIColor *customBlue = [UIColor colorWithRed:63.0/255.0 green:92.0/255.0 blue:132.0/255.0 alpha:1.0];
	UIColor *brightShadow = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	CGSize shadowOffset = CGSizeMake(0.0, 1.0);
	
	pickupTimeTextLabel.textColor = customBlue;
	pickupTimeTextLabel.shadowColor = brightShadow;
	pickupTimeTextLabel.shadowOffset = shadowOffset;
	
	pickupTimeLabel.textColor = customBlue;
	pickupTimeLabel.shadowColor = brightShadow;
	pickupTimeLabel.shadowOffset = shadowOffset;
	
	[super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	UIColor *customBlue = [UIColor colorWithRed:63.0/255.0 green:92.0/255.0 blue:132.0/255.0 alpha:1.0];
	UIColor *brightShadow = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	CGSize shadowOffset = CGSizeMake(0.0, 1.0);
	
	pickupTimeTextLabel.textColor = customBlue;
	pickupTimeTextLabel.shadowColor = brightShadow;
	pickupTimeTextLabel.shadowOffset = shadowOffset;
	
	pickupTimeLabel.textColor = customBlue;
	pickupTimeLabel.shadowColor = brightShadow;
	pickupTimeLabel.shadowOffset = shadowOffset;
	
	[super cancelTrackingWithEvent:event];
}

@end
