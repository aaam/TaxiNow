//
//  EditBookmarkController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditBookmarkController.h"
#import "Bookmark.h"
#import "UIFactory.h"
#import "BookmarkNameCell.h"

@implementation EditBookmarkController

// Model
@synthesize bookmark;
@synthesize bookmarkIndex;

// View
@synthesize bookmarkNameTextField;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Edit Bookmark", @"Edit bookmark view's title");
	self.navigationItem.prompt = NSLocalizedString(@"Organize Bookmarks", @"Bookmarks view subtitle while editing");
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[bookmarkNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	bookmark.name = bookmarkNameTextField.text;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *bookmarks = [[defaults arrayForKey:@"bookmarks"] mutableCopy];
	[bookmarks replaceObjectAtIndex:bookmarkIndex withObject:[bookmark encode]];
	[defaults setObject:bookmarks forKey:@"bookmarks"];
	[bookmarks release];
	
	[super viewWillDisappear:animated];
}

- (void)dealloc {
	// Model
	[Bookmark release];
	
	// View
	[bookmarkNameTextField release];
	
    [super dealloc];
}

// UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BookmarkNameCell *bookmarkNameCell = (BookmarkNameCell *)[tableView dequeueReusableCellWithIdentifier:@"BookmarkNameCell"];
	if (!bookmarkNameCell) {
		bookmarkNameCell = [[UIFactory newUIObjectFromNib:@"BookmarkNameCell" owner:nil] autorelease];
		self.bookmarkNameTextField = bookmarkNameCell.bookmarkNameTextField;
		bookmarkNameTextField.text = bookmark.name;
	}
	return bookmarkNameCell;
}

// UITableViewDelegate


@end
