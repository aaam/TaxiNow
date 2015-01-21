//
//  BackNavigationController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BackNavigationController.h"


@implementation BackNavigationController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)doneButtonAction:(id)sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
