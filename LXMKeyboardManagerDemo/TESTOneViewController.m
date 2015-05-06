//
//  TESTOneViewController.m
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "TESTOneViewController.h"
#import "LXMKeyboardManager.h"

@interface TESTOneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@property (nonatomic, strong) LXMKeyboardManager *keyboardManager;

@end

@implementation TESTOneViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"one";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ios8 上可以直接通过设置contentSize来确定其大小，scrollView的autoLayout是比较特殊的，参考http://natashatherobot.com/ios-autolayout-scrollview/
    self.contentViewHeightConstraint.constant = 700;
    self.contentViewWidthConstraint.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.keyboardManager) {
        self.keyboardManager = [[LXMKeyboardManager alloc] initWithScrollView:self.scrollView];
    }
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    self.keyboardManager = nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardManager scrollToIdealPositionWithTargetView:textField];
}

#pragma mark - buttonAction

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
