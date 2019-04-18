//
//  XGYTool.h
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XGYTool : NSObject
/**
 16进制颜值色转color
 */
+ (UIColor *)xgy_colorWithHexString:(NSString *)color;
@end
