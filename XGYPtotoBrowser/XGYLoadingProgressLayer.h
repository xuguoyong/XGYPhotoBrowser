//
//  XGYProgressLayer.h
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 30/12/2016.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGYLoadingProgressLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;
- (void)xgy_startAnimation;
- (void)xgy_stopAnimation;
+ (void)showMessage:(NSString *)message;
@end

