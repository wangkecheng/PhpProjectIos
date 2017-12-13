//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//
#import "HDMainNavC.h"

@interface HDMainNavC ()

@end

@implementation HDMainNavC// 所有类的navicontroller都是这个

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置NavigationBar背景颜色
    [self.navigationBar setBackgroundImage:[DDFactory imageWithColor: UIColorFromRGB(251, 205, 32)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    self.navigationBar.opaque = NO;
    self.navigationBar.translucent = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
}

/*VC:弹出的视图 isHideBack:是否隐藏返回按钮， 如果需要自定义左边按钮，那么就用
 1.  HDMainNavC * navi = self.navigationController;（self.navigationController是HDMainNavC才能这样子写）
 2. [navi pushVC:vc isHideBack:YES animated:yes];
 3.  然后 vc 中    [self addLeftBarButtonWithImage:img action:@selector(add)]; 具体使用 UIViewController+BarButton中看
 */
-(void)pushViewController:(UIViewController *)VC animated:(BOOL)animated{
    [self pushVC:VC isHideBack:NO animated:animated];
}

-(void)pushVC:(UIViewController *)VC{
    [self pushVC:VC isHideBack:NO animated:YES];
}

-(void)pushVC:(UIViewController *)VC isHideBack:(BOOL)isHideBack animated:(BOOL)animated{
    
    if (!VC) {
        return;//为空的时候不弹出
    }
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器并且未苍苍
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 0, 44, 44);
        [firstButton setImage:[UIImage imageNamed:@"return"] forState:0];//ios11添加leftBarButtonItem时，图片的像素大小会影响最终的返回位置
        [firstButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREENWIDTH/375.0, 0, 0)];
        if (isHideBack) {//如果需要隐藏返回按钮
            [firstButton setHidden:YES];
        }
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
        VC.navigationItem.leftBarButtonItem = leftBarButtonItem;
        VC.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    // 一旦调用super的pushViewController方法,就会创建子控制器viewController的view并调用viewController的viewDidLoad方法。可以在viewDidLoad方法中重新设置自己想要的左上角按钮样式
    [super pushViewController:VC animated:YES];
}

-(void)leftBtnAction{
    
    [self popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
@end
