//
//  UIFactory.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIFactory.h"


@implementation UIFactory

+ (id)newUIObjectFromNib:(NSString *)nibName owner:(id)anOwner {
	// Load the nib file that contains the ui object
	NSArray *contents = [[NSBundle mainBundle] loadNibNamed:nibName owner:anOwner options:nil];
	// Return the second object which should correspond the object
	// We need to retain it (see documentation of loadNibNamed)
	return [[contents objectAtIndex:0] retain]; // THIS ONLY WORKS IN 2.2 or later I THINK. Use objectAtIndex:1 for 2.1 or 2.0
}

+ (UIButton *)newButtonWithTitle:(NSString *)title
						  target:(id)target
						selector:(SEL)selector
						   frame:(CGRect)frame
						   image:(UIImage *)image
					imagePressed:(UIImage *)imagePressed {	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	button.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:14.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:14.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

@end
