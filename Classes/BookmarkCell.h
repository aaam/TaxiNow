//
//  BookmarkCell.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 2/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bookmark;

@interface BookmarkCell : UITableViewCell {
	// Model
	Bookmark *bookmark;
}

@property (nonatomic, retain) Bookmark *bookmark;

@end
