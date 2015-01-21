//
//  TextInputCell.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextInputCell : UITableViewCell {
	// View
	UITextField *textField;
}

// View
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
