//
//  HTTPConnection.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 20/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPConnectionDelegate;

@interface HTTPConnection : NSObject {
	// Model
	NSMutableData *receivedData;
	NSURLConnection *urlConnection;
	
	// Other
	id <HTTPConnectionDelegate> delegate;
}

// Model
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLConnection *urlConnection;

// Other
@property (nonatomic, assign) id <HTTPConnectionDelegate> delegate;

- (id)initWithRequest:(NSURLRequest *)request;
- (void)start;
- (void)cancel;

@end

@protocol HTTPConnectionDelegate

- (void)connectionDidFinishLoading:(HTTPConnection *)httpConnection data:(NSData *)data;
- (void)connection:(HTTPConnection *)httpConnection didFailWithError:(NSError *)error;

@end
