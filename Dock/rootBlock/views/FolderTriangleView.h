//
//  FolderTriangleView.h
//  WBHui
//
//  Created by zykhbl on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FolderTriangleViewDelegate;

@interface FolderTriangleView : UIImageView {
    id<FolderTriangleViewDelegate> delegate;
    
    UIImage *maskImg1;
    UIImage *maskImg2;
    
    BOOL isTop;
    BOOL isMask;
}

@property (nonatomic,assign) id<FolderTriangleViewDelegate> delegate;
@property (nonatomic, retain) UIImage *maskImg1;
@property (nonatomic, retain) UIImage *maskImg2;
@property (nonatomic) BOOL isTop;
@property (nonatomic) BOOL isMask;

- (void)drawFolderTriangleView;

@end


@protocol FolderTriangleViewDelegate<NSObject>

- (UIImage*)FolderTriangleView:(FolderTriangleView*)v getBgImage:(void*)a;

@end