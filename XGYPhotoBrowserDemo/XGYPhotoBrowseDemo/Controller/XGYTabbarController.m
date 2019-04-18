//
//  XGYTabbarController.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYTabbarController.h"
#import "XGYNavigationController.h"
#import "XGYNormalController.h"
#import "XGYAnimationController.h"
#import "XGYTool.h"

@interface XGYTabbarController ()

@end

@implementation XGYTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 普通的照片查看
    XGYNormalController *normal = [[XGYNormalController alloc] init];
    [self addOneChlildVc:normal title:@"普通的照片" imageName:@"btn-xiaoxi-n" selectedImageName:@"btn-xiaoxi-h"];
    
    
    //带动画的视频查看
    XGYAnimationController *animation = [[XGYAnimationController alloc] init];
     [self addOneChlildVc:animation title:@"带动画的照片" imageName:@"turkey_tags_1_n" selectedImageName:@"turkey_tags_1_h"];
    
    
    
    
}



/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =  [XGYTool xgy_colorWithHexString:@"#c4c4c4"];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem  setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    childVc.tabBarItem.title = title;
    
    // 设置正常状态图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];


    
    //设置标题
    childVc.title = title;
    
    // 添加为tabbar控制器的子控制器
    XGYNavigationController *nav = [[XGYNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
