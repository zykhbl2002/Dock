//
//  BlockView.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "MyUnit.h"

#define MaginTop 11
#define MaginBottom 20
#define MaginLeft 8
#define MaginRight 8

#define TitleLabelHeight 20

#define kReflectOpacity 0.35
#define kReflectDistance -2.0

@implementation BlockView

@synthesize delegate;
@synthesize blockModel;
@synthesize borderImageView;
@synthesize bgImageView;
@synthesize blockTitleLabel;
@synthesize removeBtn;
@synthesize mainBtn;
@synthesize curEditState;
@synthesize originalRect;
@synthesize pageNumber;
@synthesize reflectionLayer;

- (void)cleanrReflectionLayer {
    if (reflectionLayer) {
        [reflectionLayer removeFromSuperlayer];
        [reflectionLayer release];
        reflectionLayer = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;
    
    if (mainBtn) {
        [mainBtn removeFromSuperview];
        [mainBtn release];
        mainBtn = nil;
    }
    
    if (removeBtn) {
        [removeBtn removeFromSuperview];
        [removeBtn release];
        removeBtn = nil;
    }
    
    if (blockTitleLabel) {
        [blockTitleLabel removeFromSuperview];
        [blockTitleLabel release];
        blockTitleLabel = nil;
    }
    
    if (bgImageView) {
        [bgImageView removeFromSuperview];
        [bgImageView release];
        bgImageView = nil;
    }
    
    if (borderImageView) {
        [borderImageView removeFromSuperview];
        [borderImageView release];
        borderImageView = nil;
    }
    
    self.blockModel = nil;

    [self cleanrReflectionLayer];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.curEditState = NO;
    }
    return self;
}

- (void)scaleBorder:(BOOL)zoomOut { 
    CGFloat duration = 0.2;
    CGFloat scaleFromValue = zoomOut ? 1.0 : 1.3;
    CGFloat scaleToValue = zoomOut ? 1.3 : 1.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:scaleFromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:scaleToValue];
    
    [self.layer addAnimation:scaleAnimation forKey:@"scaleBorderAnimation"];
}

- (void)setBorderWidth:(BOOL)flag {
    if (flag) {
        self.borderImageView.layer.borderWidth = 2.0;
    } else {
        self.borderImageView.layer.borderWidth = 0.0;
    }
}

- (void)addBgImageView {
    CGRect rect = self.bounds;
    rect.origin.x = MaginLeft;
    rect.origin.y = MaginTop;
    rect.size.width = rect.size.width-(MaginLeft+MaginRight);
    rect.size.height = rect.size.height-(MaginTop+MaginBottom);
    rect = [MyUnit CGRectFixInt:rect];
    
    rect = CGRectMake(rect.origin.x-1.0, rect.origin.y-1.0, rect.size.width+2.0, rect.size.height+2.0);
    if (self.borderImageView == nil) {
        UIImageView *tImageView = [[UIImageView alloc] initWithFrame:rect];
        self.borderImageView = tImageView;
        [tImageView release];
        
        self.borderImageView.backgroundColor = [UIColor clearColor];
        self.borderImageView.layer.cornerRadius = 7.0;
        self.borderImageView.layer.masksToBounds = YES;
        self.borderImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self addSubview:self.borderImageView];
    }
    self.borderImageView.frame = rect;
    [self setBorderWidth:[self.blockModel.showType isEqualToString:@"folder"]];
    
    rect = CGRectMake(1.0, 1.0, rect.size.width-2.0, rect.size.height-2.0);
    if (self.bgImageView == nil) {
        UIImageView *tImageView = [[UIImageView alloc] initWithFrame:rect];
        self.bgImageView = tImageView;
        [tImageView release];
        
        self.bgImageView.image = [UIImage imageNamed:@"rootBlock_bg.png"];
        self.bgImageView.layer.cornerRadius = 5.0;   
        self.bgImageView.layer.masksToBounds = YES;
        [self.borderImageView addSubview:self.bgImageView];
    }
    self.bgImageView.frame = rect;
}

- (void)addBlockTitleLabel {
    if (self.blockTitleLabel == nil) {
        UILabel *tLabel = [[UILabel alloc] init];
        self.blockTitleLabel = tLabel;
        [tLabel release];
        
        self.blockTitleLabel.backgroundColor = [UIColor clearColor];
        self.blockTitleLabel.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12.0];
        self.blockTitleLabel.textColor = [UIColor whiteColor];
        self.blockTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.blockTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        [self addSubview:self.blockTitleLabel];
    }
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height-MaginBottom;
    rect.size.height = TitleLabelHeight;
    
    self.blockTitleLabel.frame = rect;
    if ([MyUnit NSStringIsEmpty:self.blockModel.screen_name]) {
        self.blockTitleLabel.text = self.blockModel.blockTitle;
    } else {
        [self logginSuccess];
    }
}

- (void)removeBtnAction:(id)btn {
	if ([self.delegate respondsToSelector:@selector(BlockView:didRemove:)]) {
		[self.delegate BlockView:self didRemove:btn];
	}
}

- (void)UIViewAnimationsDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    
}

- (void)shake:(BOOL)isAnimation {
    if (isAnimation) {
        CGFloat duration = 0.4;
        CGFloat shakeFromValue = M_PI*0.012;
        CGFloat shakeToValue = -M_PI*0.012;
        
        CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.4], nil];
        rotationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:shakeFromValue], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:shakeToValue], [NSNumber numberWithFloat:0.0], nil];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
        CGRect bounds = self.layer.bounds;
        CGFloat distance_x = bounds.size.width*0.014;
        CGFloat distance_y = bounds.size.height*0.006;
        CGMutablePathRef shakePath = CGPathCreateMutable();
        CGPathMoveToPoint(shakePath, NULL, distance_x, 0.0);
        CGPathAddCurveToPoint(shakePath, NULL, distance_x, distance_y, -distance_x, distance_y, -distance_x, 0.0);
        CGPathCloseSubpath(shakePath);
        positionAnimation.path = shakePath;
        CFRelease(shakePath);
        
        CAAnimationGroup *shakeAnimation = [CAAnimationGroup animation];
        shakeAnimation.duration = duration;
        shakeAnimation.repeatCount = HUGE_VALF;
        shakeAnimation.delegate = nil;
        shakeAnimation.removedOnCompletion = YES;
        shakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        shakeAnimation.fillMode = kCAFillModeForwards;
        shakeAnimation.animations = [NSArray arrayWithObjects:rotationAnimation, positionAnimation, nil];
        
        [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
    } else {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
    }
}

- (void)changeRemoveBtnStateByAnimation:(BOOL)isAnimation {
    if ([self.blockModel.showType isEqualToString:@"folder"] || [self.blockModel.permissions isEqualToString:@"system"]) {
        return;
    }
    
    if (isAnimation) {
		[UIView beginAnimations:@"changeRemoveBtnState" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];
	}
	
    self.removeBtn.hidden = !self.curEditState;
    self.removeBtn.enabled = self.curEditState;
	
	if (isAnimation) {
		[UIView commitAnimations];
	}
}                                                

- (void)addRemoveButton {
    if (self.removeBtn == nil && ![self.blockModel.showType isEqualToString:@"folder"] && ![self.blockModel.permissions isEqualToString:@"system"]) {
        CGRect rect = self.borderImageView.frame;
        rect.origin.x -= 11.0;
        rect.origin.y -= 11.0;
        rect.size = CGSizeMake(25, 25);
        UIButton *tBtn = [[UIButton alloc] initWithFrame:rect];
        self.removeBtn = tBtn;
        [tBtn release];
        
        self.removeBtn.hidden = !self.curEditState;
        self.removeBtn.enabled = self.curEditState;
        
        [self shake:self.curEditState];
        
        [self.removeBtn setImage:[UIImage imageNamed:@"rootBlock_btn_remove.png"] forState:UIControlStateNormal];
        [self.removeBtn addTarget:self action:@selector(removeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.removeBtn];
    }
}

- (void)animationDidStop:(CAAnimation*)theAnimation finished:(BOOL)flag {
    [self shake:self.curEditState];
}

- (void)scaleAndOpacityViewIsZoomOut:(BOOL)zoomOut { 
    CGFloat duration = zoomOut ? 0.3 : 0.3;
    CGFloat alphaValue = zoomOut ? 0.8 : 1.0;
    
    CGFloat scaleFromValue = zoomOut ? 1.0 : 1.1;
    CGFloat scaleToValue = zoomOut ? 1.1 : 1.0;
    
    [UIView beginAnimations:@"setAlpha" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(UIViewAnimationsDidStop:finished:context:)];	
    self.alpha = alphaValue;	
	[UIView commitAnimations];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:scaleFromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:scaleToValue];
    if (zoomOut) {
        scaleAnimation.delegate = nil;
    } else {
        scaleAnimation.delegate = self;
    }
    
    [self.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
	if ([self.delegate respondsToSelector:@selector(BlockView:didLongPress:)]) {
		[self.delegate BlockView:self didLongPress:recognizer];
	}
}

- (void)blockHandleDoubleTap:(UITapGestureRecognizer*)recognizer {        
	if ([self.delegate respondsToSelector:@selector(BlockView:didDoubleTap:)]) {
		[self.delegate BlockView:self didDoubleTap:recognizer];
	}
}

- (void)addGestureRecognizers {
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.3;
	longPressRecognizer.delegate = self;
	[self addGestureRecognizer:longPressRecognizer];
	[longPressRecognizer release];
	
	UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockHandleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.delegate = self;
	[self addGestureRecognizer:doubleTapRecognizer];
	[doubleTapRecognizer release];
}

- (void)btnAction:(id)btn {
	if ([self.blockModel.showType isEqualToString:@"folder"] || !self.curEditState) {
		if ([self.delegate respondsToSelector:@selector(BlockView:didPan:)]) {
            [self.delegate BlockView:self didPan:nil];
        }
	}
}

- (void)addMainBtn {
    if (self.mainBtn == nil) {
        UIButton *tBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.mainBtn = tBtn;
        [tBtn release];
        
        [self addSubview:self.mainBtn];
        
        [self.mainBtn setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        [self.mainBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutBlockView {
    [self addBgImageView];
    [self addBlockTitleLabel];
    [self addMainBtn];
    [self addRemoveButton];
    [self addGestureRecognizers];
}

- (UIImage*)getCurViewImage {
    UIGraphicsBeginImageContext(self.borderImageView.bounds.size);
    [self.borderImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)addSimpleReflectionLayer:(BOOL)flag {
    if (self.reflectionLayer == nil) {
        self.reflectionLayer = [CALayer layer];
        self.reflectionLayer.opacity = kReflectOpacity;
        CGRect rect = self.borderImageView.frame;
        rect.origin.y = rect.origin.y+rect.size.height+kReflectDistance;
        self.reflectionLayer.frame = rect;
        CATransform3D transform = CATransform3DMakeScale(1.0, -1.0, 100.0);
        self.reflectionLayer.transform = transform;
        self.reflectionLayer.sublayerTransform = self.reflectionLayer.transform;
        [self.layer addSublayer:self.reflectionLayer];
    }
        
    if (flag) {
        self.reflectionLayer.contents = (id)[[self getCurViewImage] CGImage];
    } else {
        self.reflectionLayer.contents = nil;
        [self cleanrReflectionLayer];
    }
}

- (void)logginSuccess {
    self.blockTitleLabel.text = self.blockModel.screen_name;
}

- (void)showOrHideBlockTitleLabel:(BOOL)flag {
    [UIView beginAnimations:@"showOrHideBlockTitleLabel" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    self.blockTitleLabel.alpha = flag ? 1.0 : 0.0;
    [UIView commitAnimations];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if ([self.blockModel.showType isEqualToString:@"folder"]) {
        self.blockTitleLabel.text = self.blockModel.blockTitle;
    }
}

- (void)setBlockModel:(BlockModel*)model {
    if (blockModel && [blockModel.showType isEqualToString:@"folder"]) {
        [blockModel removeObserver:self forKeyPath:@"blockTitle"];
    }
    
    [model retain];
    [blockModel release];
    blockModel = model;
    
    if (blockModel != nil && [blockModel.showType isEqualToString:@"folder"]) {
        [blockModel addObserver:self forKeyPath:@"blockTitle" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    }
}

@end
