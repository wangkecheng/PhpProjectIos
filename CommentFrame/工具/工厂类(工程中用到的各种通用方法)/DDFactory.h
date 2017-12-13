//
//  DDFactory.h
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFactory : NSObject

@property (nonatomic,strong)NSMutableDictionary *observerData; //广播的数据

+(instancetype)factory;


//发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel;

//安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel;

//移除收音机
- (void) removeObserver:(id)observer;

//移除广播
- (void) removeChannel:(NSString *)channel;

//通过配置好的plist文件创建控制器，返回arr中每个元素是字典，字典中包含控制器
+(NSArray *)createClassByPlistName:(NSString *)plistName;

// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color;

//获取根视图
+(UIViewController *)appRootViewController;

//检查网络状态ß
+(void)checkNetWorkingState;

+ (NSDictionary *) reverseDict:(NSDictionary *)dict;//将字典中的字段全转为字符串

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;

//去除searhBarBack的背景色
+(void)removeSearhBarBack:(UISearchBar *)searchBar;

//快速获得图片url 这个是做个预防
+(NSURL *)getImgUrl:(NSString *)imgStr;

+ (NSString*)getCurrentDeviceModel;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(void)avoidClickTwice:(UIButton *)button;
+ (id)getVCById:(NSString *)Id;
/**
 通过Storyboard名及其ID获取控制器
 @param Id 控制器id
 @param name Storyboard名
 @return 控制器
 */
+ (id)getVCById:(NSString *)Id storyboardName:(NSString *)name;
//通过xib文件 初始化对象
+ (NSString *)getString:(NSString *)string withDefault:(NSString *)defaultString;
+ (BOOL)isEmptyWithString:(NSString *)string;
@end

