//
//  AddBookmarkViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickupLocation;

@interface AddBookmarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	// View
	UITextField *bookmarkNameTextField;
	
	// Model
	PickupLocation *pickupLocation;
}

// View
@property (nonatomic, retain) UITextField *bookmarkNameTextField;

// Model
@property (nonatomic, retain) PickupLocation *pickupLocation;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;

@end
