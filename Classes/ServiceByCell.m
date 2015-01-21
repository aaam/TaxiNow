//
//  ServiceByCell.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ServiceByCell.h"
#import "OrderViewController.h"

@interface ServiceByCell (PrivateMethods)

- (void)loadImageAtUrl:(NSURL *)aURL;

@end


@implementation ServiceByCell

// View
@synthesize logoImage;

// Model
@synthesize serviceByUrl;

// Controller
@synthesize orderViewController;

- (void)dealloc {
	// View
	[logoImage release];
	
	// Model
	[serviceByUrl release];
	
	[super dealloc];
}

- (void)setServiceByUrl:(NSURL *)aURL {
	// Update the model
	NSURL *tempURL = serviceByUrl;
	serviceByUrl = [aURL retain];
	[tempURL release];
	
	[self performSelectorInBackground:@selector(loadImageAtUrl:) withObject:aURL];
}

// Private Methods

- (void)loadImageAtUrl:(NSURL *)aURL {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Load the image in the apposite area
	logoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
	CGRect frame = logoImage.frame;
	frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), logoImage.image.size.height);
	logoImage.frame = frame;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Reload the table to reflect the changes with a neat animation
	[orderViewController.centerTableView reloadData];
	
	[pool release];
}

@end
