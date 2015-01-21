//
//  PickupTimeButton.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PickupTimeButton : UIButton {
	// View
	UILabel *pickupTimeTextLabel, *pickupTimeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *pickupTimeTextLabel, *pickupTimeLabel;

@end
