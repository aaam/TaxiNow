//
//  UIFactory.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIFactory : NSObject {

}

+ (id)newUIObjectFromNib:(NSString *)nibName owner:(id)anOwner;

+ (UIButton *)newButtonWithTitle:(NSString *)title
						  target:(id)target
						selector:(SEL)selector
						   frame:(CGRect)frame
						   image:(UIImage *)image
					imagePressed:(UIImage *)imagePressed;	

@end
