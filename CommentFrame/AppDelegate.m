//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AppDelegate.h"

#import "GuideVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    if (![GuideVC hadLoaded]) {
        GuideVC *VC = [GuideVC loadWithBlock:^(BOOL isFinish) {
            [CacheTool setRootVCByIsMainVC:YES];//主界面视图
        }]; 
        _window.rootViewController = VC;//第一次进入会走这里
    }else{
        [CacheTool setRootVCByIsMainVC:YES];//主界面视图
    }
    [IQKeyboardManager sharedManager];//键盘
    [self setShareSDK];//配置分享 和登陆
    [self updateVersion];//版本更新
    //推送
//    [self jPushAddAndOptions:launchOptions];
    return YES;
}
-(void)updateVersion{
    //版本更新
    AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
    checkManger.countryAbbreviation = @"cn";
    [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"下次提示" confimTitle:@"前往更新" skipVersionTitle:@"跳过当前版本"];
}

-(void)setShareSDK{
    [ShareSDK registerApp:@"1b7f350b60f88"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
                 case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1279590306"
                                           appSecret:@"e3ad746b91d01848d72a6bb8e12fd21c"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxf9d4c382b24845f9"
                                       appSecret:@"848c9d394f2cdb5bdf0742725f119e3b"];
                 break;
                 case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105990742"
                                      appKey:@"C3URuCgiMjQdOvvC"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - 极光推送开始
- (void) jPushAddAndOptions:(NSDictionary *)launchOptions{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    //参数参考pushConfig
    [JPUSHService setupWithOption:launchOptions appKey:@"35c8fb34cc400bf3705359fb"
                          channel:@"Publish channel"
                 apsForProduction:NO //配置环境的设置：是否生产环境
            advertisingIdentifier:nil];
    //     [JPUSHService setDebugMode];
    //推送
    if (launchOptions) {
        
        NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这里必须延迟发送， 否则通知会不成功

        });
        
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
    [self toMsgList:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    [self toMsgList:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
-(void)toMsgList:(NSDictionary *)userInfo{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ) { //应用在前台的时候
        
         }
    else{//应用不在前台的时候
     
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];//设置角标 极光推送会自动保存角标，在极光推送页面 将badge中的1改为 +1，但是进入前台和后台的时候需要发送一次角标值0 给极光服务器，告知角标置零
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService setBadge:0];
}
#pragma mark - 极光推送结束
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self handleItem:shortcutItem];
}
-(void)handleItem:(UIApplicationShortcutItem *)shortcutItem{
    
    //判断3DTouch点击的选项
    if ([shortcutItem.type isEqualToString:@"MySelf"]) {
        
    }
    if ([shortcutItem.type isEqualToString:@"MsgList"]) {
        
    }
    if ([shortcutItem.type isEqualToString:@"Publish"]){
       
    }
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
