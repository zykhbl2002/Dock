//
//  BaseModel.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject {
	
}

- (BOOL)checkNSStringIsEmpty:(NSString*)str;
- (BOOL)checkDictionary:(NSDictionary*)dict containKey:(id)key;

- (void)fillDictionary:(NSMutableDictionary*)dict withNSString:(NSString*)value forKey:(id)key;
- (void)fillDictionary:(NSMutableDictionary*)dict withInt:(int)ivalue forKey:(id)key;
- (void)fillDictionary:(NSMutableDictionary*)dict withFloat:(float)fvalue forKey:(id)key;
- (void)fillDictionary:(NSMutableDictionary*)dict withBool:(BOOL)bvalue forKey:(id)key;


- (NSString*)getNSStringFromDictionary:(NSDictionary*)dict forKey:(id)key;
- (float)getFloatFromDictionary:(NSDictionary*)dict forKey:(id)key;
- (int)getIntFromDictionary:(NSDictionary*)dict forKey:(id)key;
- (BOOL)getBoolFromDictionary:(NSDictionary*)dict forKey:(id)key;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (void)fillWithDictionary:(NSDictionary*)dictionary;
- (NSMutableDictionary*)toDictionary;

@end
