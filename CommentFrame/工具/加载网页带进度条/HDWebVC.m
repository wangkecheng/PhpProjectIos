//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "HDWebVC.h"
#import "TGWebProgressLayer.h"
#import <WebKit/WebKit.h>

@interface HDWebVC ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *tgWebView;

@property (nonatomic, strong)TGWebProgressLayer *webProgressLayer;

/** 相关链接*/
@property (nonatomic, copy) NSString *url;

/** 标题 */
@property (nonatomic, copy) NSString *webTitle;

/** 进度条颜色 */
@property (nonatomic, assign) UIColor *progressColor;

@end

@implementation HDWebVC
- (instancetype)initWithURL:(NSString *)url progressColor :(UIColor *)progressColor{
    self = [super init];
    if (self) {
        _url = url;
        _progressColor = progressColor;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpUI];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"return"] action:@selector(leftBtnAction)];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setUpUI {
    
    self.tgWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.tgWebView.navigationDelegate =self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.tgWebView loadRequest:request];
    [self.view addSubview:self.tgWebView];
    
    self.webProgressLayer = [[TGWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, 42, WIDTH, 2);
    self.webProgressLayer.strokeColor = self.progressColor.CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
}

- (void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
    [self.webProgressLayer removeFromSuperlayer];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_startLoad];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_finishedLoadWithError:nil];
     self.title = webView.title;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer tg_finishedLoadWithError:error];
}
-(void)leftBtnAction{
    if ([_tgWebView canGoBack] ) {
        [_tgWebView goBack];
        return;//如果可以返回的话 就返回
    }
    //不能返回了
    [self.webProgressLayer tg_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
