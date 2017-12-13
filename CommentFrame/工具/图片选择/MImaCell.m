//
//  MImaCell.m
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "MImaCell.h"

@implementation MImaCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

-(void)setALAssetModel:(ALAsset *)aLAssetModel{
    _aLAssetModel = aLAssetModel;
    _imavHead.image = [UIImage imageWithCGImage:aLAssetModel.thumbnail];
}
- (IBAction)actionBtn:(UIButton *)sender {
    
    if (sender.selected) {
        [self setSelectImg:NO];
    }else{
        [self setSelectImg:YES];
    }
    if (_selcetBlock) {//这个选择block不为空才走 防空
        if ( _selcetBlock(_aLAssetModel)) {//将这个传过去， 控制器判断已选择数组中有的话， 就移除， 返回YES，表示需要设置为NO
            [self setSelectImg:NO];
        }
    }
}
-(void)setSelectImg:(BOOL)isSelect{
    _btnCheckMark.selected = isSelect;
    if (isSelect) {
         [_btnCheckMark setImage:IMG(@"ico_check_select.png") forState:0];
        return;
    }
        [_btnCheckMark setImage:IMG(@"ico_check_nomal") forState:0];
}
- (void)setBigImgViewWithImage:(UIImage *)img{
    if (_BigImgView) {
        return;
    }
    _BigImgView = [[UIImageView alloc]initWithImage:img];
    _BigImgView.frame = _imavHead.frame;
    [self bringSubviewToFront:_BigImgView];
    _BigImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissImgView)];
    [_BigImgView addGestureRecognizer:tap];
}

-(void)dissmissImgView{
    [_BigImgView removeFromSuperview];
     _BigImgView = nil;
}
@end
