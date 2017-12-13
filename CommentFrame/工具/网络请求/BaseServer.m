//
//  BaseServer.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/7.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.

#import "BaseServer.h"
#import "LWActiveIncator.h"
#import "WSProgressView.h"
@interface BaseServer()
@property(nonatomic, strong) WSProgressView *progressView;
@end

@implementation BaseServer
+(instancetype)baseServer{
    return [[BaseServer alloc]init];
}
//一般的请求数据只能传对象
+ (void)postObjc:(id)objc path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud success:(successBlock)success failed:(failedBlock)failed{
    
    NSDictionary *dict  = [objc yy_modelToJSONObject];
    [self postDict:dict path:path isShowHud:isShowHud isShowSuccessHud:isShowSuccessHud isShowFieldHud:YES  success:success failed:failed];
  
}

//当遇到字段是系统保留字段(请求数据的对象属性 不能是系统保留字段) 就用这个方法
+ (void)postDict:(NSDictionary *)dict path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud isShowFieldHud:(BOOL)isShowFieldHud success:(successBlock)success failed:(failedBlock)failed{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/javascript",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:10.0]; // 10秒超时

    if (isShowHud){
        [LWActiveIncator showInView:CurrentAppDelegate.window]; 
    }
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    weakObj;
    [manager POST:fullPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
           responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
           responseObject = [DDFactory dictionaryWithJsonString:responseObject];
           responseObject = [DDFactory reverseDict:responseObject];
        }
      
        [LWActiveIncator hideInViwe:CurrentAppDelegate.window];
         if ([responseObject[@"code"] integerValue] == 200) {
            if (isShowSuccessHud)
                [CurrentAppDelegate.window  makeToast:responseObject[@"msg"]];
            NSDictionary *dict = [DDFactory reverseDict:responseObject];
            SAFE_BLOCK_CALL(success, dict);
            return;
        }
        else {//失败
            NSError *error = [NSError errorWithDomain:@"出错了"
                                                 code:01
                                             userInfo:responseObject];
            [weakSelf showFieldMsg:[error userInfo][@"msg"] isShowFieldHud:isShowFieldHud];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LWActiveIncator hideInViwe:CurrentAppDelegate.window];
        [weakSelf showFieldMsg:[error userInfo][NSLocalizedDescriptionKey] isShowFieldHud:isShowFieldHud];
        SAFE_BLOCK_CALL(failed, error);
    }];
}
+(void)showFieldMsg:(NSString *)msg isShowFieldHud:(BOOL)isShowFieldHud{
    
    if (isShowFieldHud && msg.length >0)//默认的isShowNotFieldHud是NO, 传YES表示不显示
       [CurrentAppDelegate.window  makeToast:msg];
}

- (void)uploadImages:(NSArray *)imageArr path:(NSString *)path param:(id )obj  isShowHud:(BOOL)isShowHud success:(successBlock)success failed:(failedBlock)failed{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/javascript",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:10.0]; // 10秒超时
//    NSString *token = TOKEN;
//    if (token.length!=0) {//登陆的时候是没有TOKEN的
////        [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"token"];
//    }
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    NSDictionary *paramDict  =  [obj yy_modelToJSONObject];//将HDModel对象转为字典
    
    _progressView = [WSProgressView progressByProColor:[UIColor orangeColor] frame:CGRectMake(0, 64, SCREENWIDTH, 1.5)];
   [CurrentAppDelegate.window addSubview:_progressView];
     
    [manager POST:fullPath parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        for (NSInteger i = 0; i<imageArr.count; i++) {
             UIImage * image = imageArr[i];
            if ([image isKindOfClass:[UIImage class]]) {
                NSData *imageData =  [DDFactory resetSizeOfImageData:image maxSize:500000];
                NSString * name = [NSString stringWithFormat:@"uploadimageFile%ld",i];
                [formData appendPartWithFileData:imageData name:name fileName:@"imgfileStyle" mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (isShowHud) {
            dispatch_async(dispatch_get_main_queue(), ^{
             [_progressView setProgress:uploadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressView setProgress:1 animated:YES];
            [_progressView removeFromSuperview];
        });
        SAFE_BLOCK_CALL(success, responseObject);    //结果处理
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { 
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressView removeFromSuperview];
        });
        NSString *msg = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];       [CurrentAppDelegate.window makeToast:msg];
        SAFE_BLOCK_CALL(failed, error);
    }];
}
+ (void)uploadAudio:(NSData *)audioData names:(NSString *)audioName path:(NSString *)path fileName:(NSString *)fileName   param:(NSDictionary *)param progress:(progressBlock)progress success:(successBlock)success failed:(failedBlock)failed{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:240]; // 10秒超时
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    
    weakObj;
    [CurrentAppDelegate.window makeToast:@"数据上传中..."  duration:0.8 ];
    [manager POST:fullPath parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        [formData appendPartWithFileData:audioData name:audioName fileName:fileName mimeType:@""];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //结果处理
        SAFE_BLOCK_CALL(success, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SAFE_BLOCK_CALL(failed, error);
    }];
}



+(void)relogin{
    
}
@end
