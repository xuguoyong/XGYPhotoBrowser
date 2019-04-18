//
//  XGYNavigationController.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYNavigationController.h"
#import "XGYTool.h"

@interface XGYNavigationController ()

@end

@implementation XGYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [XGYTool xgy_colorWithHexString:@"#C7000B"];
    self.navigationBar.tintColor = [XGYTool xgy_colorWithHexString:@"#C7000B"];
    // 设置navBar选中时字体颜色添加到主题色池中
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [self.navigationBar setTitleTextAttributes:textAttrs];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
