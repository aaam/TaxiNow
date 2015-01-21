//
//  SettingsViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledTableViewController.h"

@class TextInputCell;
@class PhoneNumberView;

@interface SettingsViewController : StyledTableViewController <UITableViewDataSource,
															   UITableViewDelegate,
															   UITextFieldDelegate> {
	// View
	TextInputCell *firstNameCell;
	TextInputCell *lastNameCell;
	PhoneNumberView *phoneNumberView;
	UILabel *phoneNumberHeaderLabel;

	// Model
    BOOL firstDisplay; // Used to automatically display the keyboard
}

// View
@property (nonatomic, retain) IBOutlet TextInputCell *firstNameCell;
@property (nonatomic, retain) IBOutlet TextInputCell *lastNameCell;
@property (nonatomic, retain) IBOutlet PhoneNumberView *phoneNumberView;
@property (nonatomic, retain) IBOutlet UILabel *phoneNumberHeaderLabel;

- (IBAction)countryCodeButtonAction:(id)sender;


@end
