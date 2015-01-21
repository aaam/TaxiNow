//
//  BookmarkNameCell.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarkNameCell.h"


@implementation BookmarkNameCell

// View
@synthesize bookmarkNameTextField;

- (void)dealloc {
	[bookmarkNameTextField release];
	
	[super dealloc];
}

@end
