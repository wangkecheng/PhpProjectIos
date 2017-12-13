//
//  CacheTool.h
//  HelloDingDang
//
//  Created by warron on 2016/11/12.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface CacheTool : NSObject
+(void)writeToDB:(UserInfoModel *)model;
+(NSArray *)getAllUser;
+(UserInfoModel *)getRecentLoginUser;
+(void)setAllUserNotRecentLoginUser;//设置所有用户都不是最近登录的,统一设置
+(UserInfoModel *)getUserModel;
+(UserInfoModel *)getUserModelByID:(NSString *)ID;

//设置根视图
+ (UIViewController *)setRootVCByIsMainVC:(BOOL)isMainVC;
+(void)showLoginVC:(UIViewController *)theVC;//注销操作
@end
