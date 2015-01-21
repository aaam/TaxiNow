//
//  PhoneNumberView.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhoneNumberView : UIView {
	// View
	UITextField *textField;
	UIButton *button;
	
	// Model
	NSString *phoneNumber;
}


// View
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *button;

// Model
@property (nonatomic, readonly) NSString *phoneNumber;

@end
