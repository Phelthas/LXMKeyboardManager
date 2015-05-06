//
//  LXMKeyboardManager.m
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMKeyboardManager.h"

@implementation LXMKeyboardState
@end

@interface LXMKeyboardManager   ()

@property (nonatomic, weak) UIScrollView *scrollView;//只是引用原来的scrollView，所以只能是weak
@property (nonatomic, weak) UIView *targetView;//只是引用原来的textField，所以只能是weak
@property (nonatomic, strong) LXMKeyboardState *keyboardState;

@end

@implementation LXMKeyboardManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        self.alwaysAdjust = NO;
        self.keyboardState.originalContentInset = self.scrollView.contentInset;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark - handleNotification

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)sender {
    if (self.keyboardState.isKeyboardVisible == YES) {
        return;
    }
    self.keyboardState.isKeyboardVisible = YES;
    [self scrollToIdealPositionWithTargetView:self.targetView forNotificaiton:sender];
}

- (void)handleUIKeyboardWillHideNotification:(NSNotification *)sender {
    if (self.keyboardState.isKeyboardVisible == NO) {
        return;
    }
    self.keyboardState.isKeyboardVisible = NO;
    self.targetView = nil;
    [self scrollToOriginalPosition];
}

#pragma mark -
#pragma mark - pubicMehod

- (void)scrollToIdealPositionWithTargetView:(UIView *)argView {
    [self scrollToIdealPositionWithTargetView:argView forNotificaiton:nil];
}

- (void)scrollToIdealPositionWithTargetView:(UIView *)argView forNotificaiton:(NSNotification *)sender {
    
    self.targetView = (UITextField *)argView;//这里需要先给targView赋值，之后会用到
    CGRect argViewRealRect = [argView.superview convertRect:argView.frame toView:self.scrollView];//考虑到argView可能在cell里面
    
    if (sender) {
        NSDictionary *userInfo = sender.userInfo;
        CGRect keyboardRect = [(NSValue *)userInfo[UIKeyboardBoundsUserInfoKey] CGRectValue];
        self.keyboardState.keyboardRect = keyboardRect;
        self.keyboardState.keyboardAnimationDuration = [(NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    if (self.keyboardState.isKeyboardVisible == NO) {
        return;
    }
    
    CGFloat visibleHeight = CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentInset.top - CGRectGetHeight(self.keyboardState.keyboardRect);
    
    CGFloat currentCenterY = CGRectGetMidY(argViewRealRect) - self.scrollView.contentOffset.y - self.scrollView.contentInset.top;//要考虑的是argView在可视范围内的距离屏幕边缘的位置//这是argView当前的center.y的位置
    CGFloat adjustDistance = 0;
    adjustDistance = currentCenterY - visibleHeight / 2;
    if (adjustDistance < 0) {
        //这种情况是需要从上往下调整，需要判断是否可以调整
        if (self.alwaysAdjust) {
            if (self.scrollView.contentOffset.y < -adjustDistance) {
                //如果可滑动的距离<需要调整的的距离，那就把需要调整的距离设置为可互动的距离
                adjustDistance = - self.scrollView.contentOffset.y;
            }
        }
        else {
            adjustDistance = 0;
        }
    } else {
        //如果从下往上调整，需要判断不要超出键盘的范围
        if (adjustDistance + self.keyboardState.originalContentInset.bottom >= CGRectGetHeight(self.keyboardState.keyboardRect)) {
            adjustDistance = CGRectGetHeight(self.keyboardState.keyboardRect) - self.scrollView.contentInset.bottom;
        }
    }
    
    
    self.keyboardState.adjustmentHeight = adjustDistance;
    UIEdgeInsets newContentInset = self.keyboardState.originalContentInset;
    if (newContentInset.bottom > CGRectGetHeight(self.keyboardState.keyboardRect)) {
        //这里是考虑特殊情况，一般不会出现
        newContentInset.bottom = self.keyboardState.originalContentInset.bottom + CGRectGetHeight(self.keyboardState.keyboardRect);
    }
    else {
        newContentInset.bottom = CGRectGetHeight(self.keyboardState.keyboardRect);
    }
    
    [UIView animateWithDuration:self.keyboardState.keyboardAnimationDuration animations:^{
        CGFloat finalOffsetY = self.scrollView.contentOffset.y + adjustDistance;
        if (finalOffsetY > self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds) + newContentInset.bottom) {
            finalOffsetY = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds) + newContentInset.bottom;//不能让offset.y大于完全显示contentSize时候的offset.y
        }
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, finalOffsetY) animated:NO];
    }completion:^(BOOL finished) {
        [self.scrollView setContentInset:newContentInset];// 注意：这里设置的contentInset应该固定是keyboard的高度，contentOffset不一样
    }];
    
}



- (void)scrollToOriginalPosition {
    self.keyboardState.adjustmentHeight = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:self.keyboardState.originalContentInset];
        //        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, originalContentOffsetY) animated:NO];
        //        、、这里到底怎么让他能根据原来的变化，是个问题
    }];
}

#pragma mark -
#pragma mark - property

- (LXMKeyboardState *)keyboardState {
    if (!_keyboardState) {
        _keyboardState = [[LXMKeyboardState alloc] init];
        _keyboardState.isKeyboardVisible = NO;
        _keyboardState.keyboardRect = CGRectZero;
        _keyboardState.keyboardAnimationDuration = 0;
        _keyboardState.adjustmentHeight = 0;
        _keyboardState.originalContentInset = UIEdgeInsetsZero;
    }
    return _keyboardState;
}

@end
