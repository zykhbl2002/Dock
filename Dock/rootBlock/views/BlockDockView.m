//
//  BlockDockView.m
//  WBHui
//
//  Created by kenny on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockDockView.h"

@implementation BlockDockView

@synthesize bgImageView;

- (void)dealloc {
    if (bgImageView) {
        [bgImageView removeFromSuperview];
        [bgImageView release];
        bgImageView = nil;
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addBgImageView {
    if (self.bgImageView == nil) {
        UIImage *bgImage = [UIImage imageNamed:@"dock_bg.png"];
        CGRect rect = self.bounds;
        rect.origin.x = (rect.size.width-bgImage.size.width)*0.5;
        rect.origin.y = rect.size.height-bgImage.size.height;
        rect.size = bgImage.size;
        
        UIImageView *tView = [[UIImageView alloc] initWithFrame:rect];
        self.bgImageView = tView;
        [tView release];
        
        self.bgImageView.image = bgImage;
        [self addSubview:self.bgImageView];
    }
}

- (void)layoutDockView {
    [self addBgImageView];
}

@end
