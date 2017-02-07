//
//  LLPhotoBrowser.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhotoBrowser.h"
#import "LLCollectionViewCell.h"

@interface LLPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,LLPhotoDelegate>{
    NSArray<UIImage *> *_images;
    NSInteger _currentIndex;
    UICollectionView *_collectionView;
    UIView *_navigationBar;
    UILabel *_titleLabel;
    BOOL _navIsHidden;
    UIView *_tabBar;
}

@end

@implementation LLPhotoBrowser

- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSInteger)currentIndex {
    self = [super init];
    if (self) {
        _images = images;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createViews];
}

- (void)createViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(PHOTO_WIDTH, PHOTO_HEIGHT);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PHOTO_WIDTH, PHOTO_HEIGHT) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LLCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    if (_currentIndex < _images.count) {
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }
    
    /******自定义界面******/
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHOTO_WIDTH, 64)];
    _navigationBar.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    [self.view addSubview:_navigationBar];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 21, 16, 22)];
    backImageView.image = [UIImage imageNamed:@"back_white"];
    [_navigationBar addSubview:backImageView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(27, 17, 40, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:backBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 17, PHOTO_WIDTH-160, 30)];
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_navigationBar addSubview:_titleLabel];
    
    _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, PHOTO_HEIGHT-44, PHOTO_WIDTH, 44)];
    _tabBar.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    [self.view addSubview:_tabBar];
    
    UIButton *sendImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendImageBtn.frame = CGRectMake(PHOTO_WIDTH-50, 7, 40, 30);
    [sendImageBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendImageBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:sendImageBtn];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell.photo.ll_delegate) {
        cell.photo.ll_delegate = self;
    }
    cell.photo.currentImage = _images[indexPath.item];
    cell.photo.currentIndex = indexPath.item;
    
    return cell;
}

#pragma mark - UICollectionViewDelagate 当图图片滑出屏幕外时，将图片比例重置为原始比例
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LLCollectionViewCell *LLCell = (LLCollectionViewCell *)cell;
    LLCell.photo.zoomScale = 1.0;
    LLCell.photo.isEnlarged = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = (long)scrollView.contentOffset.x/PHOTO_WIDTH;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
}

#pragma mark - LLPhotoDelegate 图片单击事件，显示/隐藏标题栏
- (void)singleClickWithPhoto:(LLPhoto *)photo {
    [UIView animateWithDuration:.1 animations:^{
        if (_navIsHidden) {
            _navigationBar.transform = CGAffineTransformIdentity;
            _tabBar.transform = CGAffineTransformIdentity;
        }
        else {
            _navigationBar.transform = CGAffineTransformMakeTranslation(0, -64);
            _tabBar.transform = CGAffineTransformMakeTranslation(0, 44);
        }
    } completion:^(BOOL finished) {
        _navIsHidden = !_navIsHidden;
    }];
}

#pragma mark - 返回按钮
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送按钮
- (void)sendImage:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didSelectImage:)]) {
        [self.delegate photoBrowser:self didSelectImage:_images[_currentIndex]];
    }
    [self goBack];
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
