//
//  MainViewController+Actions.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 25/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "CustomSegmentedControl.h"
#import "Geocoder.h"

@interface MainViewController (Buttons) <CustomSegmentedControlProtocol, GeocoderDelegate>

- (IBAction)bookmarksButtonAction:(id)sender;
- (IBAction)datePickerDoneButton:(id)sender;
- (IBAction)datePickerCancelButton:(id)sender;
- (IBAction)notesButtonAction:(id)sender;
- (IBAction)timeButtonAction:(id)sender;
- (IBAction)locateMeButtonAction:(id)sender;
- (IBAction)clearAddressTextField:(id)sender;
- (IBAction)blackButtonAction:(id)sender;
- (IBAction)addressTextFieldEditingDidBegin:(id)sender;
- (IBAction)addressTextFieldEditingDidEnd:(id)sender;
- (IBAction)datePickerDateChanged:(UIDatePicker *)theDatePicker;
- (IBAction)expandButtonAction:(id)sender;
- (IBAction)infoButtonAction:(id)sender;
- (IBAction)plusButtonAction:(id)sender;
- (IBAction)minusButtonAction:(id)sender;
- (void)taxiButtonAction:(id)sender;

@end
