//
//  TaxiNow_AppDelegate.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 1/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TaxiNow_AppDelegate.h"
#import "MainViewController.h"

@implementation TaxiNow_AppDelegate

@synthesize window;
@synthesize deviceTokenString;
@synthesize mainViewController;

// Called once by the runtime before the class object is set up
+ (void)initialize {
	// Set up the default defaults (those that are used if the user hasn't launched
	// the application yet)
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:path];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)dealloc {
	// Controller
	[mainViewController release];
	
	// Model
	[deviceTokenString release];
	
	// View
    [window release];
	
    [super dealloc];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	if (!([application enabledRemoteNotificationTypes] & UIRemoteNotificationTypeAlert)) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Turn on alert notifications to use TaxiNow (Settings > Notifications > TaxiNow!).", @"Alert View's title")
															message:@""
														   delegate:nil
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		mainViewController.taxiButton.enabled = NO;
		[alertView show];
		[alertView release];
	} else {
		NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
		self.deviceTokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:characterSet] stringByReplacingOccurrencesOfString:@" "
																																		  withString:@""];
	}
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if !TARGET_IPHONE_SIMULATOR
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Alert View's title")
														message:NSLocalizedString(@"Unable to register for remote notifications. You will not be able to use TaxiNow. Try relaunching it and make sure your internet connection works.", @"Error message")
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
	mainViewController.taxiButton.enabled = NO;
	[alertView show];
	[alertView release];
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)userInfo {
	// Let's ignore push notifications for now. The status order is already checked at startup.
	[window addSubview:mainViewController.view];
	
	// Register for push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound |
	 UIRemoteNotificationTypeAlert];
		
	return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"did receive APS while running: %@", userInfo);
		
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:@"DidReceiveRemoteNotification" object:self userInfo:userInfo];
}

@end
