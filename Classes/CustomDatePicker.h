//
//  CustomDatePicker.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 31/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomDatePicker : UIDatePicker {
	// Model
	NSDate *tempDate;
}

@property (nonatomic, retain) NSDate *tempDate;

@end
