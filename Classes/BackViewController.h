//
//  BackViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BackViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
	// View
	UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
