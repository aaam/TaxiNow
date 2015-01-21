//
//  BookmarksViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface BookmarksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	// View
	UIBarButtonItem *doneButton;
	UITableView *tableView;
	
	// Model
	NSString *savedPrompt;
	
	// Other
	MainViewController *mainViewController;
}

// View
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

// Other
@property (nonatomic, assign) MainViewController *mainViewController;

- (IBAction)doneButtonAction:(id)sender;

@end
