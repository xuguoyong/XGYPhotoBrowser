//
//  XGYPhotoCell.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/12.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYPhotoCell.h"
#import <Masonry.h>
@implementation XGYPhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.photo = [[UIImageView alloc] init];
    self.photo.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photo];
    self.photo.clipsToBounds = YES;
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
