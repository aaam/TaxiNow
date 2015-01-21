//
//  OrderManager.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 20/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OrderManager.h"
#import "JSON.h"
#import "Order.h"
#import <AddressBook/AddressBook.h>
#import "NSString+md5.h"
#import "JSON.h"
#import "PickupLocation.h"
#import "CountryCodes.h"
#import "TaxiNow_AppDelegate.h"


NSString *kChallengeURLString = @"http://taxinow.forewaystudios.com/requests/createOrder/";
NSString *kOrderURLString = @"http://taxinow.forewaystudios.com/requests/placeOrder/";
NSString *kCancelOrderURLString = @"http://taxinow.forewaystudios.com/requests/cancelOrder/";
NSString *kOrderStatusURLString = @"http://taxinow.forewaystudios.com/requests/orderStatus/";

@interface OrderManager (PrivateMethods)

- (void)placeOrderGetChallenge;
- (void)placeOrderPostOrder;

@end


@implementation OrderManager

// Model
@synthesize order;
@synthesize httpConnection;

// Other
@synthesize delegate;

static OrderManager *sharedOrderManager = nil;

+ (OrderManager *)sharedOrderManager
{
    @synchronized(self) {
        if (sharedOrderManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedOrderManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedOrderManager == nil) {
            sharedOrderManager = [super allocWithZone:zone];
            return sharedOrderManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)dealloc {
	[order release];
	[httpConnection release];
	
	[super dealloc];
}

- (void)placeOrder:(Order *)theOrder {
	self.order = theOrder;
	
	// If the application was previosly interrupted during the order process
	// and managed to get an orderID, start posting the order with the previous
	// orderID to avoid requesting a new one and entering a duplicate oder in
	// the system.
	if (!order.orderID) {
		[self placeOrderGetChallenge];
	} else {
		[self placeOrderPostOrder];
	}
}

- (void)cancelOrder:(Order *)theOrder {
	self.order = theOrder;
	
	status = CancelOrder;
	
	// Build request dictionary
	NSMutableDictionary *request = [NSMutableDictionary dictionary];
	
	// OrderID
	[request setObject:[NSNumber numberWithInteger:order.orderID] forKey:@"OrderID"];
		
	// DeviceID
	#if TARGET_IPHONE_SIMULATOR
		[request setObject:@"0123456789012345678901234567890123456789" forKey:@"UDID"];
	#else
		[request setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"UDID"];
	#endif
	
	NSString *requestString = [request JSONRepresentation];
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kCancelOrderURLString]
																   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
															   timeoutInterval:60.0];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	self.httpConnection = [[[HTTPConnection alloc] initWithRequest:urlRequest] autorelease];
	[urlRequest release];
	httpConnection.delegate = self;
	[httpConnection start];	
}

- (void)getOrderStatus:(Order *)theOrder {
	self.order = theOrder;
	
	status = GetStatusOrder;
	
	// Build request dictionary
	NSMutableDictionary *request = [NSMutableDictionary dictionary];
	
	// OrderID
	[request setObject:[NSNumber numberWithInteger:order.orderID] forKey:@"OrderID"];
	
	// DeviceID
	#if TARGET_IPHONE_SIMULATOR
		[request setObject:@"0123456789012345678901234567890123456789" forKey:@"UDID"];
	#else
		[request setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"UDID"];
	#endif
	
	NSString *requestString = [request JSONRepresentation];
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kOrderStatusURLString]
																   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
															   timeoutInterval:60.0];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	self.httpConnection = [[[HTTPConnection alloc] initWithRequest:urlRequest] autorelease];
	[urlRequest release];
	httpConnection.delegate = self;
	[httpConnection start];	
}

- (void)stop {
	[httpConnection cancel];
}

// HTTPConnectionDelegate

- (void)connectionDidFinishLoading:(HTTPConnection *)httpConnection data:(NSData *)data {
	if (status == PlaceOrderGetChallenge) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *json = [dataString JSONValue];
		[dataString release];
		
		NSInteger orderID = [[json objectForKey:@"OrderID"] integerValue];
		if (orderID == 0) { // Check if the orderID is valid
			[delegate orderManager:self placeOrderFailedWithErrorCode:0 errorTitle:nil errorMessage:nil];
		} else {
			// Save the orderID in case the application is interrupted during the ordering process
			order.orderID = orderID;
			
			// Continue with the ordering process
			[self placeOrderPostOrder];
		}
	} else if (status == PlaceOrderPostOrder) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *json = [dataString JSONValue];
		[dataString release];
		
		NSInteger code = [[json objectForKey:@"Code"] integerValue];
		if (code != 200) {
			[delegate orderManager:self
	 placeOrderFailedWithErrorCode:code
						errorTitle:[json objectForKey:@"ErrorTitle"]
					  errorMessage:[json objectForKey:@"ErrorMessage"]];
		} else {
			[delegate orderManager:self didPlaceOrder:order];
		}
	} else if (status == CancelOrder) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *json = [dataString JSONValue];
		[dataString release];
		
		NSInteger code = [[json objectForKey:@"Code"] integerValue];
		if (code != 200) {
			[delegate orderManager:self
	cancelOrderFailedWithErrorCode:code
						errorTitle:[json objectForKey:@"ErrorTitle"]
					  errorMessage:[json objectForKey:@"ErrorMessage"]];
		} else {
			[delegate orderManager:self didCancelOrder:order];
		}		
	} else if (status == GetStatusOrder) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *json = [dataString JSONValue];
		[dataString release];
		
		NSInteger code = [[json objectForKey:@"Code"] integerValue];
		if (code != 200) {
			[delegate orderManager:self
	getOrderStatusFailedWithErrorCode:code
						errorTitle:[json objectForKey:@"ErrorTitle"]
					  errorMessage:[json objectForKey:@"ErrorMessage"]];
		} else {
			[delegate orderManager:self didGetOrderStatus:json];
		}		
	}
}

- (void)connection:(HTTPConnection *)httpConnection didFailWithError:(NSError *)error {
	if (status == PlaceOrderGetChallenge || status == PlaceOrderPostOrder) {
		[delegate orderManager:self placeOrderFailedWithErrorCode:0 errorTitle:nil errorMessage:nil];
	} else if (status == CancelOrder) {
		[delegate orderManager:self cancelOrderFailedWithErrorCode:0 errorTitle:nil errorMessage:nil];
	} else if (status == GetStatusOrder) {
		[delegate orderManager:self getOrderStatusFailedWithErrorCode:0 errorTitle:nil errorMessage:nil];
	}
}

// Private Methods

- (void)placeOrderGetChallenge {
	status = PlaceOrderGetChallenge;

	// Get the order ID
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kChallengeURLString]];
	self.httpConnection = [[[HTTPConnection alloc] initWithRequest:urlRequest] autorelease];
	httpConnection.delegate = self;
	[httpConnection start];	
}

- (void)placeOrderPostOrder {
	status = PlaceOrderPostOrder;
	
	// Build request dictionary
	NSMutableDictionary *request = [NSMutableDictionary dictionary];
	
	// OrderID
	[request setObject:[NSNumber numberWithInteger:order.orderID] forKey:@"OrderID"];
	
	// Response
	NSString *key = [@"QyY@v8k_jOYmVB" stringByAppendingString:@"vN}},AaiwX&igWX*/"];
	NSString *response = [[NSString stringWithFormat:@"%d%@", order.orderID, key] md5Hash];
	[request setObject:response forKey:@"Hash"];
	
	// DeviceID
	#if TARGET_IPHONE_SIMULATOR
		[request setObject:@"0123456789012345678901234567890123456789" forKey:@"UDID"];
	#else
		[request setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"UDID"];
	#endif
	
	// DeviceToken
	#if TARGET_IPHONE_SIMULATOR
		NSString *deviceTokenString = @"0123456789012345678901234567890123456789012345678901234567890123";
	#else
		NSString *deviceTokenString = ((TaxiNow_AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenString;
	#endif

	[request setObject:deviceTokenString forKey:@"DeviceToken"];
	
	// Address
	NSDictionary *pickupAddress = order.pickupAddress;
	NSString *street = [pickupAddress objectForKey:(NSString *)kABPersonAddressStreetKey];
	NSString *postalCode = [pickupAddress objectForKey:(NSString *)kABPersonAddressZIPKey];
	NSString *locality = [pickupAddress objectForKey:(NSString *)kABPersonAddressCityKey];
	NSString *countryCode = [pickupAddress objectForKey:@"CountryCode"];
	NSDictionary *address = [NSDictionary dictionaryWithObjectsAndKeys:street, @"Street",
																		postalCode, @"ZIPCode",
																		locality, @"Locality",
																		countryCode, @"Country", nil];
	[request setObject:address forKey:@"Address"];
		
	// Coordinates
	CLLocationCoordinate2D coordinate = order.pickupLocation.coordinate;
	NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:coordinate.latitude], @"Latitude",
																			[NSNumber numberWithDouble:coordinate.longitude], @"Longitude", nil];
	[request setObject:coordinates forKey:@"Coordinates"];
	
	// Passengers
	[request setObject:[NSNumber numberWithInteger:order.passengersCount] forKey:@"Passengers"];
	
	// PickupTime
	[request setObject:[order.pickupTime description] forKey:@"PickupTime"];
	
	// Notes
	[request setObject:order.notes forKey:@"Notes"];
	
	// Full Name
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *fullName = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"FirstName"],
															  [userDefaults objectForKey:@"LastName"]];
	[request setObject:fullName forKey:@"FullName"];
	
	// Phone Number
	NSInteger userCountryCode = [userDefaults integerForKey:@"CountryCode"];
	NSString *phoneNumber = [NSString stringWithFormat:@"+%d %@", userCountryCode, [userDefaults objectForKey:@"PhoneNumber"]];
	[request setObject:phoneNumber forKey:@"PhoneNumber"];
	
	// Country
	[request setObject:[[CountryCodes countryCodes] countryStringIDWithCountryCode:userCountryCode] forKey:@"Country"];
	
	NSString *requestString = [request JSONRepresentation];
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kOrderURLString]
																	cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
																timeoutInterval:30.0];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	self.httpConnection = [[[HTTPConnection alloc] initWithRequest:urlRequest] autorelease];
	[urlRequest release];
	httpConnection.delegate = self;
	[httpConnection start];	
}

@end
