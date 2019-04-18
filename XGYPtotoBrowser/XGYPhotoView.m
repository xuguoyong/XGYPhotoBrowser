//
//  XGYPhotoView.m
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 12/25/16.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import "XGYPhotoView.h"
#import "XGYLoadingProgressLayer.h"
#import "XGYPhotoBrowser.h"




const CGFloat kXGYPhotoViewPadding = 10;
const CGFloat kXGYPhotoViewMaxScale = 3;

@interface XGYPhotoView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) YYAnimatedImageView *imageView;
@property (nonatomic, strong, readwrite) XGYLoadingProgressLayer *progressLayer;
/**
 图片的URL
 */
@property (nonatomic, strong, readwrite) NSURL *imageURL;

@end

@implementation XGYPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = kXGYPhotoViewMaxScale;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.delegate = self;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _imageView = [[YYAnimatedImageView  alloc] init];
        //默认图片颜色
        _imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [self resetImageViewFrame];
        
        _progressLayer = [[XGYLoadingProgressLayer alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _progressLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}
/**
 * 设置图片的URL
 * @param imageURL 图片URL
 * @param replaceImage 占位图
 * @param determinate 是否是显示下载进度
 */
- (void)setImageURL:(NSURL *)imageURL replaceImage:(UIImage *)replaceImage determinate:(BOOL)determinate completion:(void (^)(NSURL * _Nonnull, BOOL))completion
{
    _imageURL = imageURL;
    [_imageView yy_cancelCurrentImageRequest];
    [_imageView yy_cancelCurrentHighlightedImageRequest];
    
    //没有URL 重置一下
    if (!imageURL) {
        [_progressLayer xgy_stopAnimation];
        _progressLayer.hidden = YES;
        _imageView.image = replaceImage;
        [self resetImageViewFrame];
        if (completion) {
            completion(imageURL,NO);
        }
        return;
    }
    
    //本地已经缓存好了 直接使用
    UIImage *localCacheImage = [self cacheImageWithImageURL:imageURL];
    if (localCacheImage && self.cacheImage) {
        _imageView.image = localCacheImage;
        [_progressLayer xgy_stopAnimation];
        _progressLayer.hidden = YES;
        [self resetImageViewFrame];
        if (completion) {
            completion(imageURL,YES);
        }
        return;
    }
    
    
    __weak typeof(self) wself = self;
    
    YYWebImageProgressBlock progressBlock = nil;
    if (determinate) {
        progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize) {
            __strong typeof(wself) sself = wself;
            double progress = (double)receivedSize / expectedSize;
            sself.progressLayer.hidden = NO;
            sself.progressLayer.strokeEnd = MAX(progress, 0.01);
        };
    } else {
        [_progressLayer xgy_startAnimation];
    }
    _progressLayer.hidden = NO;
    
    _imageView.image = replaceImage;
    
    //判断是否是需要使用缓存
    YYWebImageOptions options = YYWebImageOptionShowNetworkActivity | YYWebImageOptionAllowInvalidSSLCertificates;
    if (!self.cacheImage) {
      options = YYWebImageOptionShowNetworkActivity | YYWebImageOptionAllowInvalidSSLCertificates | YYWebImageOptionRefreshImageCache;
    }
    
    [_imageView yy_setImageWithURL:imageURL placeholder:replaceImage options:options completion:^(UIImage * _Nullable image, NSURL * _Nonnull imageURL, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
         __strong typeof(wself) sself = wself;
        if (!error) {
            [sself resetImageViewFrame];
        }
        [sself.progressLayer xgy_stopAnimation];
        sself.progressLayer.hidden = YES;
        if (completion) {
            completion(imageURL,!error);
        }
        
    }];
    
     [self resetImageViewFrame];
}

- (void)resetImageViewFrame {
    if (_imageView.image) {
        CGSize imageSize = _imageView.image.size;
        CGFloat width = self.frame.size.width - 2 * kXGYPhotoViewPadding;
        CGFloat height = width * (imageSize.height / imageSize.width);
        CGRect rect = CGRectMake(0, 0, width, height);
        
        _imageView.frame = rect;
        
        // If image is very high, show top content.
        if (height <= self.bounds.size.height) {
            _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        } else {
            _imageView.center = CGPointMake(self.bounds.size.width/2, height/2);
        }
        
        // If image is very wide, make sure user can zoom to fullscreen.
        if (width / height > 2) {
            self.maximumZoomScale = self.bounds.size.height / height;
        }
    } else {
        CGFloat width = self.frame.size.width - 2 * kXGYPhotoViewPadding;
        _imageView.frame = CGRectMake(0, 0, width, width * 2.0 / 3);
        _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    self.contentSize = _imageView.frame.size;
    self.zoomScale = 1.f;
}

- (void)cancelCurrentImageLoad {
    [_imageView yy_cancelCurrentImageRequest];
    [_imageView yy_cancelCurrentHighlightedImageRequest];
    [_progressLayer xgy_stopAnimation];
}

- (BOOL)isScrollViewOnTopOrBottom {
    CGPoint translation = [self.panGestureRecognizer translationInView:self];
    if (translation.y > 0 && self.contentOffset.y <= 0) {
        return YES;
    }
    CGFloat maxOffsetY = floor(self.contentSize.height - self.bounds.size.height);
    if (translation.y < 0 && self.contentOffset.y >= maxOffsetY) {
        return YES;
    }
    return NO;
}

#pragma mark - ScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            if ([self isScrollViewOnTopOrBottom]) {
                return NO;
            }
        }
    }
    return YES;
}
/**
 获取缓存的图片
 
 @param imageURL 图片URL
 @return 返回缓存图片
 */
- (UIImage *)cacheImageWithImageURL:(NSURL *)imageURL
{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSString *key =  [[YYWebImageManager sharedManager] cacheKeyForURL:imageURL];
    return [cache getImageForKey:key];
}

- (BOOL)dowloadImageSuccess
{
    return [self cacheImageWithImageURL:self.imageURL];
}


//获取本地缓存的image
+ (UIImage *)localCacheImageWithImageURL:(NSURL *)imageURL
{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSString *key =  [[YYWebImageManager sharedManager] cacheKeyForURL:imageURL];
    return [cache getImageForKey:key];

}


@end
