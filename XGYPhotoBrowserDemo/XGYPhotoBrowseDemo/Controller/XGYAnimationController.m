//
//  XGYAnimationController.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYAnimationController.h"
#import "XGYPhotoCell.h"
#import "XGYImageModel.h"
#import "XGYPhotoBrowser.h"

@interface XGYAnimationController () <UICollectionViewDelegate,UICollectionViewDataSource,XGYPhotoBrowserDelegate>

/**
 视图布局
 */
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *listArray;

/**
 点击的下标
 */
@property (nonatomic, assign)  NSInteger clickIndex;

@end

@implementation XGYAnimationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self setupCollectionView];
}


#pragma mark - initData
- (void)initData
{
    self.listArray = [XGYImageModel imageURLArray];
    
}



#pragma mark - UI
- (void)setupCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //布局
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview: self.collectionView];
    //注册cell
    [self.collectionView registerClass:[XGYPhotoCell class] forCellWithReuseIdentifier:@"listCell"];
    
    
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XGYPhotoCell *listCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    NSString *url = [self.listArray objectAtIndex:indexPath.item];
    [listCell.photo yy_setImageWithURL:[NSURL URLWithString:url] options:0];
    return listCell;
}


/**
 图片的点击事件 重载了父类的方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickIndex = indexPath.item;
    XGYPhotoBrowser *browser = [XGYPhotoBrowser browserWithDelegate:self totalPhotoCount:self.listArray.count currentIndex:indexPath.item];
    [browser showPhotoBroswer];
}

#pragma mark - XGYPhotoBrowserDelegate
/**
 * 返回临时占位图
 * @param browser 当前浏览器
 * @param index   当前的下标
 * @return 返回图片
 */
- (UIImage *)photoBrowser:(XGYPhotoBrowser *)browser replaceImageAtIndex:(NSUInteger)index imageURL:(NSURL *)imageURL
{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSString *key =  [[YYWebImageManager sharedManager] cacheKeyForURL:imageURL];
    return [cache getImageForKey:key];
}

/**
 * 返回大图的URL
 * @param browser 图片浏览器
 * @param index   当前的下标
 * @return 图片URL
 */
- (NSURL *)photoBrowser:(XGYPhotoBrowser *)browser imageURLAtIndex:(NSUInteger)index
{
    NSString *url = [self.listArray objectAtIndex:index];
    return [NSURL URLWithString:url];
}

/**
 * 对应下标的缩略图所在的View
 * @param browser 当前的视图浏览器
 * @param index   当前的下标
 * @return 返回缩略图所在的View
 */
- (UIView *)photoBrowser:(XGYPhotoBrowser *)browser thumbnailFrameAtIndex:(NSUInteger)index
{
    //注 ：微信展开图片和收起图片都是回到同一个位置，要实现该种效果 只要传一个相同的 view 即可
    // XGYPhotoCell *listCell = (XGYPhotoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.clickIndex inSection:0]];
    
    
    XGYPhotoCell *listCell = (XGYPhotoCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return listCell;
}


/**
 * 当前滑动到某一张图片
 * @param browser 图片浏览器
 * @param index   当前的下标
 */
- (void)photoBrowser:(XGYPhotoBrowser *)browser didScrollPhotoToIndex:(NSUInteger)index
{
    NSLog(@"didScrollPhotoToIndex，index = %ld",index);
}

#pragma mark - customUI

/**
 * 返回显示图片页码的 View 默认是label 可以修改文字的颜色和frame
 * @param browser 当前的浏览器
 * @return 图片页码的View
 */
- (UIView *)photoBrowser:(XGYPhotoBrowser *)browser pageIndexView:(UILabel *)pageIndexView
{
    
    CGFloat ScreanW = [UIScreen mainScreen].bounds.size.width;
    /*
     // 方案 2
     UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreanW, 35)];
     indexView.backgroundColor = [UIColor redColor];
     return indexView;
     */
    
    // 方案 1
    pageIndexView.frame = CGRectMake((ScreanW - 100)/2.0f, 40, 100, 40);
    return pageIndexView;

}

- (void)photoBrowser:(XGYPhotoBrowser *)browser didChangePageIndex:(NSInteger)pageIndex pageIndexView:(UIView *)pageIndexView
{
    
}

@end
