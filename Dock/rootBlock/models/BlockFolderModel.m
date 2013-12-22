//
//  BlockFolderModel.m
//  WBHui
//
//  Created by kenny on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockFolderModel.h"
#import "BlockPageItemModel.h"

@implementation BlockFolderModel

@synthesize blocks;

- (void)dealloc {
    if (blocks) {
        [blocks removeAllObjects];
        [blocks release];
        blocks = nil;
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
    
	if ([self checkDictionary:dictionary containKey:@"blocks"]) {
		NSMutableArray *tArray = [[NSMutableArray alloc] init];
        self.blocks = tArray;
        [tArray release];
        
        NSArray *array = (NSArray*)[dictionary objectForKey:@"blocks"];
        for (NSDictionary *dict in array) {
            BlockPageItemModel *item = [[BlockPageItemModel alloc] init];
            [item fillWithDictionary:dict];
            [self.blocks addObject:item];
            [item release];
        }
	}
}

- (NSMutableDictionary*)toDictionary {
	NSMutableDictionary* dict = [super toDictionary];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BlockPageItemModel *item in self.blocks) {
        NSMutableDictionary *itemDict = [item toDictionary];
        [array addObject:itemDict];
    }
    [dict setObject:[NSArray arrayWithArray:array] forKey:@"blocks"];
    [array release];
    
	return dict;
}

@end
