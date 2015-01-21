//
//  PickupAddressCell.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 29/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PickupAddressCell : UITableViewCell {	
	// Model
	NSDictionary *pickupAddress;
}

// Model
@property (nonatomic, retain) NSDictionary *pickupAddress;

@end
