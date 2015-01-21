//
//  NotesViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface NotesViewController : UIViewController <UITextViewDelegate> {
	// Model
	Order *order;
	
	// View
	UITextView *textView;
}

// Model
@property (nonatomic, retain) Order *order;

// View
@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)doneButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end
