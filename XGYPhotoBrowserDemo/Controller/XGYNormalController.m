//
//  XGYNormalController.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYNormalController.h"
#import "XGYPhotoCell.h"
#import "XGYImageModel.h"
#import "XGYPhotoBrowser.h"


@interface XGYNormalController ()  <UICollectionViewDelegate,UICollectionViewDataSource>
/**
 视图布局
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *listArray;

@end

@implementation XGYNormalController


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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XGYPhotoBrowser *browser = [XGYPhotoBrowser browserWithPhotoURLArray:self.listArray currentIndex:indexPath.item];
    [browser showPhotoBroswer];
}

@end
