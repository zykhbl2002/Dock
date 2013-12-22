//
//  BlockDataSource.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockDataSource.h"
#import "MyUnit.h"

@implementation BlockDataSource

#define blocks_filename @"blocks"
#define blockPages_filename @"blockPages"

static BlockDataSource *_curBlockDataSource;

@synthesize blocks;
@synthesize folders;
@synthesize blockPages;
@synthesize docks;
@synthesize rows;
@synthesize cols;
@synthesize curDragingBlockPageItemModel;
@synthesize blocksIsEdit;
@synthesize dockCount;
@synthesize folderCount;
@synthesize isNew;

- (void)dealloc {
    if (blocks) {
        [blocks removeAllObjects];
        [blocks release];
        blocks = nil;
    }
    
    if (folders) {
        [folders removeAllObjects];
        [folders release];
        folders = nil;
    }
    
    if (blockPages) {
        [blockPages removeAllObjects];
        [blockPages release];
        blockPages = nil;
    }
    
    if (docks) {
        [docks removeAllObjects];
        [docks release];
        docks = nil;
    }
    
    if (curDragingBlockPageItemModel) {
        [curDragingBlockPageItemModel release];
        curDragingBlockPageItemModel = nil;
    }
    
    [super dealloc];
}

+ (BlockDataSource*)curBlockDataSource {
	if (_curBlockDataSource == nil) {
		_curBlockDataSource = [[[self class] alloc] init];
	}
	
	return _curBlockDataSource;
}

+ (void)cleanBlockDataSource {
	if (_curBlockDataSource != nil) {
		[_curBlockDataSource release];
		_curBlockDataSource = nil;
	}
}

- (NSString*)getBlockFileName {
    NSString *path = [MyUnit makeDocumentFilePath:[NSString stringWithFormat:@"rootBlocks/%@.plist", blocks_filename]];
    return path;
}

- (NSString*)getBlockPageFileName {
    NSString *path = [MyUnit makeDocumentFilePath:[NSString stringWithFormat:@"rootBlocks/%@.plist", blockPages_filename]];
    return path;
}

- (void)readBlocksFile {
    if (self.blocks == nil) {
        NSMutableArray *tArray = [[NSMutableArray alloc] init];
        self.blocks = tArray;
        [tArray release];
    } else {
        [self.blocks removeAllObjects];
    }
    
    if (self.folders == nil) {
        NSMutableArray *tArray = [[NSMutableArray alloc] init];
        self.folders = tArray;
        [tArray release];
    } else {
        [self.folders removeAllObjects];
    }
    
    NSString *blockFilename = [self getBlockFileName];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:blocks_filename ofType:@"plist"];
    NSMutableDictionary *originalBlockDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    NSString *isNewStr = (NSString*)[originalBlockDict objectForKey:@"isNew"];
    
    if ([@"1" isEqualToString:isNewStr]) {
        self.isNew = YES;

        NSArray *originalNewBlockArray = [originalBlockDict objectForKey:@"newBlocks"];
        if (![MyUnit checkFilepathExists:blockFilename]) {
            [MyUnit makeDirWithFilePath:blockFilename];
            
            NSMutableDictionary *cacheBlockDict = [NSMutableDictionary dictionary];
            NSMutableArray *cacheBlockArray = [NSMutableArray arrayWithArray:[originalBlockDict objectForKey:@"blocks"]];
            [cacheBlockDict setObject:cacheBlockArray forKey:@"blocks"];
            
            for (NSDictionary *dict in originalNewBlockArray) {
                [cacheBlockArray addObject:dict];
            }
            
            NSMutableArray *cacheFolderArray = [NSMutableArray arrayWithArray:[originalBlockDict objectForKey:@"folders"]];
            [cacheBlockDict setObject:cacheFolderArray forKey:@"folders"];
            
            [cacheBlockDict writeToFile:blockFilename atomically:YES];
        } else {
            NSMutableDictionary *originalCacheBlockDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:blockFilename]];
            NSMutableArray *originalCacheBlockArray = [NSMutableArray arrayWithArray:[originalCacheBlockDict objectForKey:@"blocks"]];
            [originalCacheBlockDict removeObjectForKey:@"blocks"];
            [originalCacheBlockDict setObject:originalCacheBlockArray forKey:@"blocks"];
            
            for (NSDictionary *dict in originalNewBlockArray) {
                [originalCacheBlockArray addObject:dict];
            }
            
            [originalCacheBlockDict writeToFile:blockFilename atomically:YES];
        }
        
        [originalBlockDict removeObjectForKey:@"isNew"];
        [originalBlockDict writeToFile:path atomically:YES];
    } else {
        if (![MyUnit checkFilepathExists:blockFilename]) {
            [originalBlockDict removeObjectForKey:@"isNew"];
            [originalBlockDict removeObjectForKey:@"newBlocks"];
            [originalBlockDict writeToFile:path atomically:YES];
            
            [MyUnit makeDirWithFilePath:blockFilename];
            [originalBlockDict writeToFile:blockFilename atomically:YES];
        }
    }
    
    NSDictionary *blockDict = [NSDictionary dictionaryWithContentsOfFile:blockFilename];
    NSArray *blockArray = [blockDict objectForKey:@"blocks"];
    for (NSDictionary *dict in blockArray) {
        BlockModel *model = [[BlockModel alloc] initWithDictionary:dict];
        [self.blocks addObject:model];
        [model release];
    }
    
    NSArray *foldersArray = [blockDict objectForKey:@"folders"];
    for (NSDictionary *dict in foldersArray) {
        BlockFolderModel *model = [[BlockFolderModel alloc] initWithDictionary:dict];
        [self.folders addObject:model];
        [model release];
    }
}

- (void)readBlockPagesFile {
    if (self.blockPages == nil) {
        NSMutableArray *tArray = [[NSMutableArray alloc] init];
        self.blockPages = tArray;
        [tArray release];
    } else {
        [self.blockPages removeAllObjects];
    }
    
    if (self.docks == nil) {
        NSMutableArray *tArray = [[NSMutableArray alloc] init];
        self.docks = tArray;
        [tArray release];
    } else {
        [self.docks removeAllObjects];
    }
    
    NSString *blockPageFileName = [self getBlockPageFileName];
    
    if (![MyUnit checkFilepathExists:blockPageFileName]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:blockPages_filename ofType:@"plist"];
        NSDictionary *originalBlockPageDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        [MyUnit makeDirWithFilePath:blockPageFileName];
        [originalBlockPageDict writeToFile:blockPageFileName atomically:YES];
    }
    
    NSDictionary *blockPageDict = [NSDictionary dictionaryWithContentsOfFile:blockPageFileName];
    NSArray *blockPageArray = [blockPageDict objectForKey:@"blockPages"];
    for (NSArray *pageItems in blockPageArray) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in pageItems) {
            BlockPageItemModel *model = [[BlockPageItemModel alloc] initWithDictionary:dict];
            [tmpArray addObject:model];
            [model release];
        }
        [self.blockPages addObject:tmpArray];
        [tmpArray release];
    }
    
    NSArray *dockArray = [blockPageDict objectForKey:@"docks"];
    for (NSDictionary *dict in dockArray) {
        BlockPageItemModel *model = [[BlockPageItemModel alloc] initWithDictionary:dict];
        [self.docks addObject:model];
        [model release];
    }
    
    if (self.isNew) {
        self.isNew = NO;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:blocks_filename ofType:@"plist"];
        NSMutableDictionary *originalBlockDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
        NSArray *originalNewBlockArray = [originalBlockDict objectForKey:@"newBlocks"];
        
        for (NSDictionary *dict in originalNewBlockArray) {
            BlockPageItemModel *itemModel = [[BlockPageItemModel alloc] init];
            itemModel.blockPK = (NSString*)[dict objectForKey:@"pk"];
            self.curDragingBlockPageItemModel = itemModel;
            [itemModel release];
            
            [self addCurDragingBlockPageItemModelToIndex:0 inPage:1];
        }
        
        [self saveCurBlockPageItemModelsInToPlistFile];
        
        [originalBlockDict removeObjectForKey:@"newBlocks"];
        [originalBlockDict writeToFile:path atomically:YES];
    }
}

- (void)loadDataSource {
    [self readBlocksFile];
    [self readBlockPagesFile];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.rows = 4;
        self.cols = 4;
        self.dockCount = 4;
        self.folderCount = 12;
        
        self.isNew = NO;
    }
    
    return self;
}

- (BlockModel*)findBlockModelByPK:(NSString*)blockPK {
    for (BlockModel *model in self.blocks) {
        if ([model.pk isEqualToString:blockPK]) {
            return model;
        }
    }
    
    for (BlockFolderModel *model in self.folders) {
        if ([model.pk isEqualToString:blockPK]) {
            return model;
        }
    }
    
    return nil;
}

- (void)removePageItemModelByBlockPK:(NSString*)curDragingBlockPK inPage:(int)pageNumber withFlag:(BOOL)flag {
    if (pageNumber > [self.blockPages count]) {
        return;
    }
    
    BlockPageItemModel *removeBlockPageItemModel = nil;
    NSObject *obj = [self.blockPages objectAtIndex:pageNumber-1];
    if (obj != nil) {
        NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
        for (BlockPageItemModel *blockPageItemModel in blockPageItemModels) {
            if ([blockPageItemModel.blockPK isEqualToString:curDragingBlockPK]) {
                removeBlockPageItemModel = blockPageItemModel;
                break;
            }
        }
        
        if (removeBlockPageItemModel != nil) {
            if (flag) {
                self.curDragingBlockPageItemModel = removeBlockPageItemModel;
            }
            
            [blockPageItemModels removeObject:removeBlockPageItemModel];
        }
    }
}

- (void)addEmptyPage {
    NSMutableArray *emptyBlockPageItemModels = [NSMutableArray array];
    [self.blockPages addObject:emptyBlockPageItemModels];
}

- (int)getCountInpage:(int)pageNumber {
    int count = 0;
    if ([self.blockPages count] > 0) {
        NSObject *obj = [self.blockPages objectAtIndex:pageNumber-1];
        if (obj != nil) {
            NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
            count = [blockPageItemModels count];
        }
    }
    
    return count;
}

- (void)addCurDragingBlockPageItemModelToIndex:(int)moveToIndex inPage:(int)pageNumber {
    if (self.curDragingBlockPageItemModel == nil) {
        return;
    }
    
    int pageCount = [self.blockPages count];
    if (pageCount == 0 || pageNumber >= pageCount) {
        [self addEmptyPage];
    }
    
    NSObject *obj = [self.blockPages objectAtIndex:pageNumber-1];
    if (obj != nil) {
        NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
        [blockPageItemModels insertObject:self.curDragingBlockPageItemModel atIndex:moveToIndex];
        self.curDragingBlockPageItemModel = nil;
        
        if ([blockPageItemModels count] > self.rows*self.cols) {
            BlockPageItemModel *lastBlockPageItemModel = (BlockPageItemModel*)[blockPageItemModels lastObject];
            [self removePageItemModelByBlockPK:lastBlockPageItemModel.blockPK inPage:pageNumber withFlag:YES];
            [self addCurDragingBlockPageItemModelToIndex:0 inPage:pageNumber+1];
        }
    }
}

- (void)addBlockModel:(BlockModel*)blockModel toDockIndex:(int)moveToIndex {
    BlockPageItemModel *itmeModel = [[BlockPageItemModel alloc] init];
    itmeModel.blockPK = blockModel.pk;
    [self.docks insertObject:itmeModel atIndex:moveToIndex];
    [itmeModel release];
}

- (void)addCurDragingBlockPageItemModelToDockIndex:(int)moveToIndex {
    if (self.curDragingBlockPageItemModel == nil) {
        return;
    }
    
    [self.docks insertObject:self.curDragingBlockPageItemModel atIndex:moveToIndex];
    self.curDragingBlockPageItemModel = nil;
}

- (void)removeBlockModelByBlockPk:(NSString*)blockPK {
    BlockModel *removeBlock = [self findBlockModelByPK:blockPK];
    if (removeBlock != nil) {
        if ([removeBlock.showType isEqualToString:@"folder"]) {
            [self.folders removeObject:removeBlock];
        } else {
            [self.blocks removeObject:removeBlock];
        }
        self.blocksIsEdit = YES;
    }
    
    NSString *newPK = [NSString stringWithFormat:@"%@_homeTimeline", removeBlock.screen_name];
    NSString *plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_statusMentions", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_commentMentions", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_commentsToMe", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_commentsByMe", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_homeFollowers", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_homeFriends", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    newPK = [NSString stringWithFormat:@"%@_privateLetters", removeBlock.screen_name];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:newPK blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    NSString *skey = [NSString stringWithFormat:@"blockTabInfo_%@", removeBlock.pk];
    plistFilepath = [MyUnit makeWeiboDataPlistFilepathByBlockPk:skey blockType:removeBlock.type];
    [MyUnit removeFile:plistFilepath];
    
    
    skey = [MyUnit getSubSettingFileName:removeBlock];
    plistFilepath = [MyUnit makeUserFilePath:[NSString stringWithFormat:@"weibo_res/data/%@.plist", skey]];
    [MyUnit removeFile:plistFilepath];
}

- (BlockPageItemModel*)findBlockPageItemModelByBlockPK:(NSString*)blockPK {
    for (NSMutableArray *pageItems in self.blockPages) {
        for (BlockPageItemModel *item in pageItems) {
            if ([item.blockPK isEqualToString:blockPK]) {
                return item;
            }
        }
    }
    
    return nil;
}

- (void)removeBlockPageItemByBlockPk:(NSString*)blockPK {
    BlockPageItemModel *removeBlockPageItemModel = [self findBlockPageItemModelByBlockPK:blockPK];
    if (removeBlockPageItemModel != nil) {
        for (NSMutableArray *pageItems in self.blockPages) {
            if ([pageItems containsObject:removeBlockPageItemModel]) {
                [pageItems removeObject:removeBlockPageItemModel];
            }            
        }
    }
}

- (BlockPageItemModel*)findDockItemModelByBlockPK:(NSString*)blockPK {
    for (BlockPageItemModel *item in self.docks) {
        if ([item.blockPK isEqualToString:blockPK]) {
            return item;
        }
    }
    
    return nil;
}

- (void)removeDockItemByBlockPk:(NSString*)blockPK inDock:(BOOL)flag {
    BlockPageItemModel *removeBlockPageItemModel = [self findDockItemModelByBlockPK:blockPK];
    if (removeBlockPageItemModel != nil) {        
        if (flag) {
            self.curDragingBlockPageItemModel = removeBlockPageItemModel;
        }
        
        [self.docks removeObject:removeBlockPageItemModel];
    }
}

- (BlockFolderModel*)findFolderModelByBlockPK:(NSString*)blockPK {
    for (BlockFolderModel *folderModel in self.folders) {
        if ([folderModel.pk isEqualToString:blockPK]) {
            return folderModel;
        }        
    }
    
    return nil;
}

- (void)removeFolderItemByBlockPk:(NSString*)blockPK infFolder:(NSString*)folderPK flag:(BOOL)flag {
    BlockFolderModel *folderModel = [self findFolderModelByBlockPK:folderPK];
    BlockPageItemModel *removeBlockPageItemModel = nil;
    for (BlockPageItemModel *item in folderModel.blocks) {
        if ([item.blockPK isEqualToString:blockPK]) {
            removeBlockPageItemModel = item;
            break;
        }
    }
    
    if (removeBlockPageItemModel != nil) {        
        if (flag) {
            self.curDragingBlockPageItemModel = removeBlockPageItemModel;
        }
        
        [folderModel.blocks removeObject:removeBlockPageItemModel];
        self.blocksIsEdit = YES;
    }
}

- (void)saveCurBlockModelsInToPlistFile {
    NSMutableArray *blockModelDatas = [NSMutableArray array];
    for (BlockModel *blocModel in self.blocks) {
        NSMutableDictionary *blockDict = [blocModel toDictionary];
        [blockModelDatas addObject:blockDict];
    }
    
    NSMutableArray *foldersDatas = [NSMutableArray array];
    for (BlockFolderModel *folderModel in self.folders) {
        NSMutableDictionary *folderDict = [folderModel toDictionary];
        [foldersDatas addObject:folderDict];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:blockModelDatas forKey:@"blocks"];
    [dict setObject:foldersDatas forKey:@"folders"];
    
    [dict writeToFile:[self getBlockFileName] atomically:YES];
}

- (void)saveCurBlockPageItemModelsInToPlistFile {
    NSMutableArray *blockPageDatas = [NSMutableArray array];
    for (NSArray *itemModelArray in self.blockPages) {
        if ([itemModelArray count] > 0) {
            NSMutableArray *itemModelDatas = [NSMutableArray array];
            [blockPageDatas addObject:itemModelDatas];
            for (BlockPageItemModel *blockPageItemModel in itemModelArray) {
                NSMutableDictionary *blockPageItemModelDict = [blockPageItemModel toDictionary];
                [itemModelDatas addObject:blockPageItemModelDict];
            }
        }         
    }
    
    NSMutableArray *dockDatas = [NSMutableArray array];
    for (BlockPageItemModel *blockPageItemModel in self.docks) {
        NSMutableDictionary *blockPageItemModelDict = [blockPageItemModel toDictionary];
        [dockDatas addObject:blockPageItemModelDict];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:blockPageDatas forKey:@"blockPages"];
    [dict setObject:dockDatas forKey:@"docks"];
    
    [dict writeToFile:[self getBlockPageFileName] atomically:YES];
}

- (void)saveCurBlockDatasInToPlistFile {
    if (self.blocksIsEdit) {
        [self saveCurBlockModelsInToPlistFile];
        self.blocksIsEdit = NO;
    }
    
    [self saveCurBlockPageItemModelsInToPlistFile];
}

- (BOOL)canAddInDock {
    return [self.docks count] < self.dockCount;
}

- (BOOL)canAddInFolder:(NSString*)folderPK {
    BlockFolderModel *folderModel = [self findFolderModelByBlockPK:folderPK];
    
    if (folderModel != nil) {
        return [folderModel.blocks count] < self.folderCount;
    } else {
        return NO;
    }    
}

- (int)getCountInFolder:(NSString*)folderPK {
    int count = 0;
    
    BlockFolderModel *folderModel = [self findFolderModelByBlockPK:folderPK];
    if (folderModel != nil) {
        count = [folderModel.blocks count];
    }
    
    return count;
}

- (void)addCurDragingBlockPageItemModelInFolder:(NSString*)folderPK toIndex:(int)moveToIndex {
    if (self.curDragingBlockPageItemModel == nil) {
        return;
    }
    
    BlockFolderModel *folderModel = [self findFolderModelByBlockPK:folderPK];
    if (folderModel != nil) {
        int count = [folderModel.blocks count];
        if (moveToIndex > count) {
            moveToIndex = count;
        }
        
        [folderModel.blocks insertObject:self.curDragingBlockPageItemModel atIndex:moveToIndex];
        self.blocksIsEdit = YES;
    }
    
    self.curDragingBlockPageItemModel = nil;
}

- (NSString*)getBlockPK {
    int max = 0;
    for (BlockModel *blockModel in self.blocks) {
        int pkValue = [blockModel.pk intValue];
        if (max < pkValue) {
            max = pkValue;
        }
    }
    
    for (BlockModel *blockModel in self.folders) {
        int pkValue = [blockModel.pk intValue];
        if (max < pkValue) {
            max = pkValue;
        }
    }
    
    int newPK = max+1;
    if (newPK > 99 && newPK < 200) {
        newPK = 200;
    }
    
    return [NSString stringWithFormat:@"%d", newPK];
}

- (BlockFolderModel*)createBlockFolderModel:(BlockModel*)blockModel {
    BlockFolderModel *model = [[BlockFolderModel alloc] init];
    model.pk = [self getBlockPK];
    model.showType = @"folder";
    model.blockTitle = blockModel.blockTitle;
    model.pic = blockModel.pic;
    model.blocks = [NSMutableArray array];
    
    [self.folders addObject:model];
    
    return [model autorelease];
}

- (void)addBlockFolderModel:(BlockFolderModel*)folderModel inPage:(int)pageNumber toIndex:(int)index {
    NSObject *obj = [self.blockPages objectAtIndex:pageNumber-1];
    if (obj != nil) {
        NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
        
        BlockPageItemModel *itmeModel = [[BlockPageItemModel alloc] init];
        itmeModel.blockPK = folderModel.pk;
        [blockPageItemModels insertObject:itmeModel atIndex:index];
        [itmeModel release];
    }
}

- (void)addBlockModel:(BlockModel*)model inFolderModel:(BlockFolderModel*)folderModel toIndex:(int)index {
    int count = [folderModel.blocks count];
    if (index > count) {
        index = count;
    }
        
    BlockPageItemModel *itmeModel = [[BlockPageItemModel alloc] init];
    itmeModel.blockPK = model.pk;
    [folderModel.blocks insertObject:itmeModel atIndex:index];
    [itmeModel release];
}

- (void)addBlockModel:(BlockModel*)blockModel inPage:(int)pageNumber toIndex:(int)index {
    NSObject *obj = [self.blockPages objectAtIndex:pageNumber-1];
    if (obj != nil) {
        NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
        
        BlockPageItemModel *itmeModel = [[BlockPageItemModel alloc] init];
        itmeModel.blockPK = blockModel.pk;
        [blockPageItemModels insertObject:itmeModel atIndex:index];
        [itmeModel release];
    }
}

- (int)addBlockModelInto:(BlockModel*)blockModel {
    blockModel.pk = [self getBlockPK];
    
    [self.blocks addObject:blockModel];
    self.blocksIsEdit = YES;
    
    if ([self.blockPages count] == 0) {
        NSMutableArray *array = [NSMutableArray array];
        [self.blockPages addObject:array];
    }
    
    int index = 0;
    int pageCount = [self.blockPages count];
    NSMutableArray *lastArray = nil;
    BlockPageItemModel *pageItemModel = [[BlockPageItemModel alloc] init];
    pageItemModel.blockPK = blockModel.pk;
    for (NSMutableArray *pageItems in self.blockPages) {
        if ([pageItems count] >= self.rows*self.cols) {
            index++;
            if (index == pageCount) {
                lastArray = [[NSMutableArray alloc] init];
                
                [lastArray addObject:pageItemModel];
                break;
            }
        } else {
            [pageItems addObject:pageItemModel];
            break;
        }
    }
    
    if (lastArray != nil && [lastArray count] > 0) {
        [self.blockPages addObject:lastArray];
        [lastArray release];
    }
    [pageItemModel release];
    
    [self saveCurBlockDatasInToPlistFile];
    
    return index+1;
}

- (BOOL)checkWbUserIsExist:(NSString*)userId forBlockModel:(BlockModel*)blockModel {
    for (BlockModel *model in self.blocks) {
        if (blockModel != model) {
            if ([@"weibo" isEqualToString:model.type]) {
                if ([userId isEqualToString:model.userId]) {
                    return YES;
                }
            } else if ([@"qq" isEqualToString:model.type]) {
                if ([userId isEqualToString:model.screen_name]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

@end
