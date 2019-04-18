//
//  XGYPhotoBrowser.h
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 12/25/16.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGYPhotoBrowserProtocol.h"


@interface XGYPhotoBrowser : UIViewController

#pragma mark - Public Property
/**
 * 图片放大缩小完成后是否需要回弹效果 默认是 NO
 */
@property (nonatomic, assign) BOOL bounces;

/**
 * 是否开启图片缓存
 */
@property (nonatomic, assign) BOOL cacheImage;

/**
 * 图片总数量
 */
@property (nonatomic, assign) NSUInteger imageCount;

/**
 * 图片浏览器的代理
 */
@property (nonatomic, weak) id<XGYPhotoBrowserDelegate> delegate;

/**
 * 加载图片的loading效果
 */
@property (nonatomic, assign) XGYPhotoBrowserLoadingType loadingType;

/**
 * 浏览器消失的界面效果
 */
@property (nonatomic, assign) XGYPhotoBrowserDismissAnimation dismissAnimation;



#pragma mark - Public Method
/**
 * 初始化方式 1
 * @param photoURLArray 图片数组 NSString 或者是 NSURL
 * @param currentIndex 当前的图片下标
 * @return 图片浏览器
 */
+ (instancetype)browserWithPhotoURLArray:(NSArray*)photoURLArray
                            currentIndex:(NSUInteger)currentIndex;


/**
 * 初始化方式 2
 * @param delegate i浏览器的代理
 * @param totalPhotoCount 图片总数量
 * @param currentIndex 当前的图片下标
 * @return 图片浏览器
 */
+ (instancetype)browserWithDelegate:(id<XGYPhotoBrowserDelegate>)delegate
                    totalPhotoCount:(NSUInteger)totalPhotoCount
                       currentIndex:(NSUInteger)currentIndex;

/**
 * 展示图片浏览器
 */
- (void)showPhotoBroswer;

/**
 * 展示图片浏览器在某个控制器
 */
- (void)showPhotoBroswerInViewController:(UIViewController *)viewController;

/**
 * 隐藏图片浏览器
 */
- (void)dismissPhotoBroswerWithAnimation:(BOOL)animation;

@end

