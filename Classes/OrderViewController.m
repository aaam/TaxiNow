//
//  OrderViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 28/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OrderViewController.h"
#import "Order.h"
#import "UIFactory.h"
#import "PickupAddressCell.h"
#import "OrderManager.h"
#import "ServiceByCell.h"
#import "CustomAlertView.h"

NSString *kServiceByBaseUrl = @"http://taxinow.forewaystudios.com/";

@interface OrderViewController (PrivateMethods)

- (void)sendOrder;
- (void)cancelOrder;
- (void)getOrderStatus;
- (void)updateEstimatedTime:(id)sender;
- (void)deleteSavedOrder;

@end


@implementation OrderViewController

// View
@synthesize centerTableView, footerTableView;
@synthesize cancelOrderButton;
@synthesize estimatedTimeLabel;
@synthesize orderHeaderView;
@synthesize serviceByCell;

// Model
@synthesize order;
@synthesize estimatedTimeTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self
						   selector:@selector(applicationWillterminate:)
							   name:UIApplicationWillTerminateNotification
							 object:nil];
	[notificationCenter addObserver:self
						   selector:@selector(didReceiveRemoteNotification:)
							   name:@"DidReceiveRemoteNotification"
							 object:nil];
	
	self.estimatedTimeTimer = [NSTimer timerWithTimeInterval:1.0
													  target:self
													selector:@selector(updateEstimatedTime:)
													userInfo:nil
													 repeats:YES];	
	
	switch (order.status) {
		case SendingOrder:
			[self sendOrder];
			break;
		case CancellingOrder:
			[self cancelOrder];
			break;
		case OrderSent:
			[self getOrderStatus];
			break;
		default:
			break;
	}
	
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[OrderManager sharedOrderManager] stop];
	
	// View
	[centerTableView release]; [footerTableView release];
	[cancelOrderButton release];
	[orderHeaderView release];
	[serviceByCell release];
	
	// Model
	[order release];
	[estimatedTimeTimer release];
	
	[super dealloc];
}

// UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger sectionsCount;

	if (tableView == centerTableView) {
		if (order.status == OrderSent) {
			if (order.estimatedArrivalTime || order.serviceByUrl) {
				sectionsCount = 3;
			} else {
				sectionsCount = 1;
			}
		} else if (order.status == SendingOrder) {
			sectionsCount = 1;
		} else if (order.status == CancellingOrder) {
			sectionsCount = 1;
		}
	} else if (tableView == footerTableView) {
		sectionsCount = 1;
	}
	
	return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowsCount;

	if (tableView == centerTableView) {
		if (order.status == OrderSent) {
			switch (section) {
				case 0:
					rowsCount = 1;
					break;
				case 1:
					rowsCount = 1;
					break;
				case 2:
					rowsCount = 1;
					break;
				default:
					break;
			}
		} else if (order.status == SendingOrder) {
			rowsCount = 1;
		} else if (order.status == CancellingOrder) {
			rowsCount = 1;
		}
	} else if (tableView == footerTableView) {
		rowsCount = 1;
	}
	
	return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (tableView == centerTableView) {
		if (order.status == OrderSent) {
			switch (indexPath.section) {
				case 0:
					cell = [tableView dequeueReusableCellWithIdentifier:@"PickupAddressCell"];
					if (!cell) {
						cell = [[[PickupAddressCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"PickupAddressCell"] autorelease];
						cell.selectionStyle = UITableViewCellSelectionStyleNone;
						((PickupAddressCell *)cell).pickupAddress = order.pickupAddress;
					}
					break;
				case 1:
					switch (indexPath.row) {
						case 0:
							cell = [tableView dequeueReusableCellWithIdentifier:@"EstimatedTimeCell"];
							if (!cell) {
								cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
															   reuseIdentifier:@"EstimatedTimeCell"] autorelease];
								cell.selectionStyle = UITableViewCellSelectionStyleNone;
								cell.textLabel.textAlignment = UITextAlignmentCenter;
							}
							self.estimatedTimeLabel = cell.textLabel;
							[self updateEstimatedTime:self];
							[[NSRunLoop mainRunLoop] addTimer:estimatedTimeTimer forMode:NSDefaultRunLoopMode];
							break;
						default:
							break;
					}
					break;
				case 2:
					switch (indexPath.row) {
						case 0:
							cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceByCell"];
							if (!cell) {
								serviceByCell.orderViewController = self;
								cell = serviceByCell;
								if (!serviceByCell.serviceByUrl) {
									serviceByCell.serviceByUrl = order.serviceByUrl;
								}
							}
							break;
						default:
							break;
					}
					break;
				default:
					break;
			}
		} else if (order.status == SendingOrder || order.status == CancellingOrder) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
			if (!cell) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCell"] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				[activityIndicator startAnimating];
				cell.accessoryView = activityIndicator;
				[activityIndicator release];
			}
			
			if (order.status == SendingOrder) {
				cell.textLabel.text = NSLocalizedString(@"Sending...", @"Cell's text in order info view.");
			} else if (order.status == CancellingOrder) {
				cell.textLabel.text = NSLocalizedString(@"Cancelling...", @"Cell's text in order info view.");
			}
		}
	} else if (tableView == footerTableView) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderCell"];
		if (!cell) {
			cell = [[UIFactory newUIObjectFromNib:@"CancelOrderCell" owner:self] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cancelOrderButton.enabled = order.status == OrderSent;
		}
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	
	if (tableView == centerTableView) {
		if (order.status == OrderSent) {
			switch (section) {
				case 0:
					title = nil;
					break;
				case 1:
					title = NSLocalizedString(@"Estimated Wait Time (minutes)", @"Header in Order Info Table");
					break;
				case 2:
					title = NSLocalizedString(@"Service by", @"Header in Order Info Table");
					break;
				default:
					break;
			}
		}
	}
	
	return title;
}

// UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height;
	
	if (tableView == centerTableView) {
		if (order.status == OrderSent && indexPath.section == 0) {
			height = 83.0;
		} else if (order.status == OrderSent && indexPath.section == 2) {
			height = serviceByCell.logoImage.image ? 20.0 + serviceByCell.logoImage.image.size.height : 44.0;
		} else {
			height = 44.0;
		}

	} else if (tableView == footerTableView) {
		height = 43.0;
	}
	
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (tableView == centerTableView) {
		if (order.status == OrderSent && section == 0 && !order.estimatedArrivalTime) {
			return orderHeaderView;
		}
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	CGFloat height;

	if (tableView == centerTableView) {
		if (order.status == OrderSent) {
			if (section == 0) {
				height = 99.0;
			} else if (section == 1) {
				height = 33.0;
			}
		}
	}
	
	return height;
}

// Actions

- (IBAction)cancelOrderButtonAction:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel", @"Text for cancel button in action sheet")
											   destructiveButtonTitle:NSLocalizedString(@"Cancel Order", @"Text for cancel order button in action sheet")
													otherButtonTitles:nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

// UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		cancelOrderButton.enabled = NO;
		
		[estimatedTimeTimer invalidate];
		
		[centerTableView beginUpdates];
		NSRange range;
		range.location = 0;
		range.length = order.status == OrderSent && order.estimatedArrivalTime ? 3 : 1;
		[centerTableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
		[centerTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		
		// Update status
		order.status = CancellingOrder;
		[centerTableView endUpdates];
		
		[self cancelOrder];
	}
}

- (void)orderSent {	
	// Update status
	order.status = OrderSent;
	
	[centerTableView beginUpdates];
	[centerTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
	[centerTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
	[centerTableView endUpdates];
	
//	// DEMO ONLY
//	[NSTimer scheduledTimerWithTimeInterval:5.0
//									 target:self
//								   selector:@selector(didReceiveEstimatedWaitTime:)
//								   userInfo:nil
//									repeats:NO];
	
	cancelOrderButton.enabled = YES;
	
	#if TARGET_IPHONE_SIMULATOR
		// TODO: create a fake push notification
		
	#endif
}

- (void)orderCancelled {
	// Delete the order
	[self deleteSavedOrder];

	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

//- (void)didReceiveEstimatedWaitTime:(NSTimer *)theTimer {
//	// DEMO PURPOSE
//	if (order.status != OrderSent) {
//		return;
//	}
//	order.estimatedArrivalTime = [[NSDate date] addTimeInterval:60*8];
//	order.serviceByUrl = [NSURL URLWithString:@"http://taxinow.forewaystudios.com/media/logo.png"];
//
//	[centerTableView beginUpdates];
//	NSRange range;
//	range.location = 0;
//	range.length = 3;
//	[centerTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//	[centerTableView insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
//	[centerTableView endUpdates];
//}

// Notifications

- (void)applicationWillterminate:(NSNotification *)aNotification {
	// If there is an order to save, do so.
	// (If there's an error the order is set to nil and therefore nothing
	// needs to be saved)
	if (order) {
		// Save the current order
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *orderPath = [documentsDirectory stringByAppendingPathComponent:@"order.obj"];
		[NSKeyedArchiver archiveRootObject:order toFile:orderPath];
	}
}

- (void)didReceiveRemoteNotification:(NSNotification *)aNotification {
	NSDictionary *userInfo = [aNotification userInfo];
	
	NSInteger code = [[userInfo objectForKey:@"Code"] integerValue];
	
	if (code == 220) { // ETA updated
		[self getOrderStatus];
	}
}

// Private Methods

- (void)sendOrder {
//  DEMO
//	[NSTimer scheduledTimerWithTimeInterval:1.8
//									 target:self
//								   selector:@selector(orderSent:)
//								   userInfo:nil
//									repeats:NO];

	OrderManager *orderManager = [OrderManager sharedOrderManager];
	orderManager.delegate = self;
	[orderManager placeOrder:order];
}

- (void)cancelOrder {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	OrderManager *orderManager = [OrderManager sharedOrderManager];
	[orderManager stop];
	orderManager.delegate = self;
	[orderManager cancelOrder:order];
}

- (void)getOrderStatus {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	OrderManager *orderManager = [OrderManager sharedOrderManager];
	orderManager.delegate = self;
	[orderManager getOrderStatus:order];
}

- (void)updateEstimatedTime:(id)sender {
	if (order.estimatedArrivalTime) {
		NSTimeInterval timeInterval = [order.estimatedArrivalTime timeIntervalSinceNow];
		if (timeInterval > 0) {
			estimatedTimeLabel.text = [NSString stringWithFormat:@"%d:%.2d", (int)floor(floor(timeInterval)/60), (int)floor(timeInterval) % 60];
		} else {
			estimatedTimeLabel.text = @"0:00";
		}
	}
}

- (void)deleteSavedOrder {
	self.order = nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *orderPath = [documentsDirectory stringByAppendingPathComponent:@"order.obj"];
	NSError *error;
	[[NSFileManager defaultManager] removeItemAtPath:orderPath error:&error];	
}

// OrderManagerDelegate

- (void)orderManager:(OrderManager *)orderManager didPlaceOrder:(Order *)order {
	[self orderSent];
}

- (void)orderManager:(OrderManager *)orderManager
placeOrderFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage {
	// Delete the order even though it is cancelled again later
	// Reason: the user could close the app before clicking on "Ok".
	[self deleteSavedOrder];
	
	if (code == 0) {
		CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"Network Error", @"Alert View's title")
															message:NSLocalizedString(@"Can not order taxi. Try again later.", @"Error message")
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		alertView.alertType = @"placeOrderError";
		[alertView show];
		[alertView release];
	} else {
		CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:errorTitle
															message:errorMessage
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		alertView.alertType = @"placeOrderError";
		[alertView show];
		[alertView release];
	}
}

- (void)orderManager:(OrderManager *)orderManager didCancelOrder:(Order *)order {
	[self orderCancelled];
}

- (void)orderManager:(OrderManager *)orderManager
cancelOrderFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage {
	if (code == 0) {
		CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"Network Error", @"Alert View's title")
															message:NSLocalizedString(@"Can not cancel the order. Try again later.", @"Error message")
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		alertView.alertType = @"cancelOrderError";
		[alertView show];
		[alertView release];
	} else {
		CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:errorTitle
															message:errorMessage
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		alertView.alertType = @"cancelOrderError";
		[alertView show];
		[alertView release];
	}
	
	// Reset the tableview
	[centerTableView beginUpdates];
	NSRange range;
	range.location = 0;
	range.length = order.estimatedArrivalTime ? 3 : 1;
	[centerTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[centerTableView insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
	[centerTableView endUpdates];
	
}

- (void)orderManager:(OrderManager *)orderManager didGetOrderStatus:(NSDictionary *)orderStatusDictionary {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	if ([[orderStatusDictionary objectForKey:@"Code"] integerValue] == 900) { // Order remotely cancelled
		// Delete the order even though it is cancelled again later
		// Reason: the user could close the app before clicking on "Ok".
		[self deleteSavedOrder];
		
		CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:[orderStatusDictionary objectForKey:@"ErrorTitle"]
																	message:[orderStatusDictionary objectForKey:@"ErrorMessage"]
																   delegate:self
														  cancelButtonTitle:nil
														  otherButtonTitles:NSLocalizedString(@"OK", @"Button's title"), nil];
		alertView.alertType = @"orderRemotelyCancelled";
		[alertView show];
		[alertView release];
		
		return;
	}
	
	// Check if the response contains data to update the order
	if (!([orderStatusDictionary objectForKey:@"ETA"] && [orderStatusDictionary objectForKey:@"ServiceBy"])) {
		return;
	}
	
	// If we already received the ETA we don't have to reanimate the inserts/deletes of rows.
	BOOL animateRows = !order.estimatedArrivalTime;

	// Parse date string
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
	order.estimatedArrivalTime = [dateFormatter dateFromString:[orderStatusDictionary objectForKey:@"ETA"]];
	[dateFormatter release];
	
	order.serviceByUrl = [NSURL URLWithString:[kServiceByBaseUrl stringByAppendingPathComponent:[orderStatusDictionary objectForKey:@"ServiceBy"]]];
	
	if (animateRows) {
		[centerTableView beginUpdates];
		NSRange range;
		range.location = 0;
		range.length = 3;
		[centerTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
		[centerTableView insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
		[centerTableView endUpdates];
	}
}

- (void)orderManager:(OrderManager *)orderManager
getOrderStatusFailedWithErrorCode:(NSInteger)code
		  errorTitle:(NSString *)errorTitle
		errorMessage:(NSString *)errorMessage {
	NSLog(@"Unable to get order status. Code=%d", code);
}

// UIAlerViewDelegate

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView.alertType isEqualToString:@"placeOrderError"]) {
		[self orderCancelled];
	} else if ([alertView.alertType isEqualToString:@"orderRemotelyCancelled"]) {
		[self orderCancelled];
	} else if ([alertView.alertType isEqualToString:@"cancelOrderError"]) {
		cancelOrderButton.enabled = YES;
	}
}

@end
