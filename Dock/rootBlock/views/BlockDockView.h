//
//  BlockDockView.h
//  WBHui
//
//  Created by kenny on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface BlockDockView : UIView {
    UIImageView *bgImageView;
}

@property (nonatomic, retain) UIImageView *bgImageView;

- (void)layoutDockView;

@end
