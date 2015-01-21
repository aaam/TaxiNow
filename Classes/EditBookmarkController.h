//
//  EditBookmarkController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bookmark;

@interface EditBookmarkController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	// Model
	Bookmark *bookmark;
	NSInteger bookmarkIndex;
	
	// View
	UITextField *bookmarkNameTextField;
}

// Model
@property (nonatomic, retain) Bookmark *bookmark;
@property (nonatomic, assign) NSInteger bookmarkIndex;

// View
@property (nonatomic, retain) UITextField *bookmarkNameTextField;

@end
