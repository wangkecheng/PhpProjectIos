      
//
//  DDFactory.m
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "DDFactory.h"
#import <sys/utsname.h>
#include<sys/types.h>
#import <sys/utsname.h>
#include<sys/sysctl.h>
@implementation DDFactory

+(instancetype)factory{
    
    static  DDFactory *factory  = nil;
    static dispatch_once_t once;
    if (!factory) {
        dispatch_once(&once, ^{
            factory = [[DDFactory alloc]initPrivate];
         
        });
    }
    return factory;
}


-(instancetype)init{
    //不允许用init方法
    @throw [NSException exceptionWithName:@"Singleton" reason:@"FirstVC is a Singleton, please Use shareView to create" userInfo:nil];
}

-(instancetype)initPrivate{
    //键盘随输入位置上下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification  object:nil];
    return  self = [super init];
}

+(NSArray *)createClassByPlistName:(NSString *)plistName{
    
    NSString *itemVCPath = [[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"];
    
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:itemVCPath];
    
    
    NSMutableArray * arrItemVC = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary  *dict, NSUInteger idx, BOOL *  stop) {
        //每一个视图有类名，标题， 将其放在字典中
        NSMutableDictionary * dictItem = [NSMutableDictionary dictionary];
        
        NSString *className = dict[ClassName];
        Class classControl = NSClassFromString(className);
        UIViewController *basePagerVC = [[classControl alloc]init];
        basePagerVC.title = dict[TitleVC];
        
        //将视图放在字典中
        [dictItem setObject:basePagerVC forKey:ClassName];
        
        //将标题放在字典中
        [dictItem setObject:dict[TitleVC] forKey:TitleVC];
        
        //将图片放在字典中
        if ([[dict allKeys]containsObject:Image]) {
            
            [dictItem setObject:dict[Image] forKey:Image];
            
        }
        //将图片放在字典中
        if ([[dict allKeys]containsObject:SelectImage]) {
            
            [dictItem setObject:dict[SelectImage] forKey:SelectImage];
            
        }
        //将附加信息放在字典中
        if ([[dict allKeys]containsObject:AttachInfo]) {
            
            [dictItem setObject:dict[AttachInfo] forKey:AttachInfo];
            
        }
        [arrItemVC addObject:dictItem];
    }];
    return  [arrItemVC copy];
}

#pragma mark - 发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel {
    
    if(_observerData == nil) {
        _observerData = [[NSMutableDictionary alloc]init];
    }
    
    if(data != nil) {
        [_observerData setObject: data forKey:channel];
    }
    else {
        [_observerData removeObjectForKey:channel];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:channel object:data];
}

#pragma mark - 安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:channel object:nil];
    if(_observerData != nil) {
        id data = [_observerData objectForKey:channel];
        if(data != nil) {
            NSNotification *notification = [[NSNotification alloc] initWithName:channel object:data userInfo:nil];
            [observer performSelector:aSelector withObject: notification];
        }
    }
}

#pragma mark - 移除收音机
- (void) removeObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - 移除接收频道
- (void)removeChannel:(NSString *)channel{
    if (_observerData!= nil)
        [_observerData removeObjectForKey:channel];
}

// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIViewController *)appRootViewController{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = appRootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+(void)checkNetWorkingState{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue       = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"有网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"无网络");
                break;
        }
    }];
    // 开始监听
    [manager.reachabilityManager startMonitoring];
}
+ (NSDictionary *) reverseDict:(NSDictionary *)dict {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [dic setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            [dic setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
            
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *eleDict = [self reverseDict:value];
            [dic setObject:eleDict  forKey:key];
        }
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray  *arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dictT in value) {
                [arr addObject:[self reverseDict:dictT]];
            }
            [dic setObject:arr forKey:key];
        }
    }
    return [dic copy];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    return imageData;
}

//去除searhBarBack的背景色
+(void)removeSearhBarBack:(UISearchBar *)searchBar{
    for (UIView *view in searchBar.subviews) {
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
            }
        }
        //7.0以前
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
    }
}

+(NSURL *)getImgUrl:(NSString *)imgStr{
    if ([imgStr isKindOfClass:[NSURL class]]) {
        NSURL *imgUrl = (NSURL *)imgStr;
        imgStr = imgUrl.absoluteString;
        if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
            return [NSURL URLWithString:[@"" stringByAppendingString:imgStr]];// 这里需要自己改 @""
        }
        return [NSURL URLWithString:imgStr];
    }
    if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
        return [NSURL URLWithString:[@""  stringByAppendingString:imgStr]];// 这里需要自己改 @""
    }
    
    return [NSURL URLWithString:imgStr] ;
}

+ (NSString*)getCurrentDeviceModel{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    //iPhone系列
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    //iPod系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 7G";
    
    //iPad系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad 5G";
    if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad 5G";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
    
}
//防止连续点击两次 简单处理
+(void)avoidClickTwice:(UIButton *)button{
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
}
+ (id)getVCById:(NSString *)Id{
    
    return [self getVCById:Id storyboardName:Id];
}
+ (id)getVCById:(NSString *)Id storyboardName:(NSString *)name {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:Id];
    return VC;
}

+ (NSString *)getString:(NSString *)string withDefault:(NSString *)defaultString{
    
    NSString * temStr;
    if (![string isKindOfClass:[NSString class]]) {
        temStr =  [DDFactory toString:string];
    }else{
        temStr = string;
    }
    if([DDFactory isEmptyWithString:temStr]
       ){
        //为空，返回默认数据
        return defaultString;
    }else{
        //不为空，直接返回数据
        return temStr;
    }
}
+ (NSString *)toString:(id)anyObject{
    return [NSString stringWithFormat:@"%@",anyObject];
}
/*
 *功能说明：
 *    判断字符串为空
 *参数说明：
 *string : 需要判断的字符串
 */
+ (BOOL)isEmptyWithString:(NSString *)string{
    NSString * temStr;
    if (![string isKindOfClass:[NSString class]]) {
        temStr =  [DDFactory toString:string];
    }else{
        temStr = string;
    }
    return ((temStr == nil)
            ||([temStr isEqual:[NSNull null]])
            ||([temStr isEqualToString:@"<null>"])
            ||([temStr isEqualToString:@"(null)"])
            ||([temStr isEqualToString:@" "])
            ||([temStr isEqualToString:@""])
            ||([temStr isEqualToString:@""])
            ||([temStr isEqualToString:@"(\n)"])
            ||([temStr isEqualToString:@"yanyu"])
            );
}
@end

