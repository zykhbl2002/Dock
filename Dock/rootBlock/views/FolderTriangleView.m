//
//  FolderTriangleView.m
//  WBHui
//
//  Created by zykhbl on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FolderTriangleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FolderTriangleView

@synthesize delegate;
@synthesize maskImg1;
@synthesize maskImg2;
@synthesize isTop;
@synthesize isMask;

- (void)dealloc {
    self.delegate = nil;
    
    self.maskImg1 = nil;
    self.maskImg2 = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage*)clipImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGRect rect = self.frame;
    rect.origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    rect.size = self.superview.bounds.size;
    [[self.delegate FolderTriangleView:self getBgImage:nil] drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawFolderTriangleView {
    if (self.isTop) {
        if (self.maskImg1 == nil) {
            self.maskImg1 = [UIImage imageNamed:@"folder-mask.png"];
        }
    } else {
        if (self.maskImg2 == nil) {
            self.maskImg2 = [UIImage imageNamed:@"folder-mask-2.png"];
        }
    }
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)(self.isTop ? self.maskImg1.CGImage : self.maskImg2.CGImage);
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    if (self.isMask) {
        self.image = [self clipImage];
    } else {
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    }
}

@end
