//
//  PinMaskView.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

// This is a class to make the pin respond immediatly to drag gestures
// The default behavior of annotation views in a mapview is to delay touches.
// We don't want that.

#import <Foundation/Foundation.h>
#import "YellowDraggablePin.h"
#import <MapKit/MapKit.h>

@interface PinMaskView : UIView {
	// View
	YellowDraggablePin *yellowDraggablePin;
	MKMapView *mapView;
}

@property (nonatomic, assign) YellowDraggablePin *yellowDraggablePin;
@property (nonatomic, assign) MKMapView *mapView;

@end
