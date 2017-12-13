//
//  HUD.h
//  MCASS
//
//  Created by 唐万龙 on 2016/9/13.
//  Copyright © 2016年 longerone.cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUD : NSObject


/**
 显示正在处理，转菊花
 
 @param message 提示信息
 */
+ (void)showProgress:(NSString *)message;


/**
 显示上传进度
 */
+ (void)showUpload:(NSProgress *)progress;

/**
 显示文本提示
 
 @param message 提示内容
 @param delay   显示时间
 */
+ (void)showMessage:(NSString *)message delay:(float)delay;


/**
 显示完成提示
 
 @param message 提示内容
 @param delay   显示时间
 */
+ (void)showFinishMessage:(NSString *)message delay:(float)delay;


/**
 显示错误提示
 
 @param message 错误内容
 @param delay   显示时间
 */
+ (void)showErrorMessage:(NSString *)message delay:(float)delay;


/**
 显示错误信息提示

 @param error error对象
 */
+ (void)showWithError:(NSError *)error;


/**
 去除显示
 */
+ (void)dismissHUD;



/**
 显示进度及提示信息

 @param progress NSProgress
 @param msg 提示信息
 */
+ (void)showProgress:(CGFloat)progress message:(NSString *)msg;

@end
