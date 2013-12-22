//
//  BlockBackgroundView.m
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockBackgroundView.h"

#define FolderTriangleViewHeight 20

@implementation BlockBackgroundView

@synthesize topImageViewHeight;
@synthesize topImageView;
@synthesize bottomImageView;
@synthesize folderView;
@synthesize topTriangleView;
@synthesize bottomTriangleView;
@synthesize folderTriangleViewOriginx;
@synthesize isTop;

- (void)dealloc {
    if (folderView) {
        [folderView removeFromSuperview];
        [folderView release];
        folderView = nil;
    }
    
    if (topImageView) {
        [topImageView removeFromSuperview];
        [topImageView release];
        topImageView = nil;
    }
    
    if (bottomImageView) {
        [bottomImageView removeFromSuperview];
        [bottomImageView release];
        bottomImageView = nil;
    }
    
    if (topTriangleView) {
        [topTriangleView removeFromSuperview];
        [topTriangleView release];
        topTriangleView = nil;
    }
    
    if (bottomTriangleView) {
        [bottomTriangleView removeFromSuperview];
        [bottomTriangleView release];
        bottomTriangleView = nil;
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setTopImageViewFrame {
    CGRect rect = self.bounds;
    rect.size.height = topImageViewHeight;
    self.topImageView.frame = rect;
    
    [self.topImageView layoutBackgroundImageView];
}

- (void)addTopImageView {
    if (self.topImageView == nil) {
        BackgroundImageView *tBackgroundImageView = [[BackgroundImageView alloc] initWithFrame:CGRectZero];
        self.topImageView = tBackgroundImageView;
        [tBackgroundImageView release];
        
        [self addSubview:self.topImageView];
    }
    
    self.topImageView.isTop = YES;
    [self setTopImageViewFrame];
}

- (void)setBottomImageViewFrame {
    CGRect rect = self.bounds;    
    rect.origin.y = topImageViewHeight;
    rect.size.height -= topImageViewHeight;
    self.bottomImageView.frame = rect;
    
    [self.bottomImageView layoutBackgroundImageView];
}

- (void)addBottomImageView {
    if (self.bottomImageView == nil) {
        BackgroundImageView *tBackgroundImageView = [[BackgroundImageView alloc] initWithFrame:CGRectZero];
        self.bottomImageView = tBackgroundImageView;
        [tBackgroundImageView release];
        
        [self addSubview:self.bottomImageView];
    }
    
    self.bottomImageView.isTop = NO;
    [self setBottomImageViewFrame];
}

- (void)setFolderViewFrame:(CGFloat)height {
    CGRect rect = self.bounds;
    rect.origin.y = topImageViewHeight;
    if (height == 0) {
        rect.size.height -= topImageViewHeight;
    } else {
        rect.size.height = height;
    }
    
    self.folderView.frame = rect;
    
    [self.folderView changeContentSize];
    [self.folderView layoutBlockFolderView];
}

- (void)addFolderView {
    if (self.folderView == nil) {
        BlockFolderView *tFolderView = [[BlockFolderView alloc] init];
        self.folderView = tFolderView;
        [tFolderView release];
        
        [self addSubview:self.folderView];
    }
    
    [self setFolderViewFrame:0];
}

- (void)setFolderTriangleViewFrame {
    CGRect rect = self.bounds;
    rect.origin.x = self.folderTriangleViewOriginx;
    if (self.isTop) {
        rect.origin.y = topImageViewHeight-FolderTriangleViewHeight;
    } else {
        rect.origin.y = topImageViewHeight;
    }
    rect.size.width = 72;
    rect.size.height = FolderTriangleViewHeight;
    
    self.topTriangleView.delegate = self;
    self.topTriangleView.frame = rect;
    self.topTriangleView.isTop = self.isTop;
    self.topTriangleView.isMask = NO;
    [self.topTriangleView drawFolderTriangleView];
    
    self.bottomTriangleView.delegate = self;
    self.bottomTriangleView.frame = rect;
    self.bottomTriangleView.isTop = self.isTop;
    self.bottomTriangleView.isMask = YES;
    [self.bottomTriangleView drawFolderTriangleView];
}

- (void)addFolderTriangleView {
    if (self.topTriangleView == nil) {
        FolderTriangleView *tView = [[FolderTriangleView alloc] initWithFrame:CGRectZero];
        self.topTriangleView = tView;
        [tView release];
        [self addSubview:self.topTriangleView];
    }
    
    if (self.bottomTriangleView == nil) {
        FolderTriangleView *tView = [[FolderTriangleView alloc] initWithFrame:CGRectZero];
        self.bottomTriangleView = tView;
        [tView release];
        [self addSubview:self.bottomTriangleView];
    }
}

- (void)layoutBlockBackgroundView {
    [self addFolderView];
    [self addTopImageView];
    [self addBottomImageView];
    [self addFolderTriangleView];
}

//======== FolderTriangleViewDelegat e========
- (UIImage*)FolderTriangleView:(FolderTriangleView*)v getBgImage:(void*)a {
    return self.topImageView.imageView.image;
}

@end
