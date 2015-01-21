//
//  BookmarksViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController.h"
#import "BookmarkCell.h"
#import "Bookmark.h"
#import "EditBookmarkController.h"
#import "MainViewController.h"
#import "PickupLocation.h"

@implementation BookmarksViewController

// View
@synthesize doneButton;
@synthesize tableView;

// Other
@synthesize mainViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	savedPrompt = [self.navigationItem.prompt copy];
	self.navigationItem.leftBarButtonItem = [self editButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[tableView reloadData];
}

- (void)dealloc {
	// View
	[doneButton release];
	[tableView release];
	
	// Model
	[savedPrompt release];
	
    [super dealloc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	[self.navigationItem setRightBarButtonItem:editing ? nil : doneButton animated:YES];
	self.navigationItem.prompt = editing ? NSLocalizedString(@"Organize Bookmarks", @"Bookmarks view subtitle while editing") :
											 savedPrompt;
	[tableView setEditing:editing animated:animated];
}

// Actions

- (IBAction)doneButtonAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

// UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *bookmarks = [[NSUserDefaults standardUserDefaults] arrayForKey:@"bookmarks"];
	return [bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BookmarkCell *cell = (BookmarkCell *)[theTableView dequeueReusableCellWithIdentifier:@"BookmarkCell"];
	if (!cell) {
		cell = [[[BookmarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookmarkCell"] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSArray *bookmarks = [[NSUserDefaults standardUserDefaults] arrayForKey:@"bookmarks"];
	Bookmark *bookmark = [[Bookmark alloc] initWithDictionary:[bookmarks objectAtIndex:indexPath.row]];
	cell.bookmark = bookmark;
	[bookmark release];
	return cell;
}

- (void)tableView:(UITableView *)theTableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *bookmarks = [[defaults arrayForKey:@"bookmarks"] mutableCopy];
	[bookmarks removeObjectAtIndex:indexPath.row];
	[defaults setObject:bookmarks forKey:@"bookmarks"];
	[bookmarks release];
	
	// Update GUI
	[theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
						withRowAnimation:UITableViewRowAnimationTop];
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *bookmarks = [[defaults arrayForKey:@"bookmarks"] mutableCopy];
	NSDictionary *tempBookmark = [bookmarks objectAtIndex:fromIndexPath.row];
	[bookmarks removeObjectAtIndex:fromIndexPath.row];
	[bookmarks insertObject:tempBookmark atIndex:toIndexPath.row];
	[defaults setObject:bookmarks forKey:@"bookmarks"];
	[bookmarks release];
}

// UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];

	Bookmark *bookmark = ((BookmarkCell *)[theTableView cellForRowAtIndexPath:indexPath]).bookmark;
	
	if (self.editing) {
		EditBookmarkController *editBookmarkController = [[EditBookmarkController alloc] initWithNibName:@"EditBookmarkController"
																								  bundle:nil];
		editBookmarkController.bookmark = bookmark;
		editBookmarkController.bookmarkIndex = indexPath.row;
		[self.navigationController pushViewController:editBookmarkController animated:YES];
		[editBookmarkController release];
	} else {
		mainViewController.pickupLocationIsCurrentLocation = NO;
		CLLocationCoordinate2D coordinate = bookmark.pickupLocation.coordinate;
		CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
														  longitude:coordinate.longitude];
		[mainViewController setPickupLocationToLocation:location];
		// Reverse geocode the user location
		[mainViewController reverseGeocodeCoordinate:location.coordinate];
		[location release];
		
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
