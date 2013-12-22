//
//  BlockViewController.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockViewController.h"
#import "MyUnit.h"

@implementation BlockViewController

@synthesize delegate;
@synthesize blockScrollView;
@synthesize mainView;

- (void)dealloc {
    self.delegate = nil;
    
    if (blockScrollView) {
        blockScrollView.delegate = nil;
        [blockScrollView removeFromSuperview];
        [blockScrollView release];
        blockScrollView = nil;
    }
    
    if (mainView) {
        [mainView removeFromSuperview];
        [mainView release];
        mainView = nil;
    }
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle
- (void)addBlockScrollView {
    if (self.blockScrollView == nil) {
        BlockScrollView *tView = [[BlockScrollView alloc] initWithFrame:CGRectZero];
        self.blockScrollView = tView;
        [tView release];
        
        [self.mainView addSubview:self.blockScrollView];
        [self.blockScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }

    self.blockScrollView.frame = self.mainView.bounds;
    self.blockScrollView.delegate = self;
    [self.blockScrollView layoutBlockScrollView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return YES;
}

- (void)turnToPage:(int)pageNumber animation:(BOOL)animation {
    [self.blockScrollView turnToPage:pageNumber animation:animation];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer { 
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		[self turnToPage:self.blockScrollView.curPageNumber+1 animation:YES];
	} else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		[self turnToPage:self.blockScrollView.curPageNumber-1 animation:YES];
	}
}

- (void)addSwipeGestureRecognizers {
    UISwipeGestureRecognizer *swipeRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[self.mainView addGestureRecognizer:swipeRecognizer1];
	swipeRecognizer1.numberOfTouchesRequired = 1;
	swipeRecognizer1.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeRecognizer1.delegate = self;
	[swipeRecognizer1 release];
	
	UISwipeGestureRecognizer *swipeRecognizer2 =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[self.mainView addGestureRecognizer:swipeRecognizer2];
	swipeRecognizer2.numberOfTouchesRequired = 1;
	swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRecognizer2.delegate = self;
	[swipeRecognizer2 release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    [self addSwipeGestureRecognizers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)logginSuccess:(BlockModel*)blockModel {
    [self.blockScrollView logginSuccess:blockModel];
}

//==========BlockScrollViewDelegate==========
- (void)BlockScrollView:(BlockScrollView*)scrollView didOpen:(BlockView*)v {
    if ([@"add" isEqualToString:v.blockModel.type]) {
        if ([self.delegate respondsToSelector:@selector(BlockViewController:addNewBlockBtn:)]) {
            [self.delegate BlockViewController:self addNewBlockBtn:nil];
        }
    } else if ([@"setting" isEqualToString:v.blockModel.type]) {
        if ([self.delegate respondsToSelector:@selector(BlockViewController:setting:)]) {
            [self.delegate BlockViewController:self setting:nil];
        }
    } else if ([@"download" isEqualToString:v.blockModel.type]) {
        if ([self.delegate respondsToSelector:@selector(BlockViewController:download:)]) {
            [self.delegate BlockViewController:self download:v.blockModel];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(BlockViewController:didOpen:)]) {
            [self.delegate BlockViewController:self didOpen:v.blockModel];
        }
    }
}

@end
