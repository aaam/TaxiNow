//
//  Bookmark.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickupLocation;

@interface Bookmark : NSObject {
	NSString *name;
	PickupLocation *pickupLocation;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) PickupLocation *pickupLocation;

- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)encode;

@end
