//
//  XGYPhotoBrowserProtocol.h
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 2019/4/16.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XGYPhotoBrowser;

/**
 界面消失的动画
 - XGYPhotoBrowserDismissAnimationScale: 缩放动画（类似微信）- 默认
 - XGYPhotoBrowserDismissAnimationRotation: 环形动画
 - XGYPhotoBrowserDismissAnimationSlide: 垂直下拉动画
 - XGYPhotoBrowserDismissAnimationNone: 没有动画（不允许拖拽）
 */
typedef NS_ENUM(NSUInteger, XGYPhotoBrowserDismissAnimation) {
    XGYPhotoBrowserDismissAnimationScale,
    XGYPhotoBrowserDismissAnimationRotation,
    XGYPhotoBrowserDismissAnimationSlide,
    XGYPhotoBrowserDismissAnimationNone
};


/**
 加载图片的loding的样式
 
 - XGYPhotoBrowserLoadingTypeIndeterminate: 不显示下载进度的loading
 - XGYPhotoBrowserLoadingTypeDeterminate: 显示下载进度的loading
 */
typedef NS_ENUM(NSUInteger, XGYPhotoBrowserLoadingType) {
    XGYPhotoBrowserLoadingTypeIndeterminate,
    XGYPhotoBrowserLoadingTypeDeterminate
};








#pragma mark - Delegate
@protocol XGYPhotoBrowserDelegate <NSObject>

@optional

/**
 * 返回临时占位图
 * @param browser 当前浏览器
 * @param index   当前的下标
 * @return 返回图片
 */
- (UIImage *)photoBrowser:(XGYPhotoBrowser *)browser replaceImageAtIndex:(NSUInteger)index imageURL:(NSURL *)imageURL;

/**
 * 返回大图的URL
 * @param browser 图片浏览器
 * @param index   当前的下标
 * @return 图片URL
 */
- (NSURL *)photoBrowser:(XGYPhotoBrowser *)browser imageURLAtIndex:(NSUInteger)index;

/**
 * 对应下标的缩略图所在的View
 * @param browser 当前的视图浏览器
 * @param index   当前的下标
 * @return 返回缩略图所在的View
 */
- (UIView *)photoBrowser:(XGYPhotoBrowser *)browser thumbnailFrameAtIndex:(NSUInteger)index;



/**
 * 当前滑动到某一张图片
 * @param browser 图片浏览器
 * @param index   当前的下标
 */
- (void)photoBrowser:(XGYPhotoBrowser *)browser didScrollPhotoToIndex:(NSUInteger)index;

/**
 * 图片浏览器的下标发生改变的时候会调用的回调
 * @param browser    当前的浏览器
 * @param pageIndex  当前的下标
 */
- (void)photoBrowser:(XGYPhotoBrowser *)browser didChangePageIndex:(NSInteger)pageIndex pageIndexView:(UIView *)pageIndexView;


#pragma mark - customUI

/**
 * 返回显示图片页码的 View 默认是label 可以修改文字的颜色和frame
 * @param browser 当前的浏览器
 * @return 图片页码的View
 */
- (UIView *)photoBrowser:(XGYPhotoBrowser *)browser pageIndexView:(UILabel *)pageIndexView;



#pragma mark - EventClick

/**
 * 是否允许点击图片
 * @param browser 图片浏览器
 * @param index   当前的下标
 */
- (BOOL)photoBrowser:(XGYPhotoBrowser *)browser shouldTapPhotoAtIndex:(NSUInteger)index;

/**
 * 点击图片
 * @param browser 图片浏览器
 * @param index   当前的下标
 */
- (void)photoBrowser:(XGYPhotoBrowser *)browser didTapPhotoAtIndex:(NSUInteger)index;

/**
 * 是否允许长按图片
 * @param browser 图片浏览器
 * @param index   当前的下标
 */
- (BOOL)photoBrowser:(XGYPhotoBrowser *)browser shouldLongPressPhotoAtIndex:(NSUInteger)index;

/**
 * 长按图片
 * @param browser 图片浏览器
 * @param index    当前的下标
 */
- (void)photoBrowser:(XGYPhotoBrowser *)browser didLongPressPhotoAtIndex:(NSUInteger)index;



@end





#pragma mark - protocol
