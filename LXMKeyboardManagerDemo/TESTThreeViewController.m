//
//  TESTThreeViewController.m
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "TESTThreeViewController.h"
#import "LXMKeyboardManager.h"
#import "TESTTableViewCell.h"

@interface TESTThreeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) LXMKeyboardManager *keyboardManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TESTThreeViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"three";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.keyboardManager) {
        self.keyboardManager = [[LXMKeyboardManager alloc] initWithScrollView:self.tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TESTTableViewCell"];
    cell.textField.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
