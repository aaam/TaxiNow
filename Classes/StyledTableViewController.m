//
//  StyledTableViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyledTableViewController.h"


@implementation StyledTableViewController

// View
@synthesize tableView;

// Model
@synthesize style;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (style == backViewStyle) {
		self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
		tableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
	}	
}

- (void)dealloc {
	[tableView release];
	
    [super dealloc];
}


@end
