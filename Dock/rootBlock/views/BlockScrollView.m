//
//  BlockScrollView.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockScrollView.h"

#define MaginLeft 15.0
#define MaginRight 15.0
#define MaginBottom 110.0
#define MaxBorderWidth 13.0
#define DockViewHeight 105.0

@implementation BlockScrollView

@synthesize delegate;
@synthesize scrollView;
@synthesize contentView;
@synthesize blockViewDict;
@synthesize curPageNumber;
@synthesize blockViewWidth;
@synthesize blockViewHeight;
@synthesize curEditState;
@synthesize curDragingView;
@synthesize beginDragPointInBlockView;
@synthesize beginDragPoint;
@synthesize endDragPoint;
@synthesize canPageing;
@synthesize bgDockView;
@synthesize dockView;
@synthesize removeFromDock;
@synthesize canMoveDocksBlockView;
@synthesize isTurningPage;
@synthesize isAnimationing;
@synthesize backgroundView;
@synthesize openedView;
@synthesize removeFromFolder;
@synthesize canMoveFoldersBlockView;
@synthesize isMoveFromFolderToPage;
@synthesize isOpeningFolderAnimation;
@synthesize isClosingFolderAnimation;
@synthesize curAddInView;
@synthesize timeInterval;
@synthesize beginAddInFolder;
@synthesize folderIndex;
@synthesize weiyi;
@synthesize folderHeight;
@synthesize keyBoardIsShowed;

- (void)cleanBlockViews {
    if (blockViewDict) {
        NSArray *allKey = [self.blockViewDict allKeys];
        for (NSString *key in allKey) {
            BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
            blockView.delegate = nil;
            blockView.blockModel = nil;
            [blockView removeFromSuperview];
        }
    }
}

- (void)dealloc {
    self.delegate = nil;
    
    [self cleanBlockViews];
    if (blockViewDict) {
        [blockViewDict removeAllObjects];
        [blockViewDict release];
        blockViewDict = nil;
    }
    
    if (openedView) {
        [openedView release];
        openedView = nil;
    }
    
    if (curDragingView) {
        [curDragingView release];
        curDragingView = nil;
    }
    
    if (curAddInView) {
        [curAddInView release];
        curAddInView = nil;
    }
    
    if (contentView) {
        [contentView removeFromSuperview];
        [contentView release];
        contentView = nil;
    }
    
    if (bgDockView) {
        [bgDockView removeFromSuperview];
        [bgDockView release];
        bgDockView = nil;
    }
    
    if (scrollView) {
        [scrollView removeFromSuperview];
        [scrollView release];
        scrollView = nil;
    }
    
    if (dockView) {
        [dockView removeFromSuperview];
        [dockView release];
        dockView = nil;
    }
    
    if (backgroundView) {
        [backgroundView removeFromSuperview];
        [backgroundView release];
        backgroundView = nil;
    }
    
    [BlockDataSource cleanBlockDataSource];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.curPageNumber = 1;
        self.blockViewWidth = 0.0;
        self.blockViewHeight = 0.0;
        self.curEditState = NO;
        
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
        self.blockViewDict = tDict;
        [tDict release];
    }
    
    return self;
}

- (void)loadBlockDataSource {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    self.blockViewWidth = (self.bounds.size.width-MaginLeft-MaginRight)/blockDataSource.cols;
    self.blockViewHeight = (self.bounds.size.height-MaginBottom)/blockDataSource.rows;
    
    [blockDataSource loadDataSource];
}

- (int)getTotalPage {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    int count = blockDataSource.blockPages==nil ? 0 : [blockDataSource.blockPages count];
    return count;
}

- (void)changeContentSize {
    CGSize size = self.scrollView.bounds.size;
    size.width *= [self getTotalPage];
    CGRect rect = self.contentView.frame;
    rect.size = size;
    self.contentView.frame = rect;
    self.scrollView.contentSize = size;
}

- (void)addScrollView {
    if (self.scrollView == nil) {
        UIScrollView *tScrollView = [[UIScrollView alloc] init];
        self.scrollView = tScrollView;
        [tScrollView release];
        
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = YES;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.pagingEnabled = NO;
        self.scrollView.decelerationRate = 0.0;
        
        [self addSubview:self.scrollView];
        [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    self.scrollView.frame = self.bounds;
    
    if (self.contentView == nil) {
        UIView *tView = [[UIView alloc] init];
        self.contentView = tView;
        [tView release];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.contentView];
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    self.contentView.frame = self.scrollView.bounds;
}

- (void)addBgDockView {
    if (self.bgDockView == nil) {
        BlockDockView *tDockView = [[BlockDockView alloc] init];
        self.bgDockView = tDockView;
        [tDockView release];
        
        CGRect rect = self.bounds;        
        rect.origin.y = rect.size.height-DockViewHeight;
        rect.size.height = DockViewHeight;
        self.bgDockView.frame = rect;
        
        [self addSubview:self.bgDockView];
        [self.bgDockView layoutDockView];
    }
}

- (void)addDockView {
    if (self.dockView == nil) {
        BlockDockView *tDockView = [[BlockDockView alloc] init];
        self.dockView = tDockView;
        [tDockView release];
        
        CGRect rect = self.bounds;        
        rect.origin.y = rect.size.height-DockViewHeight;
        rect.size.height = DockViewHeight;
        self.dockView.frame = rect;
        
        [self addSubview:self.dockView];
    }
}

- (void)addBackgroundView {
    if (self.backgroundView == nil) {
        BlockBackgroundView *tBackgroundView = [[BlockBackgroundView alloc] init];
        self.backgroundView = tBackgroundView;
        [tBackgroundView release];
        
        CGRect rect = self.bounds;
        self.backgroundView.frame = rect;
        
        self.backgroundView.topImageViewHeight = rect.size.height*0.5;
        [self addSubview:self.backgroundView];
        [self.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.backgroundView layoutBlockBackgroundView];
        
        self.backgroundView.folderView.delegate = self;
    }
}

- (CGRect)calculateBlockViewFrame:(int)index inPage:(int)pageNumber {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    int row = index/blockDataSource.cols;
    int col = index%blockDataSource.cols;
    
    CGFloat start_x = MaginLeft+self.bounds.size.width*(pageNumber-1);
    CGRect rect = CGRectMake(start_x+col*self.blockViewWidth, row*self.blockViewHeight, self.blockViewWidth, self.blockViewHeight);
    
    return rect;
}

- (CGRect)calculateBlockViewInDockFrame:(int)index {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    CGFloat w = self.bounds.size.width/[blockDataSource.docks count];
    CGFloat x = (w-self.blockViewWidth)*0.5;
    CGFloat y = self.dockView.bounds.size.height-self.blockViewHeight-2;
    CGRect rect = CGRectMake(x+index*w, y, self.blockViewWidth, self.blockViewHeight);
    
    return rect;
}

- (BlockView*)getBlockViewByBlockModel:(BlockModel*)blockModel {
    if (blockModel == nil || [self.curDragingView.blockModel.pk isEqualToString:blockModel.pk]) {
        return nil;
    }
    
    BlockView *blockView = nil;
    NSArray *allKey = [self.blockViewDict allKeys];
    for (NSString *key in allKey) {
        BlockView *tBlockView = (BlockView*)[self.blockViewDict objectForKey:key];
        if ([key isEqualToString:blockModel.pk]) {
            blockView = tBlockView;
            break;
        }
    }
    if (blockView == nil) {
        blockView = [[[BlockView alloc] initWithFrame:CGRectZero] autorelease];
        blockView.blockModel = blockModel;
        [self.blockViewDict setObject:blockView forKey:blockView.blockModel.pk];
    }
    
    return blockView;
}

- (BOOL)checkPageNumberIsEnable:(int)pageNumber {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    return pageNumber > 0 && pageNumber <= [blockDataSource.blockPages count];
}

- (void)addBlockViewsInPage:(int)pageNumber {
    if ([self checkPageNumberIsEnable:pageNumber]) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        NSObject *obj = [blockDataSource.blockPages objectAtIndex:pageNumber-1];
        if (obj != nil) {
            int index = 0;
            NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
            for (BlockPageItemModel *blockPageItemModel in blockPageItemModels) {
                BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
                if (blockModel != nil) {
                    BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
                    blockView.pageNumber = pageNumber;
                    CGRect rect = [self calculateBlockViewFrame:index inPage:pageNumber];
                    if (!CGRectEqualToRect(blockView.frame, rect)) {
                        blockView.frame = rect;
                        blockView.originalRect = blockView.frame;
                    }
                    if (blockView != nil && blockView.superview != self.contentView) {
                        blockView.delegate = self;
                        blockView.curEditState = self.curEditState;                        
                        [self.contentView addSubview:blockView];
                        [blockView layoutBlockView];
                    }
                    
                    index++;
                }
            }
        }
    }
}

- (void)addBlockViewsInDock {
    int index = 0;
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    for (BlockPageItemModel *blockPageItemModel in blockDataSource.docks) {
        BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
        if (blockModel != nil) {
            BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
            blockView.pageNumber = 0;
            CGRect rect = [self calculateBlockViewInDockFrame:index];
            if (!CGRectEqualToRect(blockView.frame, rect)) {
                blockView.frame = rect;
                blockView.originalRect = blockView.frame;
            }
            if (blockView != nil && blockView.superview != self) {
                blockView.delegate = self;
                blockView.curEditState = self.curEditState;                        
                [self.dockView addSubview:blockView];
                [blockView layoutBlockView];
                
                [blockView addSimpleReflectionLayer:YES];
            }
            
            index++;
        }
    }
}

- (void)addBlockViews:(int)pageNumber {
    [self addBlockViewsInPage:pageNumber];
    
    [self addBlockViewsInPage:pageNumber-1];
    [self addBlockViewsInPage:pageNumber+1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)gestureRecognizer;
        if (tapGestureRecognizer.numberOfTapsRequired == 1) {
            if (self.openedView != nil && !self.isOpeningFolderAnimation && !self.isClosingFolderAnimation) {
                CGPoint point = [touch locationInView:self];
                CGRect rect = self.backgroundView.folderView.textField.frame;
                rect = [self convertRect:rect fromView:self.backgroundView.folderView];
                if (self.keyBoardIsShowed) {
                    if (!CGRectContainsPoint(rect, point)) {
                        [self.backgroundView.folderView.textField resignFirstResponder];
                    }
                    
                    return NO;
                }
                
                rect = self.backgroundView.folderView.frame;
                if (self.backgroundView.folderView.superview != self) {
                    rect = [self convertRect:rect fromView:self.backgroundView];
                }
                if (!CGRectContainsPoint(rect, point)) {
                    return YES;
                }
            }
        } else if (tapGestureRecognizer.numberOfTapsRequired == 2) {
            if (self.curEditState) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)modifyCurState:(BOOL)state withOutBlockView:(BlockView*)v {
    self.curEditState = state;
    
    NSArray *allKey = [self.blockViewDict allKeys];
    for (NSString *key in allKey) {
        BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
        blockView.curEditState = self.curEditState;
        [blockView changeRemoveBtnStateByAnimation:YES];
        
        if (blockView != v) {
            [blockView shake:self.curEditState];
        }
    }
    
    if (self.openedView != nil) {
        self.backgroundView.folderView.curEditState = self.curEditState;
    }
}

- (void)removeEmptyPages {
    NSArray *allkey = [self.blockViewDict allKeys];
    
    NSMutableArray *removeEmptyArray = [NSMutableArray array];
    int index = 0;
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    for (NSArray *itemModelArray in blockDataSource.blockPages) {
        index++;
        if ([itemModelArray count] == 0) {
            [removeEmptyArray addObject:itemModelArray];
            
            for (NSString *key in allkey) {
                BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
                if (index < blockView.pageNumber) {
                    blockView.pageNumber--;
                }
            }
            
            if (index < self.curPageNumber) {
                self.curPageNumber--;
                index--;
            } else if (index >= self.curPageNumber) {
                index--;
            }
        }         
    }
    
    [blockDataSource.blockPages removeObjectsInArray:removeEmptyArray];
    
    int count = [blockDataSource.blockPages count];
    if (self.curPageNumber > count) {
        self.curPageNumber = count;
    }
    
    if (self.curPageNumber <= 0) {
        self.curPageNumber = 1;
    }
    
    if ([blockDataSource.blockPages count] == 0) {
        [blockDataSource addEmptyPage];
    }
}

- (void)handleDoubleTap:(UISwipeGestureRecognizer*)recognizer {
    NSLog(@"+++++++++++handleDoubleTap");
    
    [self modifyCurState:NO withOutBlockView:nil];
    
    [self removeEmptyPages];
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    [blockDataSource saveCurBlockDatasInToPlistFile];
    
    [self turnToPage:self.curPageNumber animation:NO];
}

- (void)addTapGestureRecognizers {
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
	singleTapRecognizer.delegate = self;
	[self addGestureRecognizer:singleTapRecognizer];
	[singleTapRecognizer release];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.delegate = self;
	[self addGestureRecognizer:doubleTapRecognizer];
	[doubleTapRecognizer release];
}

- (void)layoutBlockScrollView {
    [self loadBlockDataSource];
    
    [self addBackgroundView];
    [self addBgDockView];
    [self addScrollView];
    [self addDockView];
    
    [self cleanBlockViews];
    [self addBlockViews:self.curPageNumber];
    [self addBlockViewsInDock];
    
    [self addTapGestureRecognizers];
}

//============BlockFolderViewDelegate============
- (void)keyboardWillShow {
    self.keyBoardIsShowed = YES;
    
    CGRect rect = self.openedView.frame;
    if (self.openedView.superview == self.dockView) {
        rect = [self convertRect:rect fromView:self.dockView];
    } else {
        rect = [self convertRect:rect fromView:self.contentView];
    }
    
    if (rect.origin.y+rect.size.height > 220) {
        [UIView beginAnimations:@"keyboardWillShow" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.2];
        rect = self.frame;
        rect.origin.y = -150.0;
        self.frame = rect;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide {
    self.keyBoardIsShowed = NO;
    
    CGRect rect = self.openedView.frame;
    if (self.openedView.superview == self.dockView) {
        rect = [self convertRect:rect fromView:self.dockView];
    } else {
        rect = [self convertRect:rect fromView:self.contentView];
    }
    
    if (rect.origin.y+rect.size.height > 220) {
        [UIView beginAnimations:@"keyboardWillHide" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.2];
        rect = self.frame;
        rect.origin.y = 0.0;
        self.frame = rect;
        [UIView commitAnimations];
    }
}

- (void)BlockFolderView:(BlockFolderView*)v textFieldDidBeginEditing:(void*)a {
    [self keyboardWillShow];
}

- (void)BlockFolderView:(BlockFolderView*)v textFieldDidEndEditing:(void*)a {
    [self keyboardWillHide];
}

- (void)turnToPageFinish {
    self.isAnimationing = NO;
        
    if (self.curDragingView != nil && self.curDragingView.superview == self) {
        CGRect rect = self.curDragingView.frame;
        rect.origin.x += self.weiyi;
        self.curDragingView.frame = rect;
        [self.contentView addSubview:self.curDragingView];
    }
    
    NSArray *allKey = [self.blockViewDict allKeys];
    NSMutableArray *removeKeys = [NSMutableArray array];
    for (NSString *key in allKey) {
        BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
        if (blockView != self.curDragingView && blockView.pageNumber != 0 && (blockView.pageNumber < self.curPageNumber-1 || blockView.pageNumber > self.curPageNumber+1)) {            
            blockView.delegate = nil;
            [blockView removeFromSuperview];
            [removeKeys addObject:key];
        }
    }
    [self.blockViewDict removeObjectsForKeys:removeKeys];
    
    [self addBlockViews:self.curPageNumber];
}

- (void)openFolderFinish {
    self.isOpeningFolderAnimation = NO;
    
    CGRect rect = self.backgroundView.folderView.frame;
    rect = [self convertRect:rect fromView:self.backgroundView];
    self.backgroundView.folderView.frame = rect;
    if (self.curDragingView == nil) {
        [self insertSubview:self.backgroundView.folderView aboveSubview:self.scrollView];
    } else {
        [self insertSubview:self.backgroundView.folderView belowSubview:self.scrollView];
    }
}

- (void)modifyAllBlockViewsState:(BOOL)state {
    NSArray *allKey = [self.blockViewDict allKeys];
    for (NSString *key in allKey) {
        BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
        
        if (blockView.pageNumber != -1 && blockView != self.curDragingView) {
            blockView.curEditState = state;
            [blockView changeRemoveBtnStateByAnimation:state];        
            [blockView shake:state];
        }        
    }
}

- (void)cleanFolderBlockViews {
    NSArray *allKey = [self.blockViewDict allKeys];
    NSMutableArray *removeKeys = [NSMutableArray array];
    for (NSString *key in allKey) {
        BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
        if (blockView != self.curDragingView && blockView.pageNumber == -1) {            
            blockView.delegate = nil;
            [blockView removeFromSuperview];
            [removeKeys addObject:key];
        }
    }
    [self.blockViewDict removeObjectsForKeys:removeKeys];
}

- (void)modifyBlockViewFramesInPage:(int)pageNumber {
    if ([self checkPageNumberIsEnable:pageNumber]) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        NSObject *obj = [blockDataSource.blockPages objectAtIndex:pageNumber-1];
        if (obj != nil) {
            int index = 0;
            NSMutableArray *blockPageItemModels = (NSMutableArray*)obj;
            for (BlockPageItemModel *blockPageItemModel in blockPageItemModels) {
                BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
                if (blockModel != nil) {
                    BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
                    blockView.pageNumber = pageNumber;
                    if (blockView != nil && blockView != self.curDragingView) {
                        blockView.frame = [self calculateBlockViewFrame:index inPage:pageNumber];
                        blockView.originalRect = blockView.frame;
                    }
                    index++;
                }
            }
        }
    }
}

- (void)modifyBlockViewFrames:(BOOL)isAnimation {
    if (isAnimation) {
		[UIView beginAnimations:@"modifyBlockViewFrames" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	}
	
    [self modifyBlockViewFramesInPage:self.curPageNumber];
    [self modifyBlockViewFramesInPage:self.curPageNumber-1];
    [self modifyBlockViewFramesInPage:self.curPageNumber+1];
	
	if (isAnimation) {
		[UIView commitAnimations];
	}
}

- (int)getMoveToIndex:(CGPoint)point {
    int col = point.x/self.blockViewWidth;
    int row = point.y/self.blockViewHeight;
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    int moveToIndex = row*blockDataSource.cols+col;
    int count = [blockDataSource getCountInpage:self.curPageNumber];
    if (moveToIndex > count) {
        moveToIndex = count;
    }
    
    return moveToIndex;
}

- (void)closeFolderFinish {
    if (self.backgroundView.isTop) {
        [self.openedView showOrHideBlockTitleLabel:YES];
    }
    
    self.backgroundView.topTriangleView.alpha = 0.0;
    self.backgroundView.bottomTriangleView.alpha = 0.0;
    
    if (self.curEditState == YES) {
        [self modifyAllBlockViewsState:YES];
    }
    
    [self cleanFolderBlockViews];
    
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    int count = [blockDataSource getCountInFolder:self.openedView.blockModel.pk];
    if (count == 1) {
        BlockPageItemModel *itemModel = (BlockPageItemModel*)[[(BlockFolderModel*)self.openedView.blockModel blocks] objectAtIndex:0];
        BlockModel *model = [blockDataSource findBlockModelByPK:itemModel.blockPK];
        
        if (self.openedView.pageNumber > 0) {
            CGPoint point = CGPointMake(self.openedView.originalRect.origin.x+10-self.weiyi, self.openedView.originalRect.origin.y+10);
            int moveToIndex = [self getMoveToIndex:point];
            [blockDataSource addBlockModel:model inPage:self.openedView.pageNumber toIndex:moveToIndex];
            
            BlockView *blockView = [self getBlockViewByBlockModel:model];
            blockView.pageNumber = self.openedView.pageNumber;
            blockView.frame = self.openedView.originalRect;
            blockView.originalRect = blockView.frame;
            blockView.delegate = self;
            blockView.curEditState = self.curEditState;                        
            [self.contentView insertSubview:blockView belowSubview:self.openedView];
            [blockView layoutBlockView];
            
            [blockDataSource removeBlockModelByBlockPk:self.openedView.blockModel.pk];
            [blockDataSource removePageItemModelByBlockPK:self.openedView.blockModel.pk inPage:self.curPageNumber withFlag:NO];
            [self.blockViewDict removeObjectForKey:self.openedView.blockModel.pk];
            self.openedView.delegate = nil;
            [self.openedView removeFromSuperview];
        } else {
            CGFloat w = self.bounds.size.width/([blockDataSource.docks count]+1);
            int moveToIndex = (self.openedView.originalRect.origin.x+10)/w;
            [blockDataSource addBlockModel:model toDockIndex:moveToIndex];
            
            BlockView *blockView = [self getBlockViewByBlockModel:model];
            blockView.pageNumber = self.openedView.pageNumber;
            blockView.frame = self.openedView.originalRect;
            blockView.originalRect = blockView.frame;
            blockView.delegate = self;
            blockView.curEditState = self.curEditState;                        
            [self.dockView insertSubview:blockView belowSubview:self.openedView];
            [blockView layoutBlockView];
            
            [blockDataSource removeBlockModelByBlockPk:self.openedView.blockModel.pk];
            [blockDataSource removeDockItemByBlockPk:self.openedView.blockModel.pk inDock:NO];
            [self.blockViewDict removeObjectForKey:self.openedView.blockModel.pk];
            self.openedView.delegate = nil;
            [self.openedView removeFromSuperview];
        }
    }
    
    [self modifyBlockViewFrames:YES];
    
    self.openedView = nil;
    self.isClosingFolderAnimation = NO;
}

- (void)UIViewAnimationsDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if ([@"turnToPage" isEqualToString:animationID]) {
        [self turnToPageFinish];
    } else if ([@"modifyCurDragingViewFrameWithAnimation" isEqualToString:animationID]) {
        if (self.openedView != nil && !self.isClosingFolderAnimation) {
            [self insertSubview:self.backgroundView.folderView aboveSubview:self.scrollView];
        }
        
        if (self.curDragingView.pageNumber == 0) {        
            self.curDragingView.frame = self.curDragingView.originalRect;
            [self.dockView addSubview:self.curDragingView];
            
            [self.curDragingView addSimpleReflectionLayer:YES];
        } else if (self.curDragingView.pageNumber == -1) {
            self.curDragingView.frame = [self.backgroundView.folderView.contentView convertRect:self.curDragingView.frame fromView:self.contentView];
            self.curDragingView.originalRect = self.curDragingView.frame;
            [self.backgroundView.folderView.contentView addSubview:self.curDragingView];
        }
        
        self.curDragingView = nil;
        
        [self insertSubview:self.dockView aboveSubview:self.scrollView];
    } else if ([@"openFolder" isEqualToString:animationID]) {
        [self openFolderFinish];
    } else if ([@"closeFolder" isEqualToString:animationID]) {
        [self closeFolderFinish];
    } else if ([@"modifyBlockViewInFolderFrames" isEqualToString:animationID]) {
        
    }
}

- (void)turnToPage:(int)pageNumber animation:(BOOL)isAnimation {
    if (self.openedView != nil || ![self checkPageNumberIsEnable:pageNumber]) {
        return ;
	}
    
	self.curPageNumber = pageNumber;
    self.weiyi = (self.curPageNumber-1)*self.bounds.size.width;

	if (isAnimation) {
		[UIView beginAnimations:@"turnToPage" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	}
	
    self.isAnimationing = YES;
    
    CGPoint point = CGPointMake(self.bounds.size.width*(self.curPageNumber-1), 0.0);
    self.scrollView.contentOffset = point;
	
	if (isAnimation) {
		[UIView commitAnimations];
	} else {
        [self turnToPageFinish];
    }
    
    [self changeContentSize];
}

- (void)logginSuccess:(BlockModel*)blockModel {
    BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
    [blockView logginSuccess];
}

//================BlockViewDelegate================
- (void)handleAllBlockViewsAndDockViewWithTopMoview:(CGFloat)topImageMovie withBottomMovie:(CGFloat)bottomImageMovie withAlpha:(CGFloat)alpha {
    CGRect openedViewFrame = self.openedView.frame;
    if (self.openedView.superview == self.dockView) {
        openedViewFrame = [self convertRect:openedViewFrame fromView:self.dockView];
    }
    NSArray *allKeys = [self.blockViewDict allKeys];
    for (NSString *key in allKeys) {
        BlockView *blockView = (BlockView*)[self.blockViewDict objectForKey:key];
        if (blockView.pageNumber == self.curPageNumber) {
            CGRect rect = blockView.frame;
            if (blockView == self.openedView) {
                rect.origin.y = rect.origin.y-topImageMovie;
                blockView.frame = rect;
            } else if (blockView != self.curDragingView) {
                if (rect.origin.y <= openedViewFrame.origin.y) {
                    rect.origin.y = rect.origin.y-topImageMovie;
                } else {                    
                    rect.origin.y = rect.origin.y+bottomImageMovie;                    
                }
                blockView.frame = rect;
                blockView.alpha = alpha;
            }
        }
    }
    
    CGRect rect = self.dockView.frame;
    rect.origin.y = rect.origin.y+bottomImageMovie;
    self.dockView.frame = rect;
    
    self.bgDockView.frame = rect;
    self.bgDockView.alpha = alpha;
}

- (void)openFolderWithAnimation {
    [UIView beginAnimations:@"openFolder" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	
    CGFloat bottomImageMovie = self.backgroundView.bottomImageView.frame.origin.y+self.folderHeight;
    
    CGFloat linjie = 358;
    CGFloat topImageMovie = 0.0;
    if (bottomImageMovie > linjie) {        
        topImageMovie = bottomImageMovie-linjie;
        bottomImageMovie = linjie;
    }
    bottomImageMovie -= self.backgroundView.bottomImageView.frame.origin.y;
    
    CGRect topImageViewFrame = self.backgroundView.topImageView.frame;
    topImageViewFrame.origin.y -= topImageMovie;
    self.backgroundView.topImageView.frame = topImageViewFrame;
    
    CGRect folderViewFrame = self.backgroundView.folderView.frame;
    folderViewFrame.origin.y = topImageViewFrame.origin.y+topImageViewFrame.size.height;
    self.backgroundView.folderView.frame = folderViewFrame;
    
    CGRect bottomImageViewFrame = self.backgroundView.bottomImageView.frame;
    bottomImageViewFrame.origin.y += bottomImageMovie;
    self.backgroundView.bottomImageView.frame = bottomImageViewFrame;
    
    if (self.backgroundView.isTop) {
        CGRect topFolderTriangleViewFrame = self.backgroundView.topTriangleView.frame;
        topFolderTriangleViewFrame.origin.y = folderViewFrame.origin.y-topFolderTriangleViewFrame.size.height;
        self.backgroundView.topTriangleView.frame = topFolderTriangleViewFrame;
        
        CGRect bottomFolderTriangleViewFrame = self.backgroundView.bottomTriangleView.frame;
        bottomFolderTriangleViewFrame.origin.y += bottomImageMovie;
        self.backgroundView.bottomTriangleView.frame = bottomFolderTriangleViewFrame;
        self.backgroundView.bottomTriangleView.alpha = 0.0;
    } else {
        CGRect bottomFolderTriangleViewFrame = self.backgroundView.bottomTriangleView.frame;
        bottomFolderTriangleViewFrame.origin.y = folderViewFrame.origin.y;
        self.backgroundView.bottomTriangleView.frame = bottomFolderTriangleViewFrame;
        self.backgroundView.bottomTriangleView.alpha = 0.0;
        
        CGRect topFolderTriangleViewFrame = self.backgroundView.topTriangleView.frame;
        topFolderTriangleViewFrame.origin.y += bottomImageMovie;
        self.backgroundView.topTriangleView.frame = topFolderTriangleViewFrame;
    }
    
    [self handleAllBlockViewsAndDockViewWithTopMoview:topImageMovie withBottomMovie:bottomImageMovie withAlpha:0.25];
    
	[UIView commitAnimations];
}

- (void)closeFolderWithAnimation {
    [UIView beginAnimations:@"closeFolder" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
    
    CGRect topImageViewFrame = self.backgroundView.topImageView.frame;
    CGFloat topImageMovie = 0-topImageViewFrame.origin.y;
    topImageViewFrame.origin.y = 0;
    self.backgroundView.topImageView.frame = topImageViewFrame;
    
    CGRect folderViewFrame = self.backgroundView.folderView.frame;
    folderViewFrame.origin.y = topImageViewFrame.origin.y+topImageViewFrame.size.height;
    self.backgroundView.folderView.frame = folderViewFrame;
    
    CGRect bottomImageViewFrame = self.backgroundView.bottomImageView.frame;
    CGFloat bottomImageMovie = bottomImageViewFrame.origin.y-(topImageViewFrame.origin.y+topImageViewFrame.size.height);
    bottomImageViewFrame.origin.y = topImageViewFrame.origin.y+topImageViewFrame.size.height;
    self.backgroundView.bottomImageView.frame = bottomImageViewFrame;
    
    if (self.backgroundView.isTop) {
        CGRect topFolderTriangleViewFrame = self.backgroundView.topTriangleView.frame;
        topFolderTriangleViewFrame.origin.y = folderViewFrame.origin.y-topFolderTriangleViewFrame.size.height;
        self.backgroundView.topTriangleView.frame = topFolderTriangleViewFrame;
        
        CGRect bottomFolderTriangleViewFrame = self.backgroundView.bottomTriangleView.frame;
        bottomFolderTriangleViewFrame.origin.y = bottomImageViewFrame.origin.y-bottomFolderTriangleViewFrame.size.height;
        self.backgroundView.bottomTriangleView.frame = bottomFolderTriangleViewFrame;
    } else {
        CGRect bottomFolderTriangleViewFrame = self.backgroundView.bottomTriangleView.frame;
        bottomFolderTriangleViewFrame.origin.y = folderViewFrame.origin.y;
        self.backgroundView.bottomTriangleView.frame = bottomFolderTriangleViewFrame;
        
        CGRect topFolderTriangleViewFrame = self.backgroundView.topTriangleView.frame;
        topFolderTriangleViewFrame.origin.y = bottomImageViewFrame.origin.y;
        self.backgroundView.topTriangleView.frame = topFolderTriangleViewFrame;
    }
    
    [self handleAllBlockViewsAndDockViewWithTopMoview:-topImageMovie withBottomMovie:-bottomImageMovie withAlpha:1.0];
    
	[UIView commitAnimations];
}

- (void)addBlockViewsInFolder {
    int index = 0;
    for (BlockPageItemModel *blockPageItemModel in self.backgroundView.folderView.blockModel.blocks) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
        if (blockModel != nil) {
            BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
            
            blockView.pageNumber = -1;
            CGRect rect = [self.backgroundView.folderView calculateBlockViewFrame:index];
            if (!CGRectEqualToRect(blockView.frame, rect)) {
                blockView.frame = rect;
                blockView.originalRect = blockView.frame;
            }
            if (blockView != nil && blockView.superview != self.backgroundView.folderView.contentView) {
                blockView.delegate = self;
                blockView.curEditState = self.curEditState;                        
                [self.backgroundView.folderView.contentView addSubview:blockView];
                [blockView layoutBlockView];
            }
            
            if (blockView.curEditState) {
                [blockView changeRemoveBtnStateByAnimation:NO];
                [blockView shake:YES];
            }            

            index++;
        }
    }
}

- (void)openFolderAction {
    self.isOpeningFolderAnimation = YES;
    
    self.backgroundView.isTop = YES;
    
    CGRect openedViewFrame = self.openedView.frame;
    CGFloat topImageViewHeight = openedViewFrame.origin.y+openedViewFrame.size.height+5; 
    if (self.openedView.superview == self.dockView) {
        openedViewFrame = [self convertRect:openedViewFrame fromView:self.dockView];
        topImageViewHeight = openedViewFrame.origin.y-12;
        
        self.backgroundView.isTop = NO;
        self.backgroundView.folderTriangleViewOriginx = openedViewFrame.origin.x;
    } else {
        self.backgroundView.folderTriangleViewOriginx = openedViewFrame.origin.x-weiyi;
    }
    self.backgroundView.topImageViewHeight = topImageViewHeight;
    
    [self.backgroundView setTopImageViewFrame];
    [self.backgroundView setBottomImageViewFrame];
    [self.backgroundView setFolderTriangleViewFrame];
    
    self.backgroundView.folderView.blockModel = (BlockFolderModel*)self.openedView.blockModel;
    self.backgroundView.folderView.blockViewWidth = self.blockViewWidth;
    self.backgroundView.folderView.blockViewHeight = self.blockViewHeight;
    self.folderHeight = [self.backgroundView.folderView calculateFolderHeightWithFlag:self.beginAddInFolder];
    [self.backgroundView setFolderViewFrame:folderHeight];
    self.backgroundView.folderView.curEditState = self.curEditState;
    
    [self addBlockViewsInFolder];
    [self modifyAllBlockViewsState:NO];
    
    self.backgroundView.topTriangleView.alpha = 1.0;
    self.backgroundView.bottomTriangleView.alpha = 1.0;
    if (self.backgroundView.isTop) {
        [self.openedView showOrHideBlockTitleLabel:NO];
    }
    [self performSelector:@selector(openFolderWithAnimation) withObject:nil afterDelay:0.001];
}

- (void)closeFolderAction {
    CGRect rect = self.backgroundView.folderView.frame;
    rect = [self convertRect:rect toView:self.backgroundView];
    self.backgroundView.folderView.frame = rect;
    [self.backgroundView insertSubview:self.backgroundView.folderView atIndex:0];
    
    self.backgroundView.topTriangleView.alpha = 1.0;
    self.backgroundView.bottomTriangleView.alpha = 1.0;
    [self closeFolderWithAnimation];
}

- (void)handleSingleTap:(UISwipeGestureRecognizer*)recognizer {
    self.isClosingFolderAnimation = YES;
    [self closeFolderAction];
}

- (void)BlockView:(BlockView*)v didPan:(UIPanGestureRecognizer*)recognizer {
    if (self.openedView == nil && [v.blockModel.showType isEqualToString:@"folder"]) {
        self.openedView = v;
        
        [self openFolderAction];
        return;
    }
    
    if (self.openedView != nil && v.pageNumber != -1) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(BlockScrollView:didOpen:)]) {
        [self.delegate BlockScrollView:self didOpen:v];
    }
}

- (void)modifyBlockViewDockFrames {
    [UIView beginAnimations:@"modifyBlockViewDockFrames" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	
    int index = 0;
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    for (BlockPageItemModel *blockPageItemModel in blockDataSource.docks) {
        BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
        if (blockModel != nil) {
            BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
            blockView.pageNumber = 0;
            if (blockView != nil && blockView != self.curDragingView) {
                blockView.frame = [self calculateBlockViewInDockFrame:index];
                blockView.originalRect = blockView.frame;
            }
            index++;
        }
    }
    
	[UIView commitAnimations];
}

- (void)setCanPageing {
	self.canPageing = YES;
}

- (void)modifyCurDragingViewFrameWithAnimation {
    [UIView beginAnimations:@"modifyCurDragingViewFrameWithAnimation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	
    CGRect rect = self.curDragingView.originalRect;
    if (self.curDragingView.pageNumber == 0) {
        rect = [self.dockView convertRect:rect toView:self.curDragingView.superview];
    } else if (self.curDragingView.pageNumber == -1) {
        rect.origin.x += self.weiyi;
    }
    self.curDragingView.frame = rect;
    
    if (self.curDragingView.superview == self && self.curDragingView.pageNumber != -1) {
        [self.contentView addSubview:self.curDragingView];
    }
	
	[UIView commitAnimations];
}

- (BlockView*)getBlockViewByPoint:(CGPoint)point inPage:(int)pageNumber {
    BlockView *blockView = nil;
    NSArray *allKey = [self.blockViewDict allKeys];
    for (NSString *key in allKey) {
        BlockView *tBlockView = (BlockView*)[self.blockViewDict objectForKey:key];        
        CGRect rect = tBlockView.originalRect;
        rect.origin.x -= self.weiyi;
        if (tBlockView.pageNumber == pageNumber && CGRectContainsPoint(rect, point)) {
            blockView = tBlockView;
            break;
        }
    }
    
    return blockView;
}

- (void)addInFolder {
    if (![self.curAddInView.blockModel.showType isEqualToString:@"folder"]) {   
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        BlockFolderModel *folderModel = [blockDataSource createBlockFolderModel:self.curAddInView.blockModel];                
        [blockDataSource addBlockFolderModel:folderModel inPage:self.curPageNumber toIndex:self.folderIndex];
        [blockDataSource removePageItemModelByBlockPK:self.curAddInView.blockModel.pk inPage:self.curPageNumber withFlag:NO];
        [blockDataSource addBlockModel:self.curAddInView.blockModel inFolderModel:folderModel toIndex:100];
        
        BlockView *folderView = [self getBlockViewByBlockModel:folderModel];
        self.openedView = folderView;
        
        self.openedView.pageNumber = self.curPageNumber;
        CGRect rect = [self calculateBlockViewFrame:self.folderIndex inPage:self.curPageNumber];
        self.openedView.frame = rect;
        self.openedView.originalRect = self.openedView.frame;
        self.openedView.delegate = self;
        self.openedView.curEditState = self.curEditState;                     
        [self.contentView insertSubview:self.openedView belowSubview:self.curAddInView];
        [self.openedView layoutBlockView];
        [self.openedView scaleBorder:NO];
        
        self.curAddInView.pageNumber = -1;
        [self.curAddInView setBorderWidth:NO];
        [self.curAddInView scaleBorder:NO];
        [self.curAddInView removeFromSuperview];
    } else {
        self.openedView = self.curAddInView;
        [self.curAddInView setBorderWidth:YES];
        [self.openedView scaleBorder:NO];
    }
    
    self.curDragingView.pageNumber = -1;
    
    [self openFolderAction];
    
    self.removeFromFolder = YES;
}

- (void)movieBlockView:(BlockView*)v toIndex:(int)moveToIndex {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addInFolder) object:nil];
    
    self.timeInterval = 0;
    self.beginAddInFolder = NO;
    self.curAddInView = nil;
    
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    [blockDataSource addCurDragingBlockPageItemModelToIndex:moveToIndex inPage:self.curPageNumber];
    
    [self modifyBlockViewFrames:YES];
    v.pageNumber = self.curPageNumber;
    v.originalRect = [self calculateBlockViewFrame:moveToIndex inPage:self.curPageNumber];
}

- (void)handleCurPageBlockViews:(BlockView*)v {
    self.folderIndex = [self getMoveToIndex:self.endDragPoint];
    
    if ([v.blockModel.showType isEqualToString:@"folder"] || [v.blockModel.type isEqualToString:@"add"] || [v.blockModel.type isEqualToString:@"setting"] || [v.blockModel.type isEqualToString:@"download"]) {
        [self movieBlockView:v toIndex:self.folderIndex];
        return;
    }
    
    BlockView *blockView = [self getBlockViewByPoint:self.endDragPoint inPage:self.curPageNumber];
    
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    if (blockView == nil || ([blockView.blockModel.showType isEqualToString:@"folder"] && ![blockDataSource canAddInFolder:blockView.blockModel.pk]) || [blockView.blockModel.type isEqualToString:@"add"] || [blockView.blockModel.type isEqualToString:@"setting"] || [blockView.blockModel.type isEqualToString:@"download"]) {
        [self movieBlockView:v toIndex:self.folderIndex];
        return;
    }
    
    CGRect rect = blockView.originalRect;
    rect.origin.x -= self.weiyi;
    CGRect curRect = v.originalRect;
    curRect.origin.x -= self.weiyi;
    
    if (curRect.origin.x < rect.origin.x) {
        rect.origin.x += self.blockViewWidth*0.7;
    }
    rect.size.width = self.blockViewWidth*0.3;
    
    if (CGRectContainsPoint(rect, self.endDragPoint)) {
        if (self.curAddInView != nil) {
            if ([self.curAddInView.blockModel.showType isEqualToString:@"folder"]) {
                [self.curAddInView setBorderWidth:YES];
            } else {
                [self.curAddInView setBorderWidth:NO];
            }
            [self.curAddInView scaleBorder:NO];
        }
        
        if (self.openedView == nil) {
            [self movieBlockView:v toIndex:self.folderIndex];
        }
    } else {
        CGRect availableRect = blockView.bgImageView.frame;
        availableRect.origin.x += blockView.frame.origin.x-self.weiyi;
        availableRect.origin.y += blockView.frame.origin.y;
        if (CGRectContainsPoint(availableRect, self.endDragPoint)) {
            NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
            if (self.timeInterval == 0) {
                self.timeInterval = curTimeInterval;
                self.beginAddInFolder = YES;
                self.curAddInView = blockView;
                [self.curAddInView setBorderWidth:YES];
                [self.curAddInView scaleBorder:YES];
                
                [self performSelector:@selector(addInFolder) withObject:nil afterDelay:1.0];
            }
        } else {            
            if (self.curAddInView != nil) {
                if ([self.curAddInView.blockModel.showType isEqualToString:@"folder"]) {
                    [self.curAddInView setBorderWidth:YES];
                } else {
                    [self.curAddInView setBorderWidth:NO];
                }
                [self.curAddInView scaleBorder:NO];
            }
            
            if (self.openedView == nil) {
                if (!self.removeFromDock) {
                    CGPoint point = CGPointMake(v.originalRect.origin.x+10-self.weiyi, v.originalRect.origin.y+10);
                    self.folderIndex = [self getMoveToIndex:point];
                }
                [self movieBlockView:v toIndex:self.folderIndex];
            }
        }
    }
}

- (void)handleDockBlockViews:(BlockView*)v byPoint:(CGPoint)point {
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    CGFloat w = self.bounds.size.width/([blockDataSource.docks count]+1);
    int moveToIndex = point.x/w;
    [blockDataSource addCurDragingBlockPageItemModelToDockIndex:moveToIndex]; 
    
    v.pageNumber = 0;
    v.originalRect = [self calculateBlockViewInDockFrame:moveToIndex];
    
    [self modifyBlockViewDockFrames];
}

- (void)setFolderBlockViewsFrame {
    int index = 0;
    for (BlockPageItemModel *blockPageItemModel in self.backgroundView.folderView.blockModel.blocks) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        BlockModel *blockModel = [blockDataSource findBlockModelByPK:blockPageItemModel.blockPK];
        if (blockModel != nil) {
            BlockView *blockView = [self getBlockViewByBlockModel:blockModel];
            if (blockView != nil && blockView != self.curDragingView  && blockView.pageNumber == -1) {
                CGRect rect = [self.backgroundView.folderView calculateBlockViewFrame:index];                             
                blockView.frame = rect;
                blockView.originalRect = blockView.frame;
            }
            index++;
        }
    }
}

- (void)modifyBlockViewInFolderFrames {
    if (!self.isOpeningFolderAnimation) {
        [UIView beginAnimations:@"modifyBlockViewInFolderFrames" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
        
        [self setFolderBlockViewsFrame];
        
        [UIView commitAnimations];
    }
}

- (void)handleFolderBlockViews:(BlockView*)v byPoint:(CGPoint)point inEnd:(BOOL)isEnd {
    int moveToIndex = 100;
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    if (!isEnd) {
        int col = point.x/self.blockViewWidth;
        int row = (point.y-(self.backgroundView.folderView.frame.origin.y+self.backgroundView.folderView.textLabel.frame.origin.y+self.backgroundView.folderView.textLabel.frame.size.height))/self.blockViewHeight;
        moveToIndex = row*self.backgroundView.folderView.cols+col;
    }
    
    int count = [blockDataSource getCountInFolder:self.openedView.blockModel.pk];
    if (moveToIndex > count) {
        moveToIndex = count;
    }
    
    [blockDataSource addCurDragingBlockPageItemModelInFolder:self.openedView.blockModel.pk toIndex:moveToIndex]; 
    
    v.pageNumber = -1;
    CGRect rect = [self.backgroundView.folderView calculateBlockViewFrame:moveToIndex];
    rect.origin.y += self.backgroundView.folderView.frame.origin.y;
    v.originalRect = rect;
    
    [self modifyBlockViewInFolderFrames];   
}

- (void)handleTurnPage:(int)pageNumber {
    CGRect rect = [self convertRect:self.curDragingView.frame toView:self];
    rect.origin.x -= self.weiyi;
    self.curDragingView.frame = rect;
    [self addSubview:self.curDragingView];
    
    self.canPageing = NO;
    self.isTurningPage = YES;
    [self turnToPage:pageNumber animation:YES];
    [self performSelector:@selector(setCanPageing) withObject:nil afterDelay:1.0];
}

- (void)handleBlockView:(BlockView*)v onRecognizerStateChanged:(UILongPressGestureRecognizer*)recognizer {
    self.endDragPoint = [recognizer locationInView:self.contentView];   
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    if (self.removeFromDock) {
        endDragPoint.x -= self.weiyi;
        CGRect originalRect = v.originalRect;
        originalRect.origin.x -= self.weiyi;            
        if (!CGRectContainsPoint(originalRect, self.endDragPoint)) {
            CGRect availableRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-MaginBottom);
            CGRect dockAvailableRect = CGRectMake(0, self.bounds.size.height-MaginBottom, self.bounds.size.width, MaginBottom);
            if (CGRectContainsPoint(availableRect, self.endDragPoint)) {
                if (blockDataSource.curDragingBlockPageItemModel != nil) {
                    [self handleCurPageBlockViews:v];
                    
                    self.removeFromDock = NO;
                    
                    [self modifyBlockViewDockFrames];
                } 
            } else if (CGRectContainsPoint(dockAvailableRect, self.endDragPoint) && [blockDataSource canAddInDock]) {
                CGPoint point = [recognizer locationInView:self];
                
                if (point.x > self.beginDragPoint.x) {
                    point.x += 30;
                } else {
                    point.x -= 30;
                }
                
                if (blockDataSource.curDragingBlockPageItemModel != nil && !CGRectContainsPoint(v.originalRect, point)) {
                    self.removeFromDock = NO;
                    
                    [self handleDockBlockViews:v byPoint:point];                        
                    [self modifyBlockViewFrames:YES];
                    
                    self.canMoveDocksBlockView = YES;
                }
            }
        }
    } else {
        endDragPoint.x -= self.weiyi;
        CGRect originalRect = v.originalRect;
        originalRect.origin.x -= self.weiyi;            
        if (!CGRectContainsPoint(originalRect, self.endDragPoint)) {
            CGRect availableRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-MaginBottom);
            CGRect dockAvailableRect = CGRectMake(0, self.bounds.size.height-MaginBottom, self.bounds.size.width, MaginBottom);
            if (CGRectContainsPoint(availableRect, self.endDragPoint)) {
                if (self.curDragingView.pageNumber == 0) {
                    self.curDragingView.pageNumber = self.curPageNumber;                        
                    [blockDataSource removeDockItemByBlockPk:self.curDragingView.blockModel.pk inDock:YES];            
                    self.removeFromDock = YES;
                    
                    return;
                }
                
                [blockDataSource removePageItemModelByBlockPK:v.blockModel.pk inPage:v.pageNumber withFlag:YES];
                
                if (blockDataSource.curDragingBlockPageItemModel != nil) {
                    [self handleCurPageBlockViews:v];
                }
            } else if (CGRectContainsPoint(dockAvailableRect, self.endDragPoint)) {
                if ([blockDataSource canAddInDock] && v.pageNumber > 0) {
                    [blockDataSource removePageItemModelByBlockPK:v.blockModel.pk inPage:v.pageNumber withFlag:YES];
                    
                    if (blockDataSource.curDragingBlockPageItemModel != nil) {
                        [self handleDockBlockViews:v byPoint:self.endDragPoint];                        
                        [self modifyBlockViewFrames:YES];
                        
                        self.canMoveDocksBlockView = YES;
                    }
                } else if (self.canMoveDocksBlockView && v.pageNumber == 0) {
                    [blockDataSource removeDockItemByBlockPk:v.blockModel.pk inDock:YES];
                    [self handleDockBlockViews:v byPoint:self.endDragPoint];
                }
            }                    
        }
    }
}

- (void)initParameters {
    self.canMoveFoldersBlockView = NO;
    self.removeFromFolder = NO;
    self.isMoveFromFolderToPage = NO;
    self.canMoveDocksBlockView = NO;
    self.removeFromDock = NO;
    self.isTurningPage = NO;
    
    self.curAddInView = nil;
    self.timeInterval = 0;
    self.beginAddInFolder = NO;
    
    self.canPageing = YES;
}

- (void)movieCurDragingViewFrame:(BlockView*)v onRecognizerStateChanged:(UILongPressGestureRecognizer*)recognizer {
    if (v.superview == self) {
        self.endDragPoint = [recognizer locationInView:self];
    } else {
        self.endDragPoint = [recognizer locationInView:self.contentView];
    }
    
    CGRect rect = v.frame;
    rect.origin.x = self.endDragPoint.x-self.beginDragPointInBlockView.x;
    rect.origin.y = self.endDragPoint.y-self.beginDragPointInBlockView.y;
    v.frame = rect;
}

- (void)BlockView:(BlockView*)v didLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (self.curDragingView) {
        if (self.curDragingView != v) {
            return ;
        }
	} else {
        if (self.openedView != nil && v.pageNumber != -1) {
            return ;
        }
    }
    
    if (self.openedView != nil && self.openedView == v) {
        return ;
    }
    
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self initParameters];
        
        [v shake:NO];
        [v scaleAndOpacityViewIsZoomOut:YES];   
        [self modifyCurState:YES withOutBlockView:v];
        
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        
        [self insertSubview:self.dockView belowSubview:self.scrollView];
        if (v.pageNumber == 0) {
            CGRect rect = [self.contentView convertRect:v.frame fromView:self.dockView];
            v.frame = rect;
            v.originalRect = rect;
            [self.contentView addSubview:v];
            v.pageNumber = self.curPageNumber;
            
            [blockDataSource removeDockItemByBlockPk:v.blockModel.pk inDock:YES];            
            self.removeFromDock = YES;
            
            [v addSimpleReflectionLayer:NO];
        } else if (v.pageNumber == -1) {
            [self insertSubview:self.backgroundView.folderView belowSubview:self.scrollView];
            
            [self modifyAllBlockViewsState:NO];
            
            CGRect rect = [self.contentView convertRect:v.frame fromView:self.backgroundView.folderView.contentView];
            v.frame = rect;
            v.originalRect = rect;
            [self.contentView addSubview:v];
            v.pageNumber = self.curPageNumber;
            
            [blockDataSource removeFolderItemByBlockPk:v.blockModel.pk infFolder:self.openedView.blockModel.pk flag:YES];
            self.removeFromFolder = YES;
        }
        
        self.curDragingView = v;
        self.beginDragPointInBlockView = [recognizer locationInView:v];
        self.beginDragPoint = [recognizer locationInView:self];
        [self.contentView bringSubviewToFront:v];
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        if (self.removeFromFolder) {
            [self movieCurDragingViewFrame:v onRecognizerStateChanged:recognizer];
            
            if (self.isOpeningFolderAnimation) {
                return;
            }
            
            self.endDragPoint = [recognizer locationInView:self.contentView];
            endDragPoint.x -= self.weiyi;
            CGRect originalRect = v.originalRect;
            originalRect.origin.x -= self.weiyi;            
            if (!CGRectContainsPoint(originalRect, self.endDragPoint)) {  
                CGRect availableRect = self.backgroundView.folderView.frame;
                if (!CGRectContainsPoint(availableRect, self.endDragPoint) && !self.beginAddInFolder) {
                    if (blockDataSource.curDragingBlockPageItemModel != nil) {
                        self.removeFromFolder = NO;
                        
                        int moveToIndex = [blockDataSource getCountInpage:self.curPageNumber];
                        
                        int moveToNextPageNumber = self.curPageNumber;
                        if (moveToIndex >= blockDataSource.rows*blockDataSource.cols) {
                            moveToIndex = 0;
                            moveToNextPageNumber += 1;
                        }
                        
                        [blockDataSource addCurDragingBlockPageItemModelToIndex:moveToIndex inPage:moveToNextPageNumber];                        
                        v.pageNumber = moveToNextPageNumber;
                        v.originalRect = [self calculateBlockViewFrame:moveToIndex inPage:moveToNextPageNumber];
                        
                        [self modifyBlockViewInFolderFrames];
                        self.isClosingFolderAnimation = YES;
                        [self performSelector:@selector(closeFolderAction) withObject:nil afterDelay:0.31];
                    } 
                } else if ([blockDataSource canAddInFolder:self.openedView.blockModel.pk]) {
                    CGPoint point = [recognizer locationInView:self];
                    
                    if (point.x > self.beginDragPoint.x) {
                        point.x += 30;
                    } else {
                        point.x -= 30;
                    }
                    
                    if (blockDataSource.curDragingBlockPageItemModel != nil && !CGRectContainsPoint(originalRect, point)) {
                        self.removeFromFolder = NO;
                        
                        [self handleFolderBlockViews:v byPoint:point inEnd:NO];
                        
                        self.canMoveFoldersBlockView = YES;
                    }
                }
            }
        } else {
            if (self.canMoveFoldersBlockView && [blockDataSource canAddInFolder:self.openedView.blockModel.pk]) {
                self.endDragPoint = [recognizer locationInView:self.contentView];
                endDragPoint.x -= self.weiyi;
                CGRect availableRect = self.backgroundView.folderView.frame;
                if (CGRectContainsPoint(availableRect, self.endDragPoint)) {
                    [self movieCurDragingViewFrame:v onRecognizerStateChanged:recognizer];
                    
                    self.endDragPoint = [recognizer locationInView:self.contentView];
                    endDragPoint.x -= self.weiyi;
                    
                    [blockDataSource removeFolderItemByBlockPk:v.blockModel.pk infFolder:self.openedView.blockModel.pk flag:YES];
                    
                    [self handleFolderBlockViews:v byPoint:self.endDragPoint inEnd:NO];
                } else if (self.curDragingView.pageNumber == -1) {
                    self.curDragingView.pageNumber = self.curPageNumber;                        
                    [blockDataSource removeFolderItemByBlockPk:v.blockModel.pk infFolder:self.openedView.blockModel.pk flag:YES];            
                    self.removeFromFolder = YES;
                    self.canMoveFoldersBlockView = NO;
                    //TODO:如果手指不再移动，跳到UIGestureRecognizerStateEnded这一步，可能会出错，所以加多isMoveFromFolderToPage来控制。
                    self.isMoveFromFolderToPage = YES;
                }
            } else {
                CGPoint panPointInView = [recognizer locationInView:self];
                if (self.canPageing && panPointInView.y <= self.frame.size.height-MaginBottom) {
                    if (panPointInView.x > self.frame.size.width-MaxBorderWidth) {                
                        [self handleTurnPage:self.curPageNumber+1];
                        return ;
                    } else if (panPointInView.x < MaxBorderWidth) {
                        [self handleTurnPage:self.curPageNumber-1];
                        return ;
                    }
                }
                
                [self movieCurDragingViewFrame:v onRecognizerStateChanged:recognizer];
                
                if (self.isAnimationing) {
                    return;
                }
                
                if (self.isClosingFolderAnimation) {
                    return;
                }
                
                self.isTurningPage = NO;
                [self handleBlockView:v onRecognizerStateChanged:recognizer];
            }
        }
	} else if (recognizer.state == UIGestureRecognizerStateEnded) {
        BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
        if (blockDataSource.curDragingBlockPageItemModel != nil && self.removeFromFolder) {
            if (self.isMoveFromFolderToPage) {
                int moveToIndex = [blockDataSource getCountInpage:self.curPageNumber];
                [blockDataSource addCurDragingBlockPageItemModelToIndex:moveToIndex inPage:self.curPageNumber];                        
                v.pageNumber = self.curPageNumber;
                v.originalRect = [self calculateBlockViewFrame:moveToIndex inPage:self.curPageNumber];
                
                [self modifyBlockViewInFolderFrames];
                self.isClosingFolderAnimation = YES;
                [self performSelector:@selector(closeFolderAction) withObject:nil afterDelay:0.31];
            } else {
                CGPoint point = [recognizer locationInView:self];
                CGRect rect = self.curDragingView.originalRect;
                rect = rect = [self convertRect:rect fromView:self.contentView];
                if (CGRectContainsPoint(rect, point)) {
                    [self handleFolderBlockViews:self.curDragingView byPoint:point inEnd:NO];
                } else {
                    [self handleFolderBlockViews:self.curDragingView byPoint:point inEnd:YES];
                }
            }            
        } else {
            if (blockDataSource.curDragingBlockPageItemModel != nil && self.removeFromDock && v.pageNumber > 0) {
                CGPoint point = [recognizer locationInView:self.dockView];            
                [self handleDockBlockViews:v byPoint:point];
            }
            
            if (self.isTurningPage) {           
                if (self.curDragingView.superview == self) {
                    CGRect rect = v.frame;
                    rect.origin.x += self.weiyi;
                    v.frame = rect;
                    [self.contentView addSubview:self.curDragingView];
                }

                [self handleBlockView:v onRecognizerStateChanged:recognizer];
            }
        }
        
        NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
        if (curTimeInterval-self.timeInterval < 1.0) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addInFolder) object:nil];
            if (self.curAddInView != nil) {
                if ([self.curAddInView.blockModel.showType isEqualToString:@"folder"]) {
                    [self.curAddInView setBorderWidth:YES];
                } else {
                    [self.curAddInView setBorderWidth:NO];
                }
                [self.curAddInView scaleBorder:NO];
            }
            
            if (self.openedView == nil) {
                CGPoint point = CGPointMake(v.originalRect.origin.x+10-self.weiyi, v.originalRect.origin.y+10);
                int moveToIndex = [self getMoveToIndex:point];
                [self movieBlockView:v toIndex:moveToIndex];
            }
        }
        
        if (self.isClosingFolderAnimation) {
            [self performSelector:@selector(modifyCurDragingViewFrameWithAnimation) withObject:nil afterDelay:0.31];
        } else {
            [self modifyCurDragingViewFrameWithAnimation];
        }        
        
        [v scaleAndOpacityViewIsZoomOut:NO];
        
        [blockDataSource saveCurBlockDatasInToPlistFile];
        
        [self initParameters];
	}
}

- (void)BlockView:(BlockView*)v didDoubleTap:(UITapGestureRecognizer*)recognizer {
    if (self.openedView != nil && v.pageNumber != -1) {
        return;
    }
    
    [v shake:NO];
    [self modifyCurState:NO withOutBlockView:v];
    
    [self removeEmptyPages];
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    [blockDataSource saveCurBlockDatasInToPlistFile];
    
    [self turnToPage:self.curPageNumber animation:NO];
}

- (void)removeBlockView:(BlockView*)removeView {
    [removeView retain];
    
    [removeView removeFromSuperview];
    [self.blockViewDict removeObjectForKey:removeView.blockModel.pk];
    BlockDataSource *blockDataSource = [BlockDataSource curBlockDataSource];
    [blockDataSource removeBlockModelByBlockPk:removeView.blockModel.pk];
    if (removeView.pageNumber == 0) {
        [blockDataSource removeDockItemByBlockPk:removeView.blockModel.pk inDock:NO];
        [self modifyBlockViewDockFrames];
    } else if (removeView.pageNumber == -1) {
        [blockDataSource removeFolderItemByBlockPk:removeView.blockModel.pk infFolder:self.openedView.blockModel.pk flag:NO];
        
        int count = [blockDataSource getCountInFolder:self.openedView.blockModel.pk];
        if (count == 1) {
            [self modifyBlockViewInFolderFrames];
            self.isClosingFolderAnimation = YES;
            [self performSelector:@selector(closeFolderAction) withObject:nil afterDelay:0.31];
        } else {
            [self modifyBlockViewInFolderFrames];
        }
    } else {
        [blockDataSource removeBlockPageItemByBlockPk:removeView.blockModel.pk];
        [self modifyBlockViewFrames:YES];
    }
    
    removeView.delegate = nil;
    [removeView release];
}

- (void)BlockView:(BlockView*)v didRemove:(id)btn {
    if (self.openedView != nil && v.pageNumber != -1) {
        return;
    }
    
    [self removeBlockView:v];
}

@end