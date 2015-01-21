//
//  NSDictionary+DeepObjectForKey.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 15/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+DeepObjectForKey.h"

@implementation NSDictionary (DeepObjectForKey)

- (id)deepObjectForKey:(id)aKey {
	id object = [self objectForKey:aKey];
	if (object) {
		return object;
	}
	
	NSArray *objects = [self allValues];
	for (id anObject in objects) {
		if ([anObject isKindOfClass:[NSDictionary class]]) {
			object = [anObject deepObjectForKey:aKey];
			if (object) {
				return object;
			}
		}
	}
	
	return nil;
}

@end
