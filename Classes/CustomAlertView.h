//
//  CustomAlertView.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomAlertView : UIAlertView {
	// Model
	NSString *alertType;
}

@property (nonatomic, copy) NSString *alertType;

@end
