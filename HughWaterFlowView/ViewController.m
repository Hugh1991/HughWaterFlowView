//
//  ViewController.m
//  HughWaterFlowView
//
//  Created by xiaoniu-mac on 2018/12/12.
//  Copyright © 2018 Hugh. All rights reserved.
//

#import "ViewController.h"
#import "HughWaterFlowLayout.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *waterFlowCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.waterFlowCollectionView];
}

#pragma mark ---- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *waterFlowCell = [self.waterFlowCollectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellIdentifier" forIndexPath:indexPath];
    waterFlowCell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    return waterFlowCell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(arc4random()%100+100, arc4random()%100+200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
}

- (UICollectionView *)waterFlowCollectionView {
    if (!_waterFlowCollectionView) {
        HughWaterFlowLayout *waterFlowLatyout = [[HughWaterFlowLayout alloc] init];
        _waterFlowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:waterFlowLatyout];
        _waterFlowCollectionView.backgroundColor = [UIColor whiteColor];
        _waterFlowCollectionView.delegate = self;
        _waterFlowCollectionView.dataSource = self;
        
        [_waterFlowCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellIdentifier"];
    }
    
    return _waterFlowCollectionView;
}

@end
