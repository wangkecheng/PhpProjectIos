//
//  YYKJMainTVC.m
//  DieKnight
//
//  Created by WangZhen on 2017/1/17.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import "HDMainTBC.h"
#import "HDMainNavC.h"
@interface HDMainTBC ()

@end

@implementation HDMainTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarBackColor];
    
    [self addTabBarItems];
}

// 设置TabBar背景颜色
-(void)setTabBarBackColor{
    UIView *view = [[UIView alloc]init];
    view.frame = self.tabBar.bounds;
    view.backgroundColor = UIColorFromHX(0x222222);
    [self.tabBar insertSubview:view atIndex:0];
    self.tabBar.opaque = YES;
    // 设置tabbar渲染颜色
    [UITabBar appearance].tintColor = UIColorFromHX(0xf78707);
    self.tabBar.translucent = NO;
}
//添加TabBar控制器的所有子控制器
-(void)addTabBarItems{
   //这里的使用方法 是 创建tabBar的选项的时候，比如有五个tabBarItem 先将tabBarItem 对应的ViewController创建出来(不是NavigationController),然后按照Item的属性分别将信息填入 TabarVCS.plist中，对应关系如下
     // title         控制器标题
     // className     tabBarItem对应的Viewcontroller的类名
     // selectImage   tabBarItem 选中的图片
     // image         tabBarItem 正常的图片
     //要修改tabbar的话就 修改 TabarVCS.plist中的信息
        for (NSDictionary *dict in [DDFactory createClassByPlistName:@"TabarVCS"]) {
        UIViewController *VC = dict[ClassName];
        HDMainNavC *navc = [[HDMainNavC alloc]initWithRootViewController:VC];
        navc.tabBarItem.image = IMG(dict[Image]);
        navc.tabBarItem.selectedImage =IMG( dict[SelectImage]);
        navc.tabBarItem.title = dict[TitleVC];
        [self addChildViewController:navc];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSMutableArray * tabbarArr = [NSMutableArray array];
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    for (UIView *subview in tabBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarArr addObject:subview];
        }
    }
    UIView * tabbarBtn = tabbarArr[index];
    for (UIView * imgV in tabbarBtn.subviews) {
        if ([imgV isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pulse.duration = 0.2;
            pulse.repeatCount= 1;
            pulse.autoreverses= YES;
            pulse.fromValue= [NSNumber numberWithFloat:0.7];
            pulse.toValue= [NSNumber numberWithFloat:1.3];
            [imgV.layer addAnimation:pulse forKey:nil];
        }
    } 
}
//是否可以旋转 这个在 HDMainNavC 中也需要设置
- (BOOL)shouldAutorotate{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;//是平板就支持
    }
    return NO;
}
//支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;//是平板就支持 所有，iphone支持竖屏
    }
    return UIInterfaceOrientationMaskPortrait;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
