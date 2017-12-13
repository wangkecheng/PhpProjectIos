
//
//  RegisterVC.m
//  ChatDemo-UI3.0
//
//  Created by warron on 2017/8/3.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "RegisterVC.h"

typedef enum TagField{
    TagPassField,
    TagVerPassField,
    TagPhoneFiled,
    TagVerCodeField
}TagField;
@interface RegisterVC ()<UITextFieldDelegate>{
    NSArray *filedArr;
}
@property (weak, nonatomic) IBOutlet UIButton *btnXieyi;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *verCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *verPassField;

@property (weak, nonatomic) IBOutlet UITextField *inviteField;

@property (weak, nonatomic) IBOutlet UIButton *getVercodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic,assign)BOOL isShutDownCountTime;
@property (nonatomic,assign)BOOL isAgreeProtocol;
 
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;



@end

@implementation RegisterVC
- (IBAction)touchXieyi:(UIButton *)sender {
    [self goOrderWebWithURL:[NSString stringWithFormat:@"app/index.php?i=2&c=entry&m=ewei_shopv2&do=mobile&r=article&aid=15"]];
}
-(void)goOrderWebWithURL:(NSString *)str{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册";
    _phoneField.text = _phoneNumber;
    [self setBtnBgAndfontColor:_getVercodeBtn andBool:NO];
    if (_phoneNumber.length == 11) {
        [self setBtnBgAndfontColor:_getVercodeBtn andBool:YES];
    }
    _phoneField.tag = TagPhoneFiled;
    _phoneField.text = @"18408246301";
    
    _verPassField.tag = TagVerPassField;
    _verPassField.text = @"123456";
    
    _passField.tag = TagPassField;
    _passField.text = @"123456";
    
    _verCodeField .tag = TagVerCodeField;
    
    _phoneField.delegate = self;
    _passField.delegate = self;
    _verPassField.delegate = self;
    _verCodeField.delegate = self;
    
    filedArr=@[_phoneField,_verCodeField,_passField,_verPassField]; 
//    [self setBtnBgAndfontColor:_registerBtn andBool:NO];
    
    for (int i=0; i<filedArr.count; i++) {
        UITextField *textf=filedArr[i];
        if (i==0) {
            [textf addTarget:self action:@selector(phoneFieldChaneg:) forControlEvents:UIControlEventAllEditingEvents];
        }else{
            [textf addTarget:self action:@selector(fieldChaneg:) forControlEvents:UIControlEventAllEditingEvents];
        }
    }
   _btnXieyi.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
     
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignEditor)];
    [self.tableView addGestureRecognizer:tap];
}
-(void)resignEditor{
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)phoneFieldChaneg:(UITextField *)theText{
    if (![DDFactory isEmptyWithString:theText.text]) {
        if (theText.text.length==11) {
             [self setBtnBgAndfontColor:_getVercodeBtn andBool:YES];
        }else{
            [self setBtnBgAndfontColor:_getVercodeBtn andBool:NO];
        }
    }else{
        [self setBtnBgAndfontColor:_getVercodeBtn andBool:NO];
    }
    
    if ([self areyouOK] && _agreeBtn.selected==YES) {
        [self setBtnBgAndfontColor:_registerBtn andBool:YES];
    }else{
        [self setBtnBgAndfontColor:_registerBtn andBool:NO];
    }
}

-(void)fieldChaneg:(UITextField *)theText{
    if ([self areyouOK] && _agreeBtn.selected==YES) {
         [self setBtnBgAndfontColor:_registerBtn andBool:YES];
    }else{
        [self setBtnBgAndfontColor:_registerBtn andBool:NO];
    }
}

-(BOOL)areyouOK{
    for (UITextField *textf in filedArr) {
        if ([DDFactory isEmptyWithString:textf.text] || textf.text.length==0) {
            return NO;
        }
    }
    return YES;
}

-(void)setBtnBgAndfontColor:(UIButton *)btn andBool:(BOOL)theBool{
     btn.userInteractionEnabled = theBool;
    if (theBool==NO) {
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setBackgroundColor:UIColorFromRGB(251, 205, 32)];
    }
}

- (IBAction)getVercode:(UIButton *)sender {
     [DDFactory avoidClickTwice:sender];
     HDModel *m = [HDModel model];
}



- (IBAction)agreeProtocol:(UIButton *)sender {
    
    if (sender.selected) {//在选中状态的话， 表示此次点击进来 是不同意操作
        [sender setImage:IMG(@"ic_tongyi") forState:0];
    }else{//统一操作
        [sender setImage:IMG(@"ic_yitongyi") forState:0];
    }

    _isAgreeProtocol = !_isAgreeProtocol;
    sender.selected = !sender.selected;
    if ([self areyouOK] && _agreeBtn.selected==YES) {
        [self setBtnBgAndfontColor:_registerBtn andBool:YES];
    }else{
        [self setBtnBgAndfontColor:_registerBtn andBool:NO];
    }
    
    if (_agreeBtn.selected) {//查看服务协议
        HDWebVC *webVC = [[HDWebVC alloc]initWithURL:@"http://www.jianshu.com" progressColor:[UIColor orangeColor]];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (IBAction)registerBtnAction:(id)sender {
    [DDFactory avoidClickTwice:sender];
      weakObj;
     _registerBtn.userInteractionEnabled = NO;
    HDModel *m = [HDModel model];
    m.vertifyCode = weakSelf.verCodeField.text;
    m.userName = _phoneField.text;
    m.password = _passField.text;
    m.vertifyPass = _verPassField.text;
    [BaseServer postObjc:m path:@"register.php" isShowHud:YES isShowSuccessHud:YES success:^(id result){
        if (weakSelf.finishBlock) {
          weakSelf.finishBlock(weakSelf.phoneField.text);
        }
       [weakSelf.navigationController popViewControllerAnimated:YES];
        
       weakSelf.registerBtn.userInteractionEnabled = YES ;
  
    } failed:^(NSError *error) {
           weakSelf.registerBtn.userInteractionEnabled = YES;
    }];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = CountDownTime; //倒计时时间
    _isShutDownCountTime = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    weakObj;
    dispatch_source_set_event_handler(_timer, ^{
        
        if (weakSelf.isShutDownCountTime) {
            time = 0;
        }
        if(time <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [weakSelf.getVercodeBtn  setTitle:@"重新发送" forState:UIControlStateNormal];
                weakSelf.time.text = @"";
                weakSelf.getVercodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds;
            if (time == CountDownTime)
                seconds = CountDownTime;
            else
                seconds = time % CountDownTime;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [weakSelf.getVercodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                weakSelf.time.text = [NSString stringWithFormat:@"%.2d", seconds];
                weakSelf.getVercodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSInteger maxLength = 20;
    switch (textField.tag) {
        case TagVerPassField:
            maxLength = 20;
            break;
        case TagPassField:
            maxLength = 20;
            break;
        case TagPhoneFiled:
            maxLength = 11;
            break;
        case TagVerCodeField:
            maxLength = 6;
            break;
    }
    if (textField.text.length + string.length == maxLength) {
        if ( textField.tag == TagPhoneFiled) {
             [_getVercodeBtn setBackgroundColor:UIColorFromRGB(251, 205, 32)];
        }
    }
    if (textField.text.length + string.length > maxLength || [string isEqualToString:@" "]) {
        
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
