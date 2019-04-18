//
//  XGYPhotoBrowser.m
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 12/25/16.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import "XGYPhotoBrowser.h"
#import "XGYPhotoView.h"


//浏览器界面显示和消失的动画时长
static const NSTimeInterval kAnimationDuration = 0.33;

//浏览器回弹效果的动画时长
static const NSTimeInterval kSpringAnimationDuration = 0.5;




@interface XGYPhotoBrowser () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, CAAnimationDelegate>

/**
 背景的ScrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 所有的复用视图
 */
@property (nonatomic, strong) NSMutableSet *reusablePhotoViews;

/**
 可用的视图
 */
@property (nonatomic, strong) NSMutableArray *visiblePhotoViews;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *photoURLArray;

/**
 当前滚动的页码下标
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 当前界面是否是已经被 presented出来
 */
@property (nonatomic, assign) BOOL presented;

/**
 最开始的触摸位置
 */
@property (nonatomic, assign) CGPoint startLocation;

/**
 第一张图片的原始位置
 */
@property (nonatomic, assign) CGRect startFrame;

/**
 默认页码 label
 */
@property (nonatomic, strong) UILabel *pageLabel;

/**
 用户自定义的页码View
 */
@property (nonatomic, strong) UIView *customPageIndexView;

/**
 用户自定义的页码View的 frame
 */
@property (nonatomic, assign) CGRect customPageIndexViewPageRect;

@end

@implementation XGYPhotoBrowser

#pragma mark - Initializer

+ (instancetype)browserWithPhotoItems:(NSArray *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    XGYPhotoBrowser *browser = [[XGYPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}

- (instancetype)init {
    NSAssert(NO, @"Use initWithMediaItems: instead.");
    return nil;
}

- (instancetype)initWithPhotoItems:(NSArray *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        self.currentPage = selectedIndex;
        
        _dismissAnimation = XGYPhotoBrowserDismissAnimationScale;
        _loadingType = XGYPhotoBrowserLoadingTypeIndeterminate;
        
        _reusablePhotoViews = [[NSMutableSet alloc] init];
        _visiblePhotoViews = [[NSMutableArray alloc] init];

        _cacheImage = YES;
        _bounces = NO;
    }
    return self;
}

+ (instancetype)browserWithPhotoURLArray:(NSArray*)photoURLArray
                            currentIndex:(NSUInteger)currentIndex
{
    XGYPhotoBrowser *browser = [[XGYPhotoBrowser alloc] initWithDelegate:nil totalPhotoCount:photoURLArray.count currentIndex:currentIndex];
    browser.photoURLArray = [photoURLArray mutableCopy];
    return browser;
}
+ (instancetype)browserWithDelegate:(id<XGYPhotoBrowserDelegate>)delegate
                    totalPhotoCount:(NSUInteger)totalPhotoCount
                       currentIndex:(NSUInteger)currentIndex
{
    XGYPhotoBrowser *browser = [[XGYPhotoBrowser alloc] initWithDelegate:delegate totalPhotoCount:totalPhotoCount currentIndex:currentIndex];
    return browser;
}

- (instancetype)initWithDelegate:(id<XGYPhotoBrowserDelegate>)delegate
                    totalPhotoCount:(NSUInteger)totalPhotoCount
                       currentIndex:(NSUInteger)currentIndex
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        self.currentPage = currentIndex;
        
        _dismissAnimation = XGYPhotoBrowserDismissAnimationScale;
        _loadingType = XGYPhotoBrowserLoadingTypeIndeterminate;
        
        _reusablePhotoViews = [[NSMutableSet alloc] init];
        _visiblePhotoViews = [[NSMutableArray alloc] init];
        
        _cacheImage = YES;
        _bounces = NO;
        _delegate = delegate;
        _imageCount = totalPhotoCount;
    }
    return self;
}

#pragma mark - system Medtod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont systemFontOfSize:16];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:pageIndexView:)]) {
        self.customPageIndexView = [self.delegate photoBrowser:self pageIndexView:self.pageLabel];
        self.customPageIndexViewPageRect = self.customPageIndexView.frame;
        [self.view addSubview:self.customPageIndexView];
    } else {
        [self.view addSubview:self.pageLabel];
    }
    
    //更新文字下标
    [self xgy_setPageLabelTextWithPage:self.currentPage];
    
    [self xgy_setupFrames];
    
    [self xgy_addGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:didScrollPhotoToIndex:)]) {
        [self.delegate photoBrowser:self didScrollPhotoToIndex:self.currentPage];
    }
    
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    photoView.imageView.image = [self xgy_replaceImageAtIndex:self.currentPage];
    [photoView resetImageViewFrame];
    
    CGRect sourceRect = [self xgy_resouceViewRelativeFramePhotoView:photoView atIndex:self.currentPage];
    if (CGRectEqualToRect(sourceRect, CGRectZero)) {
        photoView.alpha = 0;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.view.backgroundColor = [UIColor blackColor];
            photoView.alpha = 1;
        } completion:^(BOOL finished) {
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:self.currentPage]];
            self.presented = YES;
            [self xgy_setStatusBarHidden:YES];
        }];
        return;
    }
    
    
      CGRect endRect = photoView.imageView.frame;
      photoView.imageView.frame = sourceRect;
    
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:self.currentPage]];
            self.presented = YES;
            [self xgy_setStatusBarHidden:YES];
        }];
    } else {
        CGRect startBounds = CGRectMake(0, 0, sourceRect.size.width, sourceRect.size.height);
        CGRect endBounds = CGRectMake(0, 0, endRect.size.width, endRect.size.height);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startBounds cornerRadius:0.1];
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endBounds cornerRadius:0.1];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = endBounds;
        photoView.imageView.layer.mask = maskLayer;
        
        CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskAnimation.duration = kAnimationDuration;
        maskAnimation.fromValue = (__bridge id _Nullable)startPath.CGPath;
        maskAnimation.toValue = (__bridge id _Nullable)endPath.CGPath;
        maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskAnimation forKey:nil];
        maskLayer.path = endPath.CGPath;
        
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:self.currentPage]];
            self.presented = YES;
            [self xgy_setStatusBarHidden:YES];
            photoView.imageView.layer.mask = nil;
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self xgy_setupFrames];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (void)dealloc {
    
}


#pragma mark - UIScrollViewDelagate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xgy_updateReusablePhotoViews];
    [self xgy_configPhotoViews];
    
}

#pragma mark - updateUI

- (void)xgy_setupFrames {
    CGRect rect = self.view.bounds;
    
    rect.origin.x -= kXGYPhotoViewPadding;
    rect.size.width += 2 * kXGYPhotoViewPadding;
    self.scrollView.frame = rect;
    
    if (self.customPageIndexView) {
        self.customPageIndexView.frame = self.customPageIndexViewPageRect;
    } else {
        CGRect pageRect = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 20);
        self.pageLabel.frame = pageRect;
    }
   
    
    for (XGYPhotoView *photoView in _visiblePhotoViews) {
        CGRect rect = self.scrollView.bounds;
        rect.origin.x = photoView.tag * self.scrollView.bounds.size.width;
        photoView.frame = rect;
        [photoView resetImageViewFrame];
    }
    
    CGPoint contentOffset = CGPointMake(self.scrollView.frame.size.width * self.currentPage, 0);
    [self.scrollView setContentOffset:contentOffset animated:false];
    if (contentOffset.x == 0) {
        [self scrollViewDidScroll:self.scrollView];
    }
    
    CGSize contentSize = CGSizeMake(rect.size.width * self.imageCount, rect.size.height);
    self.scrollView.contentSize = contentSize;
}

- (void)xgy_setStatusBarHidden:(BOOL)hidden {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (hidden) {
        window.windowLevel = UIWindowLevelStatusBar + 1;
    } else {
        window.windowLevel = UIWindowLevelNormal;
    }
}

- (void)xgy_configPhotoView:(XGYPhotoView *)photoView withImageURL:(NSURL *)withImageURL {
    [photoView setImageURL:withImageURL replaceImage:[self xgy_replaceImageAtIndex:self.currentPage] determinate:_loadingType == XGYPhotoBrowserLoadingTypeDeterminate completion:nil];
}

- (void)xgy_setPageLabelTextWithPage:(NSUInteger)page {
    self.pageLabel.text = [NSString stringWithFormat:@"%lu / %lu", page+1, self.imageCount];
    //回调代理 图片下标发生改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:didChangePageIndex:pageIndexView:)]) {
        [self.delegate photoBrowser:self didChangePageIndex:page pageIndexView:self.customPageIndexView ? : self.pageLabel];
    }
}


#pragma mark - PhotoViews

- (void)xgy_updateReusablePhotoViews {
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (XGYPhotoView *photoView in _visiblePhotoViews) {
        if (photoView.frame.origin.x + photoView.frame.size.width < self.scrollView.contentOffset.x - self.scrollView.frame.size.width ||
            photoView.frame.origin.x > self.scrollView.contentOffset.x + 2 * self.scrollView.frame.size.width) {
            [photoView removeFromSuperview];
            [self xgy_configPhotoView:photoView withImageURL:nil];
            [itemsForRemove addObject:photoView];
            [_reusablePhotoViews addObject:photoView];
        }
    }
    [_visiblePhotoViews removeObjectsInArray:itemsForRemove];
}

- (void)xgy_configPhotoViews {
    NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width + 0.5;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i < 0 || i >= self.imageCount) {
            continue;
        }
        XGYPhotoView *photoView = [self xgy_photoViewForPage:i];
        if (photoView == nil) {
            photoView = [self xgy_dequeueReusablePhotoView];
            CGRect rect = self.scrollView.bounds;
            rect.origin.x = i * self.scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = i;
            [self.scrollView addSubview:photoView];
            [_visiblePhotoViews addObject:photoView];
        }
        if (!photoView.imageURL && self.presented) {
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:i]];
        }
    }
    
    if (page != self.currentPage && self.presented && (page >= 0 && page < self.imageCount)) {
        
        self.currentPage = page;
        [self xgy_setPageLabelTextWithPage:self.currentPage];
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didScrollPhotoToIndex:)]) {
            [_delegate photoBrowser:self didScrollPhotoToIndex:page];
        }
        
    }
}

- (XGYPhotoView *)xgy_photoViewForPage:(NSUInteger)page {
    for (XGYPhotoView *photoView in _visiblePhotoViews) {
        if (photoView.tag == page) {
            return photoView;
        }
    }
    return nil;
}

- (XGYPhotoView *)xgy_dequeueReusablePhotoView {
    XGYPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView == nil) {
        photoView = [[XGYPhotoView alloc] initWithFrame:self.scrollView.bounds];
        photoView.cacheImage = self.cacheImage;
    } else {
        [_reusablePhotoViews removeObject:photoView];
    }
    photoView.tag = -1;
    return photoView;
}




#pragma mark - Animation

- (void)xgy_performRotationWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self xgy_handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat angle = 0;
            CGFloat height = MAX(photoView.imageView.frame.size.height, photoView.frame.size.height);
            if (_startLocation.x < self.view.frame.size.width/2) {
                angle = -(M_PI / 2) * (point.y / height);
            } else {
                angle = (M_PI / 2) * (point.y / height);
            }
            CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(0, point.y);
            CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
            photoView.imageView.transform = transform;
            
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self xgy_showRotationCompletionAnimationFromPoint:point velocity:velocity];
            } else {
                [self xgy_showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)xgy_performScaleWithPan:(UIPanGestureRecognizer *)pan {
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:photoView];
    CGPoint velocity = [pan velocityInView:self.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            self.startFrame = photoView.imageView.frame;
            [self xgy_handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;
            double s = MAX(percent, 0.3);
            
            CGFloat width = self.startFrame.size.width * s;
            CGFloat height = self.startFrame.size.height * s;
            
            CGFloat rateX = (_startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (_startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY;
            
            
            photoView.imageView.frame = CGRectMake(x, y, width, height);
            
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self xgy_showDismissalAnimation];
            } else {
                [self xgy_showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)xgy_performSlideWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self xgy_handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            photoView.imageView.transform = CGAffineTransformMakeTranslation(0, point.y);
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self xgy_showSlideCompletionAnimationFromPoint:point velocity:velocity];
            } else {
                [self xgy_showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)xgy_dismissAnimated:(BOOL)animated {
    
    //取消所有的图片下载
    for (XGYPhotoView *photoView in _visiblePhotoViews) {
        [photoView cancelCurrentImageLoad];
    }
    
    [self dismissViewControllerAnimated:animated completion:nil];
}



#pragma mark - Gesture Recognizer

- (void)xgy_addGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xgy_didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xgy_didSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(xgy_didLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(xgy_didPan:)];
    [self.view addGestureRecognizer:pan];
}


- (void)xgy_handlePanBegin {
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    [photoView cancelCurrentImageLoad];
    [self xgy_setStatusBarHidden:NO];
    photoView.progressLayer.hidden = YES;
}

- (void)xgy_didSingleTap:(UITapGestureRecognizer *)tap {
    
    if ([self xgy_shouldTapPhotoAtIndex:self.currentPage]) {
      [self xgy_showDismissalAnimation];
    }
    
    
}

- (void)xgy_didDoubleTap:(UITapGestureRecognizer *)tap {
    
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    if (!photoView.imageView.image) {
        return;
    }
    if (photoView.zoomScale > 1) {
        [photoView setZoomScale:1 animated:YES];
    } else {
        CGPoint location = [tap locationInView:self.view];
        CGFloat maxZoomScale = photoView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;
        [photoView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}

- (void)xgy_didLongPress:(UILongPressGestureRecognizer *)longPress {
    
    if (![self xgy_shouldLongPressPhotoAtIndex:self.currentPage]) {
        return;
    }
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    UIImage *image = photoView.imageView.image;
    if (!image) {
        return;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:didLongPressPhotoAtIndex:)]) {
        [self.delegate photoBrowser:self didLongPressPhotoAtIndex:self.currentPage];
    }
   
}

- (void)xgy_didPan:(UIPanGestureRecognizer *)pan {

    switch (_dismissAnimation) {
        case XGYPhotoBrowserDismissAnimationRotation:
            [self xgy_performRotationWithPan:pan];
            break;
        case XGYPhotoBrowserDismissAnimationScale:
            [self xgy_performScaleWithPan:pan];
            break;
        case XGYPhotoBrowserDismissAnimationSlide:
            [self xgy_performSlideWithPan:pan];
            break;
        default:
            break;
    }
}


- (void)xgy_showCancellationAnimation {
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    if (!photoView.dowloadImageSuccess) {
        photoView.progressLayer.hidden = NO;
    }
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            if (self.dismissAnimation == XGYPhotoBrowserDismissAnimationScale) {
                photoView.imageView.frame = self.startFrame;
            } else {
                photoView.imageView.transform = CGAffineTransformIdentity;
            }
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self xgy_setStatusBarHidden:YES];
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:self.currentPage]];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            if (self.dismissAnimation == XGYPhotoBrowserDismissAnimationScale) {
                photoView.imageView.frame = self.startFrame;
            } else {
                photoView.imageView.transform = CGAffineTransformIdentity;
            }
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self xgy_setStatusBarHidden:YES];
            [self xgy_configPhotoView:photoView withImageURL:[self xgy_imageURLAtIndex:self.currentPage]];
        }];
    }
}

- (void)xgy_showRotationCompletionAnimationFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    BOOL startFromLeft = _startLocation.x < self.view.frame.size.width / 2;
    BOOL throwToTop = point.y < 0;
    CGFloat angle, toTranslationY;
    CGFloat height = MAX(photoView.imageView.frame.size.height, photoView.frame.size.height);
    
    if (throwToTop) {
        angle = startFromLeft ? (M_PI / 2) : -(M_PI / 2);
        toTranslationY = -height;
    } else {
        angle = startFromLeft ? -(M_PI / 2) : (M_PI / 2);
        toTranslationY = height;
    }
    
    CGFloat angle0 = 0;
    if (_startLocation.x < self.view.frame.size.width/2) {
        angle0 = -(M_PI / 2) * (point.y / height);
    } else {
        angle0 = (M_PI / 2) * (point.y / height);
    }
    
    NSTimeInterval duration = MIN(500 / fabs(velocity.y), kAnimationDuration);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(angle0);
    rotationAnimation.toValue = @(angle);
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translationAnimation.fromValue = @(point.y);
    translationAnimation.toValue = @(toTranslationY);
    CAAnimationGroup *throwAnimation = [CAAnimationGroup animation];
    throwAnimation.duration = duration;
    throwAnimation.delegate = self;
    throwAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    throwAnimation.animations = @[rotationAnimation, translationAnimation];
    [throwAnimation setValue:@"throwAnimation" forKey:@"id"];
    [photoView.imageView.layer addAnimation:throwAnimation forKey:@"throwAnimation"];
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, toTranslationY);
    CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
    photoView.imageView.transform = transform;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    } completion:nil];
}

- (void)xgy_showDismissalAnimation {

    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    [photoView cancelCurrentImageLoad];
    [self xgy_setStatusBarHidden:NO];
    
    CGRect sourceRect = [self xgy_resouceViewRelativeFramePhotoView:photoView atIndex:self.currentPage];
    if (CGRectEqualToRect(sourceRect, CGRectZero)) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self xgy_dismissAnimated:NO];
        }];
        return;
    }
    
    
    photoView.progressLayer.hidden = YES;
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self xgy_dismissAnimated:NO];
        }];
    } else {
        CGRect startRect = photoView.imageView.frame;
        CGRect endBounds = CGRectMake(0, 0, sourceRect.size.width, sourceRect.size.height);
        CGRect startBounds = CGRectMake(0, 0, startRect.size.width, startRect.size.height);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startBounds cornerRadius:0.1];
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endBounds cornerRadius:0.1];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = endBounds;
        photoView.imageView.layer.mask = maskLayer;
        
        CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskAnimation.duration = kAnimationDuration;
        maskAnimation.fromValue = (__bridge id _Nullable)startPath.CGPath;
        maskAnimation.toValue = (__bridge id _Nullable)endPath.CGPath;
        maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskAnimation forKey:nil];
        maskLayer.path = endPath.CGPath;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self xgy_dismissAnimated:NO];
        }];
    }
}

- (void)xgy_showSlideCompletionAnimationFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    XGYPhotoView *photoView = [self xgy_photoViewForPage:self.currentPage];
    BOOL throwToTop = point.y < 0;
    CGFloat toTranslationY = 0;
    if (throwToTop) {
        toTranslationY = -self.view.frame.size.height;
    } else {
        toTranslationY = self.view.frame.size.height;
    }
    NSTimeInterval duration = MIN(500 / fabs(velocity.y), kAnimationDuration);
    [UIView animateWithDuration:duration animations:^{
        photoView.imageView.transform = CGAffineTransformMakeTranslation(0, toTranslationY);
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self xgy_dismissAnimated:YES];
    }];
}


#pragma mark -Privite

/**
 对应图片视图的相对位置
 @param index 图片下标
 @return 返回相对位置
 */
- (CGRect)xgy_resouceViewRelativeFramePhotoView:(XGYPhotoView *)photoView atIndex:(NSUInteger)index
{
     CGRect sourceRect = CGRectZero;
    UIView *sourceView = [self xgy_resouceViewAtIndex:index];
    if (sourceView) {
        
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion >= 8.0 && systemVersion < 9.0) {
            sourceRect =   [sourceView.superview convertRect:sourceView.frame toCoordinateSpace:photoView];
        } else {
            sourceRect =  [sourceView.superview convertRect:sourceView.frame toView:photoView];
        }
    }
    
    return sourceRect;
    
}

- (UIImage *)xgy_replaceImageAtIndex:(NSUInteger)index
{
    UIImage *image = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:replaceImageAtIndex:imageURL:)]) {
        image = [self.delegate photoBrowser:self replaceImageAtIndex:index imageURL:[self xgy_imageURLAtIndex:index]];
    }
    
    //如果image没有 那就试一下缓存
    if (self.cacheImage && !image) {
        NSURL *imageURL = [self xgy_imageURLAtIndex:index];
        image = [XGYPhotoView localCacheImageWithImageURL:imageURL];
    }
    
    return image;
}

- (NSURL *)xgy_imageURLAtIndex:(NSUInteger)index
{
    NSURL *imageURL = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:imageURLAtIndex:)]) {
        imageURL = [self.delegate photoBrowser:self imageURLAtIndex:index];
    } else if (self.photoURLArray.count > index) {
        id url = [self.photoURLArray objectAtIndex:index];
        if (url && [url isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:url];
        } else if (url && [url isKindOfClass:[NSURL class]]) {
            imageURL = url;
        }
    }
    
    return imageURL;
}

- (UIView *)xgy_resouceViewAtIndex:(NSUInteger)index
{
    UIView *sourceView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:thumbnailFrameAtIndex:)]) {
         sourceView = [self.delegate photoBrowser:self thumbnailFrameAtIndex:index];
    }
    return sourceView;
        
}

- (BOOL)xgy_shouldTapPhotoAtIndex:(NSUInteger)index
{
    BOOL should = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:shouldTapPhotoAtIndex:)]) {
        should = [self.delegate photoBrowser:self shouldTapPhotoAtIndex:index];
    }
    return should;
}

- (BOOL)xgy_shouldLongPressPhotoAtIndex:(NSUInteger)index
{
    BOOL should = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:shouldLongPressPhotoAtIndex:)]) {
        should = [self.delegate photoBrowser:self shouldLongPressPhotoAtIndex:index];
    }
    return should;
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)xgy_getWindowCurrentController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentController = [self xgy_getCurrentControllerFromRootController:rootViewController];
    return currentController;
}


- (UIViewController *)xgy_getCurrentControllerFromRootController:(UIViewController *)rootController
{
    UIViewController *currentController;
    if ([rootController presentedViewController]) {
        currentController = [rootController presentedViewController];
    }
    
    if ([rootController isKindOfClass:[UITabBarController class]]) {
        currentController = [self xgy_getCurrentControllerFromRootController:[(UITabBarController *)rootController selectedViewController]];
    } else if ([rootController isKindOfClass:[UINavigationController class]]){
        currentController = [self xgy_getCurrentControllerFromRootController:[(UINavigationController *)rootController visibleViewController]];
    } else {
        currentController = rootController;
    }
    
    return currentController;
}

#pragma mark - Public Method

- (void)showPhotoBroswer
{
    UIViewController *currentController = [self xgy_getWindowCurrentController];
    [self showPhotoBroswerInViewController:currentController];
}

- (void)showPhotoBroswerInViewController:(UIViewController *)viewController
{
    [viewController presentViewController:self animated:NO completion:nil];
}

- (void)dismissPhotoBroswerWithAnimation:(BOOL)animation
{
    [self xgy_showDismissalAnimation];
}



@end
