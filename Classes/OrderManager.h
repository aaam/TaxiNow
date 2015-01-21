//
//  OrderManager.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 20/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

@protocol OrderManagerDelegate;
@class Order;

typedef enum {
	PlaceOrderGetChallenge,
	PlaceOrderPostOrder,
	CancelOrder,
	GetStatusOrder
} Status;

@interface OrderManager : NSObject <HTTPConnectionDelegate> {
	// Model
	Order *order;
	HTTPConnection *httpConnection;
	Status status;
	
	// Other
	id <OrderManagerDelegate> delegate;
}

// Model
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) HTTPConnection *httpConnection;

// Other
@property (nonatomic, assign) id <OrderManagerDelegate> delegate;

+ (OrderManager *)sharedOrderManager;
- (void)placeOrder:(Order *)theOrder;
- (void)cancelOrder:(Order *)theOrder;
- (void)getOrderStatus:(Order *)theOrder;
- (void)stop;

@end

@protocol OrderManagerDelegate

// Placing Order
- (void)orderManager:(OrderManager *)orderManager didPlaceOrder:(Order *)order;
- (void)orderManager:(OrderManager *)orderManager
placeOrderFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage;

// Cancelling Order
- (void)orderManager:(OrderManager *)orderManager didCancelOrder:(Order *)order;
- (void)orderManager:(OrderManager *)orderManager
cancelOrderFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage;

// Getting Order Status
- (void)orderManager:(OrderManager *)orderManager didGetOrderStatus:(NSDictionary *)orderStatusDictionary;
- (void)orderManager:(OrderManager *)orderManager
getOrderStatusFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage;

@end
