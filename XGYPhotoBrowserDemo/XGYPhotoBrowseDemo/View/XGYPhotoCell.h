//
//  XGYPhotoCell.h
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/12.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/UIImageView+YYWebImage.h>

@interface XGYPhotoCell : UICollectionViewCell

/**
 图片
 */
@property (nonatomic, strong) UIImageView *photo;


@property (nonatomic, strong) NSString *text;
@end

