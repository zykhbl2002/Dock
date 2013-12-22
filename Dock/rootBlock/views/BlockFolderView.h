//
//  BlockFolderView.h
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockFolderModel.h"

@protocol BlockFolderViewDelegate;

@interface BlockFolderView : UIView<UITextFieldDelegate> {
    id<BlockFolderViewDelegate> delegate;
    
    BlockFolderModel *blockModel;
    
    UIScrollView *scrollView;
    UIView *contentView;
    
    int cols;
    CGFloat blockViewWidth;
    CGFloat blockViewHeight;
    
    BOOL curEditState;
    
    UILabel *textLabel;
    UITextField *textField;
}

@property (nonatomic,assign) id<BlockFolderViewDelegate> delegate;
@property (nonatomic, retain) BlockFolderModel *blockModel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic) int cols;
@property (nonatomic) CGFloat blockViewWidth;
@property (nonatomic) CGFloat blockViewHeight;
@property (nonatomic) BOOL curEditState;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UITextField *textField;

- (void)layoutBlockFolderView;
- (CGFloat)calculateFolderHeightWithFlag:(BOOL)isAdd;
- (CGRect)calculateBlockViewFrame:(int)index;
- (void)changeContentSize;

@end

@protocol BlockFolderViewDelegate<NSObject>

- (void)BlockFolderView:(BlockFolderView*)v textFieldDidBeginEditing:(void*)a;
- (void)BlockFolderView:(BlockFolderView*)v textFieldDidEndEditing:(void*)a;

@end
