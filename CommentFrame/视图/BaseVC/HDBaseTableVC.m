//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseTableVC.h"

@interface HDBaseTableVC ()

@end

@implementation HDBaseTableVC//静态tableview继承这个

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;//TableView的顶部有一部分空白区域 去除
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
