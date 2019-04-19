//
//  XGYPhotoView.h
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 12/25/16.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGYLoadingProgressLayer.h"
#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"
#endif


extern const CGFloat kXGYPhotoViewPadding;


@interface XGYPhotoView : UIScrollView

/**
 是否开启图片缓存
 */
@property (nonatomic, assign) BOOL cacheImage;


@property (nonatomic, strong, readonly) YYAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) XGYLoadingProgressLayer *progressLayer;

/**
 图片的URL
 */
@property (nonatomic, strong, readonly) NSURL *imageURL;

/**
 下载图片是否成功
 */
@property (nonatomic, assign) BOOL dowloadImageSuccess;


- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 设置图片的URL
 * @param imageURL 图片URL
 * @param replaceImage 占位图
 * @param determinate 是否是显示下载进度
 * @param completion 下载完的回调
 */
- (void)setImageURL:(NSURL *)imageURL
       replaceImage:(UIImage *)replaceImage
        determinate:(BOOL)determinate
         completion:(void(^)(NSURL * _Nonnull imageURL,BOOL success))completion;



- (void)resetImageViewFrame;
- (void)cancelCurrentImageLoad;

//获取本地缓存的image
+ (UIImage *)localCacheImageWithImageURL:(NSURL *)imageURL;
@end
