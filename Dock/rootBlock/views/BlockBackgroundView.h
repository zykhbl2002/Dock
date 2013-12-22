//
//  BlockBackgroundView.h
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundImageView.h"
#import "BlockFolderView.h"
#import "FolderTriangleView.h"

@interface BlockBackgroundView : UIView<FolderTriangleViewDelegate> {
    CGFloat topImageViewHeight;
    BackgroundImageView *topImageView;
    BackgroundImageView *bottomImageView;
    
    BlockFolderView *folderView;
    
    FolderTriangleView *topTriangleView;
    FolderTriangleView *bottomTriangleView;
    CGFloat folderTriangleViewOriginx;
    
    BOOL isTop;
}

@property (nonatomic) CGFloat topImageViewHeight;
@property (nonatomic, retain) BackgroundImageView *topImageView;
@property (nonatomic, retain) BackgroundImageView *bottomImageView;
@property (nonatomic, retain) BlockFolderView *folderView;
@property (nonatomic, retain) FolderTriangleView *topTriangleView;
@property (nonatomic, retain) FolderTriangleView *bottomTriangleView;
@property (nonatomic) CGFloat folderTriangleViewOriginx;
@property (nonatomic) BOOL isTop;

- (void)layoutBlockBackgroundView;
- (void)setTopImageViewFrame;
- (void)setBottomImageViewFrame;
- (void)setFolderViewFrame:(CGFloat)height;
- (void)setFolderTriangleViewFrame;

@end
