//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface HDMainNavC : UINavigationController

-(void)pushVC:(UIViewController *)VC;



-(void)pushVC:(UIViewController *)VC isHideBack:(BOOL)isHideBack animated:(BOOL)animated;
@end
