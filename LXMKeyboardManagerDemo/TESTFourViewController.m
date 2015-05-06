//
//  TESTFourViewController.m
//  LXMKeyboardManagerDemo
//
//  Created by luxiaoming on 15/5/5.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "TESTFourViewController.h"
#import "TESTCollectionViewCell.h"
#import "LXMKeyboardManager.h"


@interface TESTFourViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) LXMKeyboardManager *keyboardManager;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TESTFourViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"four";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.keyboardManager) {
        self.keyboardManager = [[LXMKeyboardManager alloc] initWithScrollView:self.collectionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TESTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TESTCollectionViewCell" forIndexPath:indexPath];
    cell.textField.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
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
