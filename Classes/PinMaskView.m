//
//  PinMaskView.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PinMaskView.h"

@implementation PinMaskView

@synthesize yellowDraggablePin;
@synthesize mapView;

- (void)dealloc {
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object change:(NSDictionary *)change
					   context:(void *)context {
	CGPoint convertedPoint = [mapView convertCoordinate:((MKAnnotationView *)object).annotation.coordinate
										  toPointToView:nil];
	convertedPoint.y -= 33.0;
	self.center = convertedPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[yellowDraggablePin touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[yellowDraggablePin touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[yellowDraggablePin touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[yellowDraggablePin touchesCancelled:touches withEvent:event];
}

@end
