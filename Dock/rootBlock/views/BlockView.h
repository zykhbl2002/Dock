//
//  BlockView.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "BlockModel.h"

@protocol BlockViewDelegate;

@interface BlockView : UIView<UIGestureRecognizerDelegate> {
    id<BlockViewDelegate> delegate;
    
    BlockModel *blockModel;
    UIImageView *borderImageView;
    UIImageView *bgImageView;
    UILabel *blockTitleLabel;
    UIButton *removeBtn;
    UIButton *mainBtn;
    
    BOOL curEditState;
    CGRect originalRect;
    int pageNumber;
    
    CALayer *reflectionLayer;
}

@property (nonatomic,assign) id<BlockViewDelegate> delegate;
@property (nonatomic, retain) BlockModel *blockModel;
@property (nonatomic, retain) UIImageView *borderImageView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UILabel *blockTitleLabel;
@property (nonatomic, retain) UIButton *removeBtn;
@property (nonatomic, retain) UIButton *mainBtn;
@property (nonatomic) BOOL curEditState;
@property (nonatomic) CGRect originalRect;
@property (nonatomic) int pageNumber;
@property (nonatomic, retain) CALayer *reflectionLayer;

- (void)layoutBlockView;
- (void)scaleAndOpacityViewIsZoomOut:(BOOL)zoomOut;
- (void)changeRemoveBtnStateByAnimation:(BOOL)isAnimation;
- (void)shake:(BOOL)isAnimation;
- (void)addSimpleReflectionLayer:(BOOL)flag;

- (void)scaleBorder:(BOOL)zoomOut;
- (void)setBorderWidth:(BOOL)flag;

- (void)logginSuccess;

- (void)showOrHideBlockTitleLabel:(BOOL)flag;

@end

@protocol BlockViewDelegate<NSObject>

- (void)BlockView:(BlockView*)v didPan:(UIPanGestureRecognizer*)recognizer;
- (void)BlockView:(BlockView*)v didDoubleTap:(UITapGestureRecognizer*)recognizer;
- (void)BlockView:(BlockView*)v didLongPress:(UILongPressGestureRecognizer*)recognizer;

- (void)BlockView:(BlockView*)v didRemove:(id)btn;

@end