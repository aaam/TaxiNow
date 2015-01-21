//
//  OrderViewController.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 28/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

@class Order;
@class ServiceByCell;

@interface OrderViewController : UIViewController <UITableViewDataSource,
												   UITableViewDelegate,
												   UIActionSheetDelegate,
												   UIAlertViewDelegate,
												   OrderManagerDelegate> {
	// View
	UITableView *centerTableView, *footerTableView;
	UIButton *cancelOrderButton;
	UILabel *estimatedTimeLabel;
	UIView *orderHeaderView;
	ServiceByCell *serviceByCell;
	
	// Model
	Order *order;
	NSTimer *estimatedTimeTimer;
}

// View
@property (nonatomic, retain) IBOutlet UITableView *centerTableView, *footerTableView;
@property (nonatomic, retain) IBOutlet UIButton *cancelOrderButton;
@property (nonatomic, assign) UILabel *estimatedTimeLabel;
@property (nonatomic, retain) IBOutlet UIView *orderHeaderView;
@property (nonatomic, retain) IBOutlet ServiceByCell *serviceByCell;

// Model
@property (nonatomic, copy) Order *order;
@property (nonatomic, retain) NSTimer *estimatedTimeTimer;

- (IBAction)cancelOrderButtonAction:(id)sender;

@end
