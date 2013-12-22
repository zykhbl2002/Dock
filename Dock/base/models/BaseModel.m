//
//  BaseModel.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)dealloc {
	[super dealloc];
}

- (BOOL)checkNSStringIsEmpty:(NSString*)str {
	return (str == nil || [@"" isEqual:str]);
}

- (BOOL)checkDictionary:(NSDictionary*)dict containKey:(id)key {
	if (dict == nil || key == nil) {
		return NO;
	}
	
	id tValue = [dict objectForKey:key];
	if (tValue == nil || tValue == [NSNull null]) {
		return NO;
	}
	
	return YES;
}

- (void)fillWithDictionary:(NSDictionary*)dictionary {
	
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
	self = [super init];
    
    if (self) {
        [self fillWithDictionary:dictionary];
    }

	return self;
}

- (NSString*)description {
    NSDictionary *dict = [self toDictionary];
    return [dict description];
}

- (NSMutableDictionary*)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	return [dict autorelease];
}

- (void)fillDictionary:(NSMutableDictionary*)dict withNSString:(NSString*)value forKey:(NSString*)key {
	if (value != nil) {
		[dict setObject:value forKey:key];
	} else {
		[dict setObject:@"" forKey:key];
	}
}

- (void)fillDictionary:(NSMutableDictionary*)dict withInt:(int)ivalue forKey:(id)key {
	NSNumber *num = [NSNumber numberWithInt:ivalue];
	[dict setObject:num forKey:key];	
}

- (void)fillDictionary:(NSMutableDictionary*)dict withFloat:(float)fvalue forKey:(id)key {
	NSNumber *num = [NSNumber numberWithFloat:fvalue];
	[dict setObject:num forKey:key];	
}

- (void)fillDictionary:(NSMutableDictionary*)dict withBool:(BOOL)bvalue forKey:(id)key {
	NSNumber *num = [NSNumber numberWithBool:bvalue];
	[dict setObject:num forKey:key];	
}

- (NSString*)getNSStringFromDictionary:(NSDictionary*)dict forKey:(id)key {
	if (dict == nil) {
		return @"";
	}
    
	id t_value = [dict objectForKey:key];
	if (t_value != nil) {
		return [NSString stringWithFormat:@"%@", t_value];
	} else {
		return @"";
	}
}

- (int)getIntFromDictionary:(NSDictionary*)dict forKey:(id)key {
	if (dict == nil) {
		return 0;
	}
    
	id t_value = [dict objectForKey:key];
	if (t_value != nil && [t_value respondsToSelector:@selector(intValue)]) {
		return [t_value intValue];
	} else {
		return 0;
	}
}

- (float)getFloatFromDictionary:(NSDictionary*)dict forKey:(id)key {
	if (dict == nil) {
		return 0.0;
	}
    
	id t_value = [dict objectForKey:key];
	if (t_value != nil && [t_value respondsToSelector:@selector(floatValue)]) {
		return [t_value floatValue];
	} else {
		return 0.0;
	}
}

- (BOOL)getBoolFromDictionary:(NSDictionary*)dict forKey:(id)key {
	if (dict == nil) {
		return NO;
	}
    
	id t_value = [dict objectForKey:key];
	if (t_value != nil && [t_value respondsToSelector:@selector(boolValue)]) {
		return [t_value boolValue];
	} else {
		return NO;
	}
}

@end
