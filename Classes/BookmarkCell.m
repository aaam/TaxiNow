//
//  BookmarkCell.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarkCell.h"
#import "Bookmark.h"

@implementation BookmarkCell

@synthesize bookmark;

// Setters and Getters

- (void)setBookmark:(Bookmark *)aBookmark {
	Bookmark *tempBookmark = bookmark;
	bookmark = [aBookmark retain];
	[tempBookmark release];
	
	self.textLabel.text = bookmark.name;
}

@end
