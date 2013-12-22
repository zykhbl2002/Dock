//
//  BlockDataSource.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"
#import "BlockFolderModel.h"
#import "BlockPageItemModel.h"

@interface BlockDataSource : NSObject {
    NSMutableArray *blocks;
    NSMutableArray *folders;
    NSMutableArray *blockPages;
    NSMutableArray *docks;
    
    int rows;
    int cols;
    
    BlockPageItemModel *curDragingBlockPageItemModel;
    BOOL blocksIsEdit;
    
    int dockCount;
    int folderCount;
    
    BOOL isNew;
}

@property (nonatomic, retain) NSMutableArray *blocks;
@property (nonatomic, retain) NSMutableArray *folders;
@property (nonatomic, retain) NSMutableArray *blockPages;
@property (nonatomic, retain) NSMutableArray *docks;
@property (nonatomic) int rows;
@property (nonatomic) int cols;
@property (nonatomic, retain) BlockPageItemModel *curDragingBlockPageItemModel;
@property (nonatomic) BOOL blocksIsEdit;
@property (nonatomic) int dockCount;
@property (nonatomic) int folderCount;
@property (nonatomic) BOOL isNew;

+ (BlockDataSource*)curBlockDataSource;
+ (void)cleanBlockDataSource;

- (void)loadDataSource;
- (BlockModel*)findBlockModelByPK:(NSString*)blockPK;
- (void)removePageItemModelByBlockPK:(NSString*)curDragingBlockPK inPage:(int)pageNumber withFlag:(BOOL)flag;
- (void)addEmptyPage;
- (int)getCountInpage:(int)pageNumber;
- (void)addCurDragingBlockPageItemModelToIndex:(int)moveToIndex inPage:(int)pageNumber;
- (void)addBlockModel:(BlockModel*)blockModel toDockIndex:(int)moveToIndex;
- (void)addCurDragingBlockPageItemModelToDockIndex:(int)moveToIndex;
- (void)removeBlockModelByBlockPk:(NSString*)blockPK;
- (void)removeBlockPageItemByBlockPk:(NSString*)blockPK;
- (void)removeDockItemByBlockPk:(NSString*)blockPK inDock:(BOOL)flag;
- (void)removeFolderItemByBlockPk:(NSString*)blockPK infFolder:(NSString*)folderPK flag:(BOOL)flag;
- (void)saveCurBlockPageItemModelsInToPlistFile;
- (void)saveCurBlockDatasInToPlistFile;
- (BOOL)canAddInDock;
- (BOOL)canAddInFolder:(NSString*)folderPK;
- (int)getCountInFolder:(NSString*)folderPK;
- (void)addCurDragingBlockPageItemModelInFolder:(NSString*)folderPK toIndex:(int)moveToIndex;
- (BlockFolderModel*)createBlockFolderModel:(BlockModel*)blockModel;
- (void)addBlockFolderModel:(BlockFolderModel*)folderModel inPage:(int)pageNumber toIndex:(int)index;
- (void)addBlockModel:(BlockModel*)model inFolderModel:(BlockFolderModel*)folderModel toIndex:(int)index;
- (void)addBlockModel:(BlockModel*)blockModel inPage:(int)pageNumber toIndex:(int)index;
- (int)addBlockModelInto:(BlockModel*)blockModel;

- (BOOL)checkWbUserIsExist:(NSString*)userId forBlockModel:(BlockModel*)blockModel;

@end
