//
//  NSString+md5.h
//  TaxiNow!
//
//  Created by Matteo Cortonesi on 19/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)

- (NSString *)md5Hash;

@end