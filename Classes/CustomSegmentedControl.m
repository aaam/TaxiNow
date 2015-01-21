//
//  CustomSegmentedControl.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentedControl.h"


@implementation CustomSegmentedControl

// Model
@synthesize selectedSegment;

// View
@synthesize segmentImage1, segmentImage2, segmentImage3;
@synthesize verticalSeparator1, verticalSeparator2;
@synthesize segmentLabel1, segmentLabel2, segmentLabel3;

// Other
@synthesize delegate;

- (void)dealloc {
	[segmentImage1 release]; [segmentImage2 release]; [segmentImage3 release];
	[verticalSeparator1 release]; [verticalSeparator2 release];
	[segmentLabel1 release]; [segmentLabel2 release]; [segmentLabel3 release];
	
	[super dealloc];
}

- (void)setSelectedSegment:(NSUInteger)index {
	UIImage *leftButton = [UIImage imageNamed:@"ButtonSegmentLeft.png"];
	UIImage *leftButtonSelected = [UIImage imageNamed:@"ButtonSegmentLeftSelected.png"];
	UIImage *middleButton = [UIImage imageNamed:@"ButtonSegmentMiddle.png"];
	UIImage *middleButtonSelected = [UIImage imageNamed:@"ButtonSegmentMiddleSelected.png"];
	UIImage *rightButton = [UIImage imageNamed:@"ButtonSegmentRight.png"];
	UIImage *rightButtonSelected = [UIImage imageNamed:@"ButtonSegmentRightSelected.png"];
	UIImage *verticalSeparator = [UIImage imageNamed:@"VerticalSeparator.png"];
	UIImage *verticalSeparatorSelected = [UIImage imageNamed:@"VerticalSeparatorSelected.png"];
	UIColor *brightShadow = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	CGSize brightShadowOffset = CGSizeMake(0.0, 1.0);
	UIColor *darkShadow = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	CGSize darkShadowOffset = CGSizeMake(0.0, -1.0);
	UIColor *customBlue = [UIColor colorWithRed:63.0/255.0 green:92.0/255.0 blue:132.0/255.0 alpha:1.0];
	UIColor *white = [UIColor whiteColor];
	
	segmentImage1.image = index == 0 ? leftButtonSelected : leftButton;
	segmentLabel1.textColor = index == 0 ? white : customBlue;
	segmentLabel1.shadowColor = index == 0 ? darkShadow : brightShadow;
	segmentLabel1.shadowOffset = index == 0 ? darkShadowOffset : brightShadowOffset;
	
	verticalSeparator1.image = index == 0 || index == 1 ? verticalSeparatorSelected : verticalSeparator;
	
	segmentImage2.image = index == 1 ? middleButtonSelected : middleButton;
	segmentLabel2.textColor = index == 1 ? white : customBlue;
	segmentLabel2.shadowColor = index == 1 ? darkShadow : brightShadow;
	segmentLabel2.shadowOffset = index == 1 ? darkShadowOffset : brightShadowOffset;
	
	verticalSeparator2.image = index == 1 || index == 2 ? verticalSeparatorSelected : verticalSeparator;
	
	segmentImage3.image = index == 2 ? rightButtonSelected : rightButton;
	segmentLabel3.textColor = index == 2 ? white : customBlue;
	segmentLabel3.shadowColor = index == 2 ? darkShadow : brightShadow;
	segmentLabel3.shadowOffset = index == 2 ? darkShadowOffset : brightShadowOffset;
}

- (IBAction)segment1Action:(id)sender {
	self.selectedSegment = 0;
	[delegate didSelectSegment:0];
}

- (IBAction)segment2Action:(id)sender {
	self.selectedSegment = 1;
	[delegate didSelectSegment:1];
}

- (IBAction)segment3Action:(id)sender {
	self.selectedSegment = 2;
	[delegate didSelectSegment:2];
}

@end
