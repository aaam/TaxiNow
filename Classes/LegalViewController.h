//
//  LegalViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LegalViewController : UIViewController {
	// View
	UIScrollView *scrollView;
	UITextView *textView;
}

// View
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
