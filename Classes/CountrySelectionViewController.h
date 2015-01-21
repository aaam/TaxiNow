//
//  CountrySelectionViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledTableViewController.h"

@interface CountrySelectionViewController : StyledTableViewController <UITableViewDataSource, UITableViewDelegate> {
	// Model
	NSInteger selectedCellIndex;
}


@end
