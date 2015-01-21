//
//  AddBookmarkViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddBookmarkViewController.h"
#import "PickupLocation.h"
#import "Bookmark.h"
#import "BookmarkNameCell.h"
#import "UIFactory.h"

@implementation AddBookmarkViewController

// View
@synthesize bookmarkNameTextField;

// Model
@synthesize pickupLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[bookmarkNameTextField becomeFirstResponder];
}

- (void)dealloc {
	// View
	[bookmarkNameTextField release];
	
	// Model
	[pickupLocation release];
	
	[super dealloc];
}

// Actions

- (IBAction)cancelButtonAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(id)sender {
	// Ignore empty names
	if ([bookmarkNameTextField.text isEqualToString:@""]) {
		return;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *bookmarks = [[defaults arrayForKey:@"bookmarks"] mutableCopy];
	Bookmark *bookmark = [[Bookmark alloc] init];
	bookmark.name = bookmarkNameTextField.text;
	bookmark.pickupLocation = pickupLocation;
	[bookmarks addObject:[bookmark encode]];
	[bookmark release];
	[defaults setObject:bookmarks forKey:@"bookmarks"];
	[bookmarks release];
	
	[self dismissModalViewControllerAnimated:YES];
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
	}
	return bookmarkNameCell;
}

// UITableViewDelegate

@end
