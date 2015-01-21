//
//  NSString+md5.m
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 19/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+md5.h"

@implementation NSString (md5)

- (NSString *)md5Hash {
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	NSString *md5Hash = [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
	return [md5Hash lowercaseString];
}

@end
