//
//  BlockPageModel.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockPageItemModel.h"

@implementation BlockPageItemModel

@synthesize blockPK;

- (void)dealloc {
    if (blockPK) {
        [blockPK release];
        blockPK = nil;
    }
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)fillWithDictionary:(NSDictionary*)dictionary {
    [super fillWithDictionary:dictionary];
    
	if ([self checkDictionary:dictionary containKey:@"block_pk"]) {
		self.blockPK = [self getNSStringFromDictionary:dictionary forKey:@"block_pk"];
	}
}

- (NSMutableDictionary*)toDictionary {
	NSMutableDictionary* dict = [super toDictionary];
    
    [self fillDictionary:dict withNSString:self.blockPK forKey:@"block_pk"];
    
	return dict;
}

@end
