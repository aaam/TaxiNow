//
//  ServiceByCell.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderViewController;

@interface ServiceByCell : UITableViewCell {
	// View
	UIImageView *logoImage;
	
	// Model
	NSURL *serviceByUrl;

	// Controller
	OrderViewController *orderViewController;
}

// View
@property (nonatomic, retain) IBOutlet UIImageView *logoImage;

// Model
@property (nonatomic, retain) NSURL *serviceByUrl;

// Controller
@property (nonatomic, assign) OrderViewController *orderViewController;

@end
