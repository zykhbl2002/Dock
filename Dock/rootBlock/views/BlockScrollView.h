//
//  BlockScrollView.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockDataSource.h"
#import "BlockView.h"
#import "BlockDockView.h"
#import "BlockBackgroundView.h"

@protocol BlockScrollViewDelegate;

@interface BlockScrollView : UIView<BlockViewDelegate, UIGestureRecognizerDelegate, BlockFolderViewDelegate> {
    id<BlockScrollViewDelegate> delegate;
    
    UIScrollView *scrollView;
    UIView *contentView;
    
	NSMutableDictionary *blockViewDict;
    
    int curPageNumber;
    
    CGFloat blockViewWidth;
    CGFloat blockViewHeight;
    
    BOOL curEditState;
    
    BlockView *curDragingView;
    CGPoint beginDragPointInBlockView;
    CGPoint beginDragPoint;
    CGPoint endDragPoint;
    
    BOOL canPageing;
    
    BlockDockView *bgDockView;
    BlockDockView *dockView;
    
    BOOL removeFromDock;
    BOOL canMoveDocksBlockView;
    
    BOOL isTurningPage;
    BOOL isAnimationing;
    
    BlockBackgroundView *backgroundView;
    BlockView *openedView;
    BOOL removeFromFolder;
    BOOL canMoveFoldersBlockView;
    
    BOOL isMoveFromFolderToPage;
    BOOL isOpeningFolderAnimation;
    BOOL isClosingFolderAnimation;
    
    BlockView *curAddInView;
    NSTimeInterval timeInterval;
    BOOL beginAddInFolder;
    int folderIndex;
    
    CGFloat weiyi;
    CGFloat folderHeight;
    
    BOOL keyBoardIsShowed;
}

@property (nonatomic,assign) id<BlockScrollViewDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) NSMutableDictionary *blockViewDict;
@property (nonatomic) int curPageNumber;
@property (nonatomic) CGFloat blockViewWidth;
@property (nonatomic) CGFloat blockViewHeight;
@property (nonatomic) BOOL curEditState;
@property (nonatomic, retain) BlockView *curDragingView;
@property (nonatomic) CGPoint beginDragPointInBlockView;
@property (nonatomic) CGPoint beginDragPoint;
@property (nonatomic) CGPoint endDragPoint;
@property (nonatomic) BOOL canPageing;
@property (nonatomic, retain) BlockDockView *bgDockView;
@property (nonatomic, retain) BlockDockView *dockView;
@property (nonatomic) BOOL removeFromDock;
@property (nonatomic) BOOL canMoveDocksBlockView;
@property (nonatomic) BOOL isTurningPage;
@property (nonatomic) BOOL isAnimationing;
@property (nonatomic, retain) BlockBackgroundView *backgroundView;
@property (nonatomic, retain) BlockView *openedView;
@property (nonatomic) BOOL removeFromFolder;
@property (nonatomic) BOOL canMoveFoldersBlockView;
@property (nonatomic) BOOL isMoveFromFolderToPage;
@property (nonatomic) BOOL isOpeningFolderAnimation;
@property (nonatomic) BOOL isClosingFolderAnimation;
@property (nonatomic, retain) BlockView *curAddInView;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) BOOL beginAddInFolder;
@property (nonatomic) int folderIndex;
@property (nonatomic) CGFloat weiyi;
@property (nonatomic) CGFloat folderHeight;
@property (nonatomic) BOOL keyBoardIsShowed;

- (void)layoutBlockScrollView;
- (void)turnToPage:(int)pageNumber animation:(BOOL)isAnimation;
- (void)logginSuccess:(BlockModel*)blockModel;
- (void)handleSingleTap:(UISwipeGestureRecognizer*)recognizer;

@end

@protocol BlockScrollViewDelegate<NSObject>

- (void)BlockScrollView:(BlockScrollView*)scrollView didOpen:(BlockView*)v;

@end