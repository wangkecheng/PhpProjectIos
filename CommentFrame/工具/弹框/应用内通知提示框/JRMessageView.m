//
//  JRMessageView.m
//  JRMessage-Demo
//
//  Created by wxiao on 15/12/28.
//  Copyright © 2015年 wxiao. All rights reserved.
//

#import "JRMessageView.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)
#define MESSAGE_H 60

typedef void(^TapBlock)();
@interface JRMessageView ()

@property (nonatomic, strong) UILabel		*titleLabel;
@property (nonatomic, strong) UILabel		*subTitleLabel;
@property (nonatomic, strong) UIButton		*iconView;
@property (nonatomic, assign) CGFloat		messageHeight;
@property (nonatomic, assign) CGFloat		iconWidth;

@property (nonatomic, strong) NSTimer		*timer;
@property (nonatomic, assign) NSTimeInterval timerInt;

@property (nonatomic, assign) CGFloat		messageOriginY;

@property (nonatomic, assign) CGPoint		startLoaction;
@property (nonatomic, assign) CGPoint		nowLoaction;
@property (nonatomic, assign) CGPoint		endLoaction;

@property (nonatomic, assign) CGFloat		messageMaxY;
@property (nonatomic, assign) CGFloat		messageSimY;
@property (nonatomic, assign) CGFloat		proPoint;
@property (nonatomic, copy)TapBlock tapBlock;
@end

@implementation JRMessageView

- (instancetype)init {
    if (self = [super init]) {
        _messageLeft	= 15;
        _messageTop		= 15;
        _messageBottom	= 10;
        _messageRight	= 10;
        _iconWidth		= 30;
        _messageHMargin = 10;
        _messageVMargin = 2;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                     iconName:(NSString *)icon
                  messageType:(JRMessageViewType)type
              messagePosition:(JRMessagePosition)position
                      superVC:(UIViewController *)superVC
                     duration:(CGFloat)duration tapBlock:(void(^)())tapBlock{
    _tapBlock = tapBlock;
    _title			= title;
    _subTitle		= title;
    _icon			= icon;
    _viewController = superVC;
    _duration		= duration;
    _type			= type;
    _messagePosition = position;
    
    if (self = [self init]) {
        
        if (self.title.length != 0) {
            
            _titleLabel			= [[UILabel alloc] init];
            _titleLabel.text	= title;
            _titleLabel.font	= [UIFont systemFontOfSize:14];
            [ _titleLabel sizeToFit];
            CGRect frame			=  _titleLabel.frame;
            frame.size.width		= SCREEN_W - (_iconWidth +  _messageRight +  _messageHMargin * 2);
            frame.origin.x			=  _messageRight +  _iconWidth +  _messageHMargin;
            frame.origin.y			=  _messageTop;
            _titleLabel.frame	= frame;
            _titleLabel.textColor = [UIColor whiteColor];
            [self addSubview: _titleLabel];
        }
        
        if (self.subTitle.length != 0) {
            
            CGRect frame				= CGRectMake( _messageRight + _iconWidth + _messageHMargin, CGRectGetMaxY(_titleLabel.frame) + _messageVMargin, _titleLabel.frame.size.width, 40);
            _subTitleLabel			= [[UILabel alloc] init];
            _subTitleLabel.font		= [UIFont systemFontOfSize:12];
            _subTitleLabel.numberOfLines = 0;
            _subTitleLabel.text		= subTitle;
            _subTitleLabel.frame	= frame;
            _subTitleLabel.textColor = [UIColor whiteColor];
            [_subTitleLabel sizeToFit];
            [self addSubview:_subTitleLabel];
            
            _messageHeight = CGRectGetMaxY(_subTitleLabel.frame) + 10;
        }
        
        if (_icon.length != 0) {
            CGRect frame = CGRectMake(_messageLeft, _messageTop, _iconWidth, _iconWidth);
            _iconView = [[UIButton alloc] initWithFrame:frame];
            if (_messageHeight < (CGRectGetMaxY(_iconView.frame) + _messageBottom)) {
                _messageHeight = (CGRectGetMaxY(_iconView.frame) + _messageBottom);
            }
            [_iconView addTarget:self action:@selector(didClicked) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_iconView];
        }
        
        NSString *imgName;
        if (_type == JRMessageViewTypeSuccess) {
            
            imgName = @"icon-success";
        } else if (_type == JRMessageViewTypeError) {
            imgName = @"icon-error";
        } else if (_type == JRMessageViewTypeWarning || _type == JRMessageViewTypeMessage) {
            imgName = @"icon-info";
        } else if (_type == JRMessageViewTypeCustom && _icon.length != 0) {
            imgName =  _icon;
        }
        self.backgroundColor = UIColorFromRGBA(51, 51, 51, 0.9);
        
        [self.viewController.view addSubview:self];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        //		self.hidden = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                     iconName:(NSString *)icon
                  messageType:(JRMessageViewType)type
              messagePosition:(JRMessagePosition)position
                     duration:(CGFloat)duration  tapBlock:(void(^)())tapBlock{
    _tapBlock = tapBlock;
    _title			= title;
    _subTitle		= title;
    _icon			= icon;
    _duration		= duration;
    _type			= type;
    _messagePosition = position;
    
    if (self = [self init]) {
        
        if (self.title.length != 0) {
            
            _titleLabel			= [[UILabel alloc] init];
            _titleLabel.text	= title;
            _titleLabel.font	= [UIFont systemFontOfSize:14];
            [_titleLabel sizeToFit];
            CGRect frame			= _titleLabel.frame;
            frame.size.width		= SCREEN_W - (_iconWidth + _messageRight +_messageHMargin * 2);
            frame.origin.x			= _messageRight +_iconWidth + _messageHMargin;
            frame.origin.y			= _messageTop;
            _titleLabel.frame	= frame;
            _titleLabel.textColor = [UIColor whiteColor];
            [self addSubview:_titleLabel];
        }
        
        if (_subTitle.length != 0) {
            
            CGRect frame				= CGRectMake(_messageRight + _iconWidth + _messageHMargin, CGRectGetMaxY(_titleLabel.frame) + _messageVMargin, _titleLabel.frame.size.width, 40);
            _subTitleLabel			= [[UILabel alloc] init];
            _subTitleLabel.font		= [UIFont systemFontOfSize:12];
            _subTitleLabel.numberOfLines = 0;
            _subTitleLabel.text		= subTitle;
            _subTitleLabel.frame	= frame;
            _subTitleLabel.textColor = [UIColor whiteColor];
            [_subTitleLabel sizeToFit];
            [self addSubview:_subTitleLabel];
            
            _messageHeight = CGRectGetMaxY(_subTitleLabel.frame) + 10;
        }
        
        CGRect frame = CGRectMake(_messageLeft, _messageTop, _iconWidth,_iconWidth);
        _iconView = [[UIButton alloc] initWithFrame:frame];
        if (_messageHeight < (CGRectGetMaxY(_iconView.frame) + _messageBottom)) {
            _messageHeight = (CGRectGetMaxY(_iconView.frame) + _messageBottom);
        }
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = CGRectGetHeight(_iconView.frame)/2.0;
        [_iconView addTarget:self action:@selector(didClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconView];
        
        NSString *imgName;
        if (_type == JRMessageViewTypeSuccess) {
            
            imgName = @"icon-success";
        } else if (_type == JRMessageViewTypeError) {
            imgName = @"icon-error";
        } else if (_type == JRMessageViewTypeWarning || _type == JRMessageViewTypeMessage) {
            imgName = @"icon-info";
        } else if (_type == JRMessageViewTypeCustom && _icon.length != 0) {
            imgName =  _icon;
        }
        self.backgroundColor = UIColorFromRGBA(51, 51, 51, 0.9);
      
      [_iconView sd_setImageWithURL:IMGURL(icon) forState:0 placeholderImage:IMG(@"pic_quanzi_fujingderent")];
        
        [CurrentAppDelegate.window addSubview:self];
        // 添加滑动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

// 屏幕方向监听
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    [self layoutIfNeeded];
}

// 刷新布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_messagePosition != JRMessagePositionBottom) {
        self.frame = CGRectMake(0, -_messageHeight, SCREEN_W, _messageHeight);
    } else {
        self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, _messageHeight);
    }
    CGPoint center = _iconView.center;
    center.y = _messageHeight * 0.5;
    _iconView.center = center;
 
    if (_messagePosition == JRMessagePositionTop) {
        _messageOriginY = NavigationBarH;
        _messageSimY = -_messageHeight;
        _messageMaxY = NavigationBarH;
    } else if(_messagePosition == JRMessagePositionNavBarOverlay) {
        _messageOriginY = 0;
        _messageSimY = -_messageHeight;
        _messageMaxY = 0;
    } else if(_messagePosition == JRMessagePositionBottom) {
        if (_viewController.tabBarController) {
            _messageOriginY = [UIScreen mainScreen].bounds.size.height - 49 - _messageHeight;
            _messageSimY	= [UIScreen mainScreen].bounds.size.height - 49 - _messageHeight;
            _messageMaxY	= [UIScreen mainScreen].bounds.size.height;
        } else {
            _messageOriginY = [UIScreen mainScreen].bounds.size.height - _messageHeight;
            _messageSimY	= [UIScreen mainScreen].bounds.size.height - _messageHeight;
            _messageMaxY	= [UIScreen mainScreen].bounds.size.height;
        }
    }
}

- (void)didClicked {
    [self hidedMessageView];
}

#pragma mark - Show/Hided Methond
- (void)showMessageView {
    
    _startLoaction	= CGPointZero;
    _endLoaction	= CGPointZero;
    _nowLoaction	= CGPointZero;
    _proPoint		= 0.0;
    weakObj;
    if (_isShow == NO) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calc) userInfo:nil repeats:YES];
        _timerInt = 0;
        [_timer fire];
        //		self.hidden = NO; 
        [UIView animateWithDuration:0.6
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                            weakSelf .isShow	= YES;
                             CGRect frame	= weakSelf .frame;
                             frame.origin.y = weakSelf .messageOriginY;
                             weakSelf .frame		= frame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)showMessageViewAuto {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calc) userInfo:nil repeats:YES];
    _timerInt = 0;
    [_timer fire];
    //		self.hidden = NO;
    weakObj;
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         weakSelf .isShow	= YES;
                         CGRect frame	= weakSelf .frame;
                         frame.origin.y = weakSelf .messageOriginY;
                         weakSelf .frame		= frame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hidedMessageView {
    
    if (_isShow) {
        
        [_timer invalidate];
        _timer = nil;
        _timerInt = 0;
        weakObj;
        [UIView animateWithDuration:0.8
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                             weakSelf .isShow	= NO;
                             CGRect frame	= weakSelf .frame;
                             
                             if (weakSelf .messagePosition != JRMessagePositionBottom) {
                                 frame.origin.y = -weakSelf .messageHeight;
                             } else {
                                 frame.origin.y = SCREEN_H + weakSelf .messageHeight;
                             }
                             weakSelf .frame		= frame;
                         } completion:^(BOOL finished) {
                             //							 self.hidden = YES;
                         }];
    }
}

- (void)hidedMessageViewAuto {
    
    if (_isShow && _timerInt >= 4) {
        [_timer invalidate];
        _timer = nil;
        _timerInt = 0;
        weakObj;
        [UIView animateWithDuration:0.8
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                             weakSelf .isShow	= NO;
                             CGRect frame	= weakSelf .frame;
                             if (weakSelf .messagePosition != JRMessagePositionBottom) {
                                 frame.origin.y = -weakSelf .messageHeight;
                             } else {
                                 frame.origin.y = SCREEN_H + weakSelf .messageHeight;
                             }
                             weakSelf .frame		= frame;
                         } completion:^(BOOL finished) {
                             [weakSelf removeFromSuperview];//从父视图中移除
                         }];
    }
}

- (void)calc {
    _timerInt += 1;
    [self hidedMessageViewAuto];
}

#pragma mark - Did Some Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)tapAction:(id)sender {
    
    if (_tapBlock) {
        _tapBlock();//返回到调用处
    }
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startLoaction = [recognizer locationInView:_viewController.view];
        _proPoint = _startLoaction.y;
        [_timer invalidate];
        _timer = nil;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        _nowLoaction = [recognizer locationInView:_viewController.view];
        
        _proPoint = _nowLoaction.y - _proPoint;
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y +_proPoint;
        
        if (frame.origin.y < _messageMaxY && frame.origin.y > _messageSimY) {
            self.frame = frame;
        }
        _proPoint = _nowLoaction.y;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        _endLoaction = [recognizer locationInView:_viewController.view];
        CGFloat longPan = _endLoaction.y - _startLoaction.y;
        if (longPan < 0) {
            longPan = -longPan;
        }
        if (longPan >=_messageHeight * 0.35) {
            [self hidedMessageView];
        } else {
            [self showMessageViewAuto];
        }
    }
}

#pragma mark - Message View Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
}

@end
