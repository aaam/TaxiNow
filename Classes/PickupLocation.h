//
//  PickupLocation.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PickupLocation : NSObject <MKAnnotation, NSCopying, NSCoding> {
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)encode;

@end
