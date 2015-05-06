//
//  TESTTwoViewController.m
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "TESTTwoViewController.h"
#import "LXMKeyboardManager.h"

@interface TESTTwoViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) LXMKeyboardManager *keyboardManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TESTTwoViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"two";
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.keyboardManager = nil;
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
    static NSString *cellIdentifer = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat: @"it is %ld",(long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
