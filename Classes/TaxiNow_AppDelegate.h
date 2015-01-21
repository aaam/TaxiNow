//
//  TaxiNow_AppDelegate.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface TaxiNow_AppDelegate : NSObject <UIApplicationDelegate> {
	// View
    UIWindow *window;

	// Model
	NSString *deviceTokenString;
	
	// Controller
	MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, copy) NSString *deviceTokenString;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

