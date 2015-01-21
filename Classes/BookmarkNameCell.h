//
//  BookmarkNameCell.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookmarkNameCell : UITableViewCell {
	// View
	UITextField *bookmarkNameTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *bookmarkNameTextField;

@end
