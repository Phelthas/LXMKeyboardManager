//
//  LXMKeyboardManager.h
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXMKeyboardState : NSObject

@property (nonatomic, assign) BOOL isKeyboardVisible;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, assign) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;
@property (nonatomic, assign) CGFloat adjustmentHeight;//保存变化量而不是变化前或者变化后的量，是因为转屏可能会造成不确定的变化


@end


@interface LXMKeyboardManager : NSObject

@property (nonatomic, assign) BOOL alwaysAdjust; //是否只在键盘挡住textFiled的时候调整，default is no

/**
 *  初始化方法，务必写在viewDidAppear里面，否则计算不准，因为ios7的scrollView的contentInset到viewDidAppear的时候才会确定
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)scrollToIdealPositionWithTargetView:(UIView *)argView;

@end
