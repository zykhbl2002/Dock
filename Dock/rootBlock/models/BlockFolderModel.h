//
//  BlockFolderModel.h
//  WBHui
//
//  Created by kenny on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"

@interface BlockFolderModel : BlockModel {
    NSMutableArray *blocks;
}

@property (nonatomic, retain) NSMutableArray *blocks;

@end
