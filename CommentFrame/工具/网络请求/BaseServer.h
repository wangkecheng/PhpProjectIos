//
//  BaseServer.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/7.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HDModel.h"
typedef void (^progressBlock)(NSProgress *progress);
typedef void (^successBlock)(id result);
typedef void (^failedBlock)(NSError *error);
@interface BaseServer : NSObject

+(instancetype)baseServer;
/**
 图片上传基础方法

 @param image 图片数组
 @param imgName 图片名数组（与图片数组对应）
 @param path 路径
 @param paramDict 参数
 @param progress 上传进度回调
 @param success 成功回调
 @param failed 失败回调
 
 */
- (void)uploadImages:(NSArray *)imageArr path:(NSString *)path param:(id )obj  isShowHud:(BOOL)isShowHud success:(successBlock)success failed:(failedBlock)failed;
/**
 音频上传基础方法
 
 @param image  音频
 @param imgName  音频名数组
 @param path 路径
 @param paramDict 参数
 @param progress 上传进度回调
 @param success 成功回调
 @param failed 失败回调
 
 */
+ (void)uploadAudio:(NSData *)audioData names:(NSString *)audioName path:(NSString *)path fileName:(NSString *)fileName param:(NSDictionary *)param progress:(progressBlock)progress success:(successBlock)success failed:(failedBlock)failed;



/**
 基础请求方法
 
 @param param 参数
 @param path 路径
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)postObjc:(id)objc path:(NSString *)path  isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud success:(successBlock)success failed:(failedBlock)failed;
//当遇到字段是系统保留字段(请求数据的对象属性 不能是系统保留字段) 就用这个方法
+ (void)postDict:(NSDictionary *)dict path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud isShowFieldHud:(BOOL)isShowFieldHud success:(successBlock)success failed:(failedBlock)failed;
@end
