//
//  BlockViewController.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockScrollView.h"

@protocol BlockViewControllerDelegate;

@interface BlockViewController : UIViewController<UIGestureRecognizerDelegate, BlockScrollViewDelegate> {
    id<BlockViewControllerDelegate> delegate;
    BlockScrollView *blockScrollView;
    
    IBOutlet UIView *mainView;
}

@property (nonatomic, assign) id<BlockViewControllerDelegate> delegate;
@property (nonatomic, retain) BlockScrollView *blockScrollView;
@property (nonatomic, retain) IBOutlet UIView *mainView;

- (void)addBlockScrollView;
- (void)turnToPage:(int)pageNumber animation:(BOOL)animation;

- (void)logginSuccess:(BlockModel*)blockModel;

@end

@protocol BlockViewControllerDelegate<NSObject>

- (void)BlockViewController:(BlockViewController*)controller didOpen:(BlockModel*)model;
- (void)BlockViewController:(BlockViewController*)controller addNewBlockBtn:(void*)a;
- (void)BlockViewController:(BlockViewController*)controller setting:(void*)a;
- (void)BlockViewController:(BlockViewController*)controller download:(BlockModel*)model;

@end