//
//  StyledTableViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	backViewStyle,
	frontViewStyle
} ViewControllerStyle;

@interface StyledTableViewController : UIViewController {
	// View
	UITableView *tableView;
	
	// Model
	ViewControllerStyle style;
}

// View
@property (nonatomic, retain) IBOutlet UITableView *tableView;

// Model
@property (nonatomic, assign) ViewControllerStyle style;


@end
