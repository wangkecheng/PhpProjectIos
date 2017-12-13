//
//  HUD.m
//  MCASS
//
//  Created by 唐万龙 on 2016/9/13.
//  Copyright © 2016年 longerone.cc. All rights reserved.
//

#import "HUD.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
@implementation HUD

+ (void)showProgress:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = message;
    });
}

+ (void)showUpload:(NSProgress *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.progress = progress.fractionCompleted;
        HUD.labelText = @"正在上传...";
    });
}

+ (void)showMessage:(NSString *)message delay:(float)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = message;
        [HUD hide:YES afterDelay:1];
    });
}

+ (void)showFinishMessage:(NSString *)message delay:(float)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        UIImage *doneImage = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        HUD.customView = [[UIImageView alloc] initWithImage:doneImage];
        HUD.labelText = message;
        [HUD hide:YES afterDelay:delay];
    });
}

+ (void)showErrorMessage:(NSString *)message delay:(float)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        UIImage *doneImage = [[UIImage imageNamed:@"uncheckmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        HUD.customView = [[UIImageView alloc] initWithImage:doneImage];
        HUD.labelText = message;
        [HUD hide:YES afterDelay:delay];
    });
}


+ (void)showWithError:(NSError *)error {
    NSString *msg = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];
    [self showErrorMessage:msg delay:1.2];
}


+ (void)dismissHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        [HUD hide:YES];
    });
}


+ (void)showProgress:(CGFloat)progress message:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [self getMBProgressHUD];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.progress = progress;
        HUD.labelText = msg;
    });

}


+ (MBProgressHUD *)getMBProgressHUD {
    UIView *topView = CurrentAppDelegate.window.rootViewController.view;
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:topView];
    
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:topView animated:YES];
    }
    
    return HUD;
}

@end
