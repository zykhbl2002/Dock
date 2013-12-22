//
//  BackgroundImageView.m
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundImageView.h"

@implementation BackgroundImageView

@synthesize isTop;
@synthesize imageView;
@synthesize defaultImg;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (imageView) {
        [imageView removeFromSuperview];
        [imageView release];
        imageView = nil;
    }
    
    if (defaultImg) {
        [defaultImg release];
        defaultImg = nil;
    }
    
    [super dealloc];
}

- (void)addImageView {
    if (self.imageView == nil) {
        UIImageView *tImageView = [[UIImageView alloc] init];
        self.imageView = tImageView;
        [tImageView release];
        
        [self addSubview:self.imageView];
    }
}

- (void)changeImage {
    self.imageView.image = self.defaultImg;
    
    CGRect rect = self.superview.bounds;
    if (!self.isTop) {
        rect.origin.y = self.bounds.size.height-rect.size.height;
    }
    self.imageView.frame = rect;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.defaultImg = [UIImage imageNamed:@"beijing.jpg"];
    }
    return self;
}

- (void)layoutBackgroundImageView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self addImageView];
    [self changeImage];
}

@end
