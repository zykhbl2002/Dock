//
//  BlockFolderView.m
//  WBHui
//
//  Created by kenny on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockFolderView.h"
#import "BlockDataSource.h"
#import "MyUnit.h"

#define MaginLeft 15.0

@implementation BlockFolderView

@synthesize delegate;
@synthesize blockModel;
@synthesize scrollView;
@synthesize contentView;
@synthesize cols;
@synthesize blockViewWidth;
@synthesize blockViewHeight;
@synthesize curEditState;
@synthesize textLabel;
@synthesize textField;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;
    
    if (contentView) {
        [contentView removeFromSuperview];
        [contentView release];
        contentView = nil;
    }
    
    if (scrollView) {
        [scrollView removeFromSuperview];
        [scrollView release];
        scrollView = nil;
    }
    
    if (blockModel) {
        [blockModel release];
        blockModel = nil;
    }
    
    if (textLabel) {
        [textLabel removeFromSuperview];
        [textLabel release];
        textLabel = nil;
    }
    
    if (textField) {
        textField.delegate = nil;
        [textField removeFromSuperview];
        [textField release];
        textField = nil;
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        self.cols = 4;
    }
    return self;
}

- (void)addScrollView {
    if (self.scrollView == nil) {
        UIScrollView *tScrollView = [[UIScrollView alloc] init];
        self.scrollView = tScrollView;
        [tScrollView release];
        
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = YES;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.pagingEnabled = NO;
        self.scrollView.decelerationRate = 0.0;
        
        [self addSubview:self.scrollView];
    }
    self.scrollView.frame = self.bounds;
    
    if (self.contentView == nil) {
        UIView *tView = [[UIView alloc] init];
        self.contentView = tView;
        [tView release];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.contentView];
    }
    self.contentView.frame = self.scrollView.bounds;
}

- (void)addTextLabel {
    if (self.textLabel == nil) {
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 5.0, 284.0, 30.0)];
        self.textLabel = tLabel;
        [tLabel release];
        
        NSString *fontName = @"FZLanTingHei-R-GBK";
        self.textLabel.font = [UIFont fontWithName:fontName size:16.0];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textLabel];
    }
    
    self.textLabel.text = self.blockModel.blockTitle;
}

- (void)addTextField {
    if (self.textField == nil) {
        UITextField *tTextField = [[UITextField alloc] initWithFrame:CGRectMake(17.0, 5.0, 300.0, 30.0)];
        self.textField = tTextField;
        [tTextField release];
        
        self.textField.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:16.0];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.secureTextEntry = NO;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.textField];
    }
    
    self.textField.placeholder = self.blockModel.blockTitle;
    self.textField.text = self.blockModel.blockTitle;
    self.textField.alpha = self.curEditState ? 1.0 : 0.0;
    self.textField.enabled = self.curEditState ? YES : NO;
}

- (void)layoutBlockFolderView {
    [self addScrollView];
    [self addTextLabel];
    [self addTextField];
}

- (CGFloat)calculateFolderHeightWithFlag:(BOOL)isAdd {    
    int count = [self.blockModel.blocks count];
    
    int row = 0;
    if (isAdd) {
        row = count/self.cols+1;
    } else {
        int mol = count%self.cols;
        row = mol==0 ? count/self.cols: count/self.cols+1;
    }
    
    CGRect textLabelRect = self.textLabel.frame;
    CGFloat height = row*self.blockViewHeight+textLabelRect.origin.y+textLabelRect.size.height;
    
    return height;
}

- (CGRect)calculateBlockViewFrame:(int)index {
    int row = index/self.cols;
    int col = index%self.cols;
    
    CGRect textLabelRect = self.textLabel.frame;
    CGFloat y = textLabelRect.origin.y+textLabelRect.size.height;
    CGRect rect = CGRectMake(MaginLeft+col*self.blockViewWidth, row*self.blockViewHeight+y, self.blockViewWidth, self.blockViewHeight);
    
    return rect;
}

- (void)changeContentSize {
    CGRect rect = self.bounds;
    
    self.scrollView.frame = rect;
    self.scrollView.contentSize = rect.size;
    
    self.contentView.frame = rect;
    
    rect = self.textLabel.frame;
    rect.size.height = 30.0;
    self.textLabel.frame = rect;
    
    rect = self.textField.frame;
    rect.size.height = 30.0;
    self.textField.frame = rect;
}

- (void)showOrHidetextField {
    [UIView beginAnimations:@"showOrHidetextField" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    self.textLabel.alpha = self.curEditState ? 0.0 : 1.0;
    self.textField.alpha = self.curEditState ? 1.0 : 0.0;
    self.textField.enabled = self.curEditState ? YES : NO;
    
    [UIView commitAnimations];
}

- (void)setCurEditState:(BOOL)editState {
    curEditState = editState;
    
    [self showOrHidetextField];
}

//============UITextFieldDelegate============
- (BOOL)textFieldShouldReturn:(UITextField*)tField {
    [tField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BlockFolderView:textFieldDidBeginEditing:)]) {
        [self.delegate BlockFolderView:self textFieldDidBeginEditing:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
    NSString *text = self.textField.text;
    
    if (![MyUnit NSStringIsEmpty:text]) {
        BlockDataSource *dataSource = [BlockDataSource curBlockDataSource];
        dataSource.blocksIsEdit = YES;
        self.blockModel.blockTitle = text;
        
        self.textField.placeholder = text;
        self.textLabel.text = text;
    } else {
        self.textField.text = self.textField.placeholder;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BlockFolderView:textFieldDidEndEditing:)]) {
        [self.delegate BlockFolderView:self textFieldDidEndEditing:nil];
    }
}

@end
