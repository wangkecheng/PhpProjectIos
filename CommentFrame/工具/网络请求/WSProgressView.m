//
//  WSProgressView.m
//  CommentFrame
//
//  Created by warron on 2017/12/12.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "WSProgressView.h"

@implementation WSProgressView

+(instancetype)progressByProColor:(UIColor *)progressColor frame:(CGRect) frame{
    WSProgressView *progress = [[WSProgressView alloc]init];
    progress.frame = frame;
    [progress setProgress:0 animated:YES]; //设置初始值，可以看到动画效果
    progress.transform =  CGAffineTransformMakeScale(1.0f, 1.5f);//改变进度条的高度
    progress.backgroundColor= [UIColor clearColor];//设置背景色
    progress.progressViewStyle = UIProgressViewStyleDefault;//进度条风格 就两种
    progress.progressTintColor=  progressColor;//设置已过进度部分的颜色
    progress.trackTintColor= [UIColor clearColor];//设置未过进度部分的颜
    return progress;
}
 
@end
