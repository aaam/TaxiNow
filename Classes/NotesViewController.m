//
//  NotesViewController.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"
#import "Order.h"

@interface NotesViewController (PrivateMethods)

- (UIButton *)newButtonWithTitle:(NSString *)title
						  target:(id)target
						selector:(SEL)selector
						   frame:(CGRect)frame
						   image:(UIImage *)image;	

@end


@implementation NotesViewController

#define kKeyboardHeight 216.0

// Model
@synthesize order;

// View
@synthesize textView;

- (UIButton *)newButtonWithTitle:(NSString *)title
						  target:(id)target
						selector:(SEL)selector
						   frame:(CGRect)frame
						   image:(UIImage *)image {	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:13.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	#define horizontalBorder 17.0
	#define bottonHeight 44.0
	
	textView.text = order.notes;
	
	UIFont *buttonFont = [UIFont boldSystemFontOfSize:13.0];
	
	// Create the cancel and done buttons
	UIButton *cancelButton = [self newButtonWithTitle:NSLocalizedString(@"Cancel", @"")
					  target:self
					selector:@selector(cancelButtonAction:)
					   frame:CGRectMake(0, 31, 2*horizontalBorder + [NSLocalizedString(@"Cancel", @"") sizeWithFont:buttonFont].width, bottonHeight)
					   image:[UIImage imageNamed:@"NotesNormalButton.png"]];
	CGFloat doneButtonWidth = 2*horizontalBorder + [NSLocalizedString(@"Done", @"") sizeWithFont:buttonFont].width;
	UIButton *doneButton = [self newButtonWithTitle:NSLocalizedString(@"Done", @"")
					  target:self
					selector:@selector(doneButtonAction:)
					   frame:CGRectMake(322 - doneButtonWidth, 31, doneButtonWidth, bottonHeight)
					   image:[UIImage imageNamed:@"NotesDoneButton.png"]];	
	[self.view addSubview:cancelButton];
	[self.view addSubview:doneButton];
	[cancelButton release];
	[doneButton release];
	
	// Show the keyboard
	[textView becomeFirstResponder];
}

- (void)dealloc {
	// Model
	[order release];
	
	// View
	[textView release];
	
    [super dealloc];
}

// Actions

- (IBAction)doneButtonAction:(id)sender {
	order.notes = textView.text;
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

// UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)theTextView {
	// Change the frame size to take the keyboard into account
	CGRect frame = textView.frame;
	frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - kKeyboardHeight);
	textView.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView {
	// Change the frame size to take the keyboard into account
	CGRect frame = textView.frame;
	frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) + kKeyboardHeight);
	textView.frame = frame;
}

@end
