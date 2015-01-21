//
//  LegalViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LegalViewController.h"


@implementation LegalViewController

// View
@synthesize scrollView;
@synthesize textView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Legal", @"Title of the legal section");
	
	// Compute the height for the textview
	CGFloat height = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.bounds.size.width, CGFLOAT_MAX)].height + 100;
	
	// Resize the textView
	CGRect frame = textView.frame;
	frame.size.height = height;
	textView.frame = frame;
	
	// Set the scrollview's content size property
	scrollView.contentSize = CGSizeMake(textView.bounds.size.width, textView.frame.origin.y + height);
}



- (void)dealloc {
	[scrollView release];
	[textView release];
	
    [super dealloc];
}


@end
