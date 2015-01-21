//
//  YellowDraggablePin.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YellowDraggablePin.h"
#import "PickupLocation.h"


@implementation YellowDraggablePin

#define kPinVerticalOffset 50.0
#define kPinShadowOffset 34.0

// View
@synthesize pinImage, pinAir, pinShadow;
@synthesize mapView;

// Other
@synthesize delegate;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
		self.frame = CGRectMake(0.0, 0.0, 15.0, 40.0);
		self.centerOffset = CGPointMake(0.0, -15.0);
				
		pinShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PinShadow.png"]];
		pinShadow.frame = CGRectOffset(pinShadow.frame, 3.0, 12.0);
		[self addSubview:pinShadow];
		
		pinAir = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PinAir.png"]];
		[self addSubview:pinAir];
		pinAir.hidden = YES;
		
		pinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pin.png"]];
		[self addSubview:pinImage];
				
		self.multipleTouchEnabled = NO;
		isFirstMove = YES;
		
		// Initialize variables 
		touchesEnded = YES;
		animationEnded = YES;
		
		// Add right disclosure view
		self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
	}
	return self;
}

- (void)dealloc {
	[pinImage release]; [pinAir release]; [pinShadow release];
	
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(touchesEnded && animationEnded)) {
		return;
	}
	
	touchesEnded = NO;
	animationEnded = NO;
	NSLog(@"touches began");
	
    // The view is configured for single touches only.
    UITouch *aTouch = [touches anyObject];
    startLocation = [aTouch locationInView:[self superview]];
	touchLocation = [aTouch locationInView:self];
    originalCenter = self.center;
		
    [super touchesBegan:touches withEvent:event];	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(!touchesEnded && !animationEnded)) {
		return;
	}
	
    UITouch *aTouch = [touches anyObject];
    CGPoint newLocation = [aTouch locationInView:[self superview]];
	
    // If the user's finger moved more than 5 pixels, begin the drag.
    if ((abs(newLocation.x - startLocation.x) > 5.0) ||
		(abs(newLocation.y - startLocation.y) > 5.0)) {
		isMoving = YES;
	}
	
    // If dragging has begun, adjust the position of the view.
    if (isMoving) {
		CGPoint newCenter;
        newCenter.x = originalCenter.x + (newLocation.x - startLocation.x);
        newCenter.y = originalCenter.y + (newLocation.y - startLocation.y);
        self.center = newCenter;
		
		// Hack to hide the callout
		self.canShowCallout = NO;
		[mapView deselectAnnotation:self.annotation animated:NO];
		
		if (isFirstMove) {
			NSLog(@"first move");

			isFirstMove = NO;
			
			// Animate the pin and the shadow
			pinImage.hidden = YES;
			pinAir.hidden = NO;
			[UIView beginAnimations:nil context:NULL];
			pinAir.frame = CGRectOffset(pinAir.frame, 0.0, -kPinVerticalOffset - (CGRectGetHeight(self.frame) - touchLocation.y));
			pinShadow.frame = CGRectOffset(pinShadow.frame, kPinShadowOffset, -kPinShadowOffset - kPinVerticalOffset - (CGRectGetHeight(self.frame) - touchLocation.y));
			[UIView commitAnimations];
			
			// In order to avoid the touches to fall outside the view while dragging,
			// resize the view			
			//self.frame = CGRectInset(self.frame, -50.0, -50.0);
			//self.bounds = CGRectOffset(self.bounds, -50.0, -50.0);
			
			[delegate didStartDragging];
		}
    } else { // Let the parent class handle it.
        [super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(!touchesEnded && !animationEnded)) {
		return;
	}
	
	touchesEnded = YES;
	
    if (isMoving) {
		NSLog(@"touches ended");

		// Reset the frame and bounds of the view		
		//self.frame = CGRectInset(self.frame, 50.0, 50.0);
		//self.bounds = CGRectOffset(self.bounds, 50.0, 50.0);		
		
		// Update the map coordinate to reflect the new position.
        CGPoint newCenter = self.center;
		newCenter.y -= self.centerOffset.y;
		newCenter.y -= kPinVerticalOffset + (CGRectGetHeight(self.frame) - touchLocation.y);
		
		pinAir.frame = CGRectOffset(pinAir.frame, 0.0, kPinVerticalOffset + (CGRectGetHeight(self.frame) - touchLocation.y));
		pinShadow.frame = CGRectOffset(pinShadow.frame, 0.0, kPinVerticalOffset + (CGRectGetHeight(self.frame) - touchLocation.y));

        CLLocationCoordinate2D newCoordinate = [mapView convertPoint:newCenter
												toCoordinateFromView:self.superview];
        ((PickupLocation *)self.annotation).coordinate = newCoordinate;
		
		// Animate the pin and the shadow
		[UIView beginAnimations:@"PinFallingUp" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		pinAir.frame = CGRectOffset(pinAir.frame, 0.0, -kPinVerticalOffset);
		[UIView commitAnimations];
		
		[UIView beginAnimations:@"PinShadowGoingUp" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationDuration:0.25];
		pinShadow.frame = CGRectOffset(pinShadow.frame, 0.5*kPinShadowOffset, -kPinShadowOffset);
		[UIView commitAnimations];
		
        // Clean up
        isMoving = NO;
		isFirstMove = YES;
		self.canShowCallout = YES;
		[mapView deselectAnnotation:self.annotation animated:NO];
		
		[delegate didFinishDragging:self.annotation.coordinate];
    } else {
		animationEnded = YES;
		[super touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(!touchesEnded && !animationEnded)) {
		return;
	}
	
	touchesEnded = YES;
	animationEnded = YES;
	
    if (isMoving) {		
        // Move the view back to its starting point.
        self.center = originalCenter;
		
		// Restore the pin and shadow positions
		pinImage.hidden = NO;
		pinAir.hidden = YES;
		pinAir.frame = CGRectOffset(pinAir.frame, 0.0, kPinVerticalOffset + (CGRectGetHeight(self.frame) - touchLocation.y));
		
        // Clean up
        isMoving = NO;
		isFirstMove = YES;
		self.canShowCallout = YES;
		[mapView deselectAnnotation:self.annotation animated:NO];
    } else {
        [super touchesCancelled:touches withEvent:event];
	}
}

// UIViewAnimationDelegate

- (void)animationDidStop:(NSString *)animationID
				finished:(NSNumber *)finished
				 context:(void *)context {
	if ([animationID isEqualToString:@"PinFallingUp"]) {
		NSLog(@"A");
		[UIView beginAnimations:@"PinFallingDown" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		pinAir.frame = CGRectOffset(pinAir.frame, 0.0, kPinVerticalOffset);
		[UIView commitAnimations];	
	} else if ([animationID isEqualToString:@"PinFallingDown"]) {
		NSLog(@"B");

		pinImage.hidden = NO;
		pinAir.hidden = YES;

		[UIView beginAnimations:@"PinSpearingDown" context:NULL];
		[UIView setAnimationDuration:0.05];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		pinImage.frame = CGRectOffset(pinImage.frame, 0.0, 2);
		[UIView commitAnimations];	
	} else if ([animationID isEqualToString:@"PinSpearingDown"]) {
		NSLog(@"C");

		[UIView beginAnimations:@"FinalAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.05];
		pinImage.frame = CGRectOffset(pinImage.frame, 0.0, -2);
		[UIView commitAnimations];	
	} else if ([animationID isEqualToString:@"PinShadowGoingUp"]) {
		NSLog(@"D");

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.20];
		pinShadow.frame = CGRectOffset(pinShadow.frame, -1.5 * kPinShadowOffset, 2.0 * kPinShadowOffset);
		[UIView commitAnimations];		
	} else if ([animationID isEqualToString:@"FinalAnimation"]) {
		animationEnded = YES;
	}
}

@end
