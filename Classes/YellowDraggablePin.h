//
//  YellowDraggablePin.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol YellowDraggablePinDelegate

- (void)didStartDragging;
- (void)didFinishDragging:(CLLocationCoordinate2D)aCoordinate;

@end


@interface YellowDraggablePin : MKAnnotationView {
	// View
	UIImageView *pinImage, *pinAir, *pinShadow;
	MKMapView *mapView;
	
	// Model
	BOOL isMoving;
	CGPoint startLocation;
	CGPoint touchLocation;
	CGPoint originalCenter;
	BOOL isFirstMove;
	BOOL touchesEnded;
	BOOL animationEnded;
	
	// Other
	id <YellowDraggablePinDelegate> delegate;
}

// View
@property (nonatomic, retain) UIImageView *pinImage, *pinAir, *pinShadow;
@property (nonatomic, assign) MKMapView *mapView;

// Other
@property (nonatomic, assign) id <YellowDraggablePinDelegate> delegate;

@end
