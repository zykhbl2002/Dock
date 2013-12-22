//
//  BackgroundImageView.h
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundImageView : UIView {
    BOOL isTop;
    UIImageView *imageView;
    
    UIImage *defaultImg;
}

@property (nonatomic) BOOL isTop;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *defaultImg;

- (void)layoutBackgroundImageView;

@end
