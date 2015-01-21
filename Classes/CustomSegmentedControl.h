//
//  CustomSegmentedControl.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 26/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomSegmentedControlProtocol

- (void)didSelectSegment:(NSUInteger)segmentIndex;

@end


@interface CustomSegmentedControl : UIView {
	// Model
	NSUInteger selectedSegment;
	
	// View
	UIImageView *segmentImage1, *segmentImage2, *segmentImage3;
	UIImageView *verticalSeparator1, *verticalSeparator2;
	UILabel *segmentLabel1, *segmentLabel2, *segmentLabel3;
	
	// Other
	id <CustomSegmentedControlProtocol> delegate;
}

// Model
@property (nonatomic, assign) NSUInteger selectedSegment;

// View
@property (nonatomic, retain) IBOutlet UIImageView *segmentImage1, *segmentImage2, *segmentImage3;
@property (nonatomic, retain) IBOutlet UIImageView *verticalSeparator1, *verticalSeparator2;
@property (nonatomic, retain) IBOutlet UILabel *segmentLabel1, *segmentLabel2, *segmentLabel3;

// Other
@property (nonatomic, assign) IBOutlet id <CustomSegmentedControlProtocol> delegate;

- (void)setSelectedSegment:(NSUInteger)index;

- (IBAction)segment1Action:(id)sender;
- (IBAction)segment2Action:(id)sender;
- (IBAction)segment3Action:(id)sender;

@end
