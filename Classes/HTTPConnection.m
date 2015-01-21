//
//  HTTPConnection.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 20/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HTTPConnection.h"


@implementation HTTPConnection

// Model
@synthesize receivedData;
@synthesize urlConnection;

// Other
@synthesize delegate;

- (id)initWithRequest:(NSURLRequest *)request {
	if (self = [self init]) {
		self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	}
	return self;
}

- (void)dealloc {
	[urlConnection release];
	
	[super dealloc];
}

- (void)start {
	self.receivedData = [NSMutableData data];
	[urlConnection start];
}

- (void)cancel {
	[urlConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[delegate connection:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *dump = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"%@", dump);
	[delegate connectionDidFinishLoading:self data:receivedData];
}

@end
