//
//  JYImageToolVC.m
//  JYImageToolDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "JYMainColourViewController.h"
#import "JYImageTool.h"

@interface JYMainColourViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<UIColor *> *colorArr;
@end

@implementation JYMainColourViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextButtonAction];

}

#pragma mark - setup methods
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self imageView];
    [self collectionView];
    [self nextButton];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.colorArr[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat *components = CGColorGetComponents(self.colorArr[indexPath.row].CGColor);
    NSLog(@"R:%.2f\tG:%.2f\tB:%.2f\tA:%.1f", components[0]*255, components[1]*255, components[2]*255, components[3]);
}

#pragma mark - event & response
- (void)nextImage {
    NSString *imageName = [NSString stringWithFormat:@"resources_%d",(arc4random()%10)+1];
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)nextButtonAction {
    //随机拿一张图。
    [self nextImage];

    UIColor *whiteColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
    self.colorArr = [self.imageView.image extractColorsWithMode:JYExtractModeOnlyDistinctColors
                                                     avoidColor:whiteColor];
    [self.collectionView reloadData];
    NSLog(@"主色数量：%ld ",self.colorArr.count);
}

#pragma mark - getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_LAYOUT_GUIDE, SCREEN_WIDTH, SAFE_HEIGHT-150)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _imageView.layer.masksToBounds = YES;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_LAYOUT_GUIDE-150, SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg"]]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_LAYOUT_GUIDE-49, SCREEN_WIDTH, 49)];
        _nextButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Italic" size:30.f];
        [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [_nextButton setTitleColor:RGB(58,63,83) forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

@end
