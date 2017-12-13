//  LoginVC.m
//  ProjectFirst
//  Created by warron on 2017/11/6.
//  Copyright © 2017年 APICloud. All rights reserved.

#import "LoginVC.h"
#import "ForgetPassVC.h"
#import "RegisterVC.h"
@interface LoginVC (){
    NSString *type;
}

@property (weak, nonatomic) IBOutlet UITextField *fieldAccount;
@property (weak, nonatomic) IBOutlet UITextField *fieldPass;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fieldPass.secureTextEntry=YES;
    self.view.backgroundColor = UIColorFromRGB(242, 242, 242);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignEditor)];
    [self.view addGestureRecognizer:tap];

}
-(void)resignEditor{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)showPass:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = YES;
        [_fieldPass setSecureTextEntry:NO];
        [sender setImage:[UIImage imageNamed:@"b_ic_yanjingb-"] forState:0];
    }
    else{
        sender.selected = NO;
        [_fieldPass setSecureTextEntry:YES];
        [sender setImage:[UIImage imageNamed:@"b_ic_yanjing-"] forState:0];
    }
}

- (IBAction)forgetPassVC:(UIButton *)sender {
   
    [DDFactory avoidClickTwice:sender];
    weakObj;
    ForgetPassVC *VC = [DDFactory getVCById:@"ForgetPassVC" ];
    VC.phoneNumber = [DDFactory getString:_fieldAccount.text withDefault:@""];//将当前的账户传到下级
    VC.finishBlock = ^(NSString *phoneNumber) {
        weakSelf.fieldAccount.text = phoneNumber;//将当前的下级账户传到 当前界面
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [DDFactory avoidClickTwice:sender];
    HDModel *m = [HDModel model];
    m.userName= self.fieldAccount.text;
    m.password= self.fieldPass.text;
    weakObj;
    
    [BaseServer postObjc:m path:@"login.php" isShowHud:NO isShowSuccessHud:YES success:^(id result) {
        
        UserInfoModel *model = [CacheTool getUserModelByID:result[@"data"][@"keyid"]];
        [model yy_modelSetWithJSON:result[@"data"]];
        model.isMember = 1;
        model.isRecentLogin = 0;//这里必须为零，因为登录后，isMember标志是1,isMember退出后标志0  isRecentLogin正好相反
        model.mobile = weakSelf.fieldAccount.text;
        [UserInfoModel gy_updateTable];
        [CacheTool writeToDB:model];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];//从nextVC界面回去

    } failed:^(NSError *error) {
        
    }];
}

- (IBAction)registerVC:(UIButton *)sender {
    [DDFactory avoidClickTwice:sender];
    weakObj;
    RegisterVC *VC = [DDFactory getVCById:@"RegisterVC" ];
    VC.phoneNumber = [DDFactory getString:_fieldAccount.text withDefault:@""];//将当前的账户传到下级
    VC.finishBlock = ^(NSString *phoneNumber) {
        weakSelf.fieldAccount.text = phoneNumber;//将当前的下级账户传到 当前界面
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)qqLogin:(UIButton *)sender {
    [DDFactory avoidClickTwice:sender];
    type=@"qq";
    [self loginByPlatform:SSDKPlatformTypeQQ];
}

- (IBAction)wxLogin:(UIButton *)sender {
    [DDFactory avoidClickTwice:sender];
     type=@"wx";
     [self loginByPlatform:SSDKPlatformTypeWechat];
    
}

-(void)loginByPlatform:(SSDKPlatformType)platform{
    __weak typeof  (self) weakSelf = self;
    [SSEThirdPartyLoginHelper loginByPlatform:platform onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       associateHandler (user.uid, user, user);
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                   }onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    if (state == SSDKResponseStateSuccess){
                                        [weakSelf ohterLogin:user.linkId];
                                    }
                                }];
}
-(void)ohterLogin:(NSString *)openId{
//    weakObj;
    HDModel *m = [HDModel model];
   
    [BaseServer postObjc:m path:@"app/index.php?i=2&c=entry&m=ewei_shopv2&do=mobile&r=wabapp.sns" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ISLOGIN"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",result[@"data"][@"token"]] forKey:@"TOKEN"];//储存token
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",result[@"data"][@"key_id"]] forKey:@"UID"];
        
        [CacheTool setRootVCByIsMainVC:YES];
        
        UserInfoModel *model = [CacheTool getUserModelByID:result[@"data"][@"key_id"]];
        [model yy_modelSetWithJSON:result[@"data"]];
        model.isRecentLogin = 1;
        [UserInfoModel gy_updateTable];
        [CacheTool writeToDB:model];
        
        [self dismissViewControllerAnimated:YES completion:nil];//从nextVC界面回去
        
    } failed:^(NSError *error) {
        
    }];
    
}
- (IBAction)serviceVC:(UIButton *)sender {
    [DDFactory avoidClickTwice:sender];
    
    HDWebVC *webVC = [[HDWebVC alloc]initWithURL:@"http://www.jianshu.com" progressColor:[UIColor orangeColor]];
    [self.navigationController pushViewController:webVC animated:YES]; 
}
-(void)goOrderWebWithURL:(NSString *)str{
 
 
    
//    [self.navigationController pushViewController:windowContainer animated:NO];
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
