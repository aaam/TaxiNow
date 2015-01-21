//
//  Order.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
	OrderCreated,
	SendingOrder,
	OrderSent,
	CancellingOrder
} OrderStatus;

@class PickupLocation;

@interface Order : NSObject <NSCopying, NSCoding> {
	NSInteger identifier; // Only used locally
	NSInteger orderID; // Used for server communication
	OrderStatus status;
	NSDate *pickupTime;
	NSDate *estimatedArrivalTime;
	NSString *notes;
	NSMutableDictionary *pickupAddress;
	PickupLocation *pickupLocation;
	NSURL *serviceByUrl;
	NSInteger passengersCount;
}

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger orderID;
@property (nonatomic, assign) OrderStatus status;
@property (nonatomic, retain) NSDate *pickupTime;
@property (nonatomic, retain) NSDate *estimatedArrivalTime;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, retain) NSMutableDictionary *pickupAddress;
@property (nonatomic, retain) PickupLocation *pickupLocation;
@property (nonatomic, retain) NSURL *serviceByUrl;
@property (nonatomic, assign) NSInteger passengersCount;

@end
