//
//  MImaCell.h
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerDefine.h"
#import <AssetsLibrary/AssetsLibrary.h>
typedef BOOL(^MBoolBlock)(ALAsset *);

static NSString *MImaCellClassName = @"MImaCell";

@interface MImaCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imavHead;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark;

@property (nonatomic,strong)ALAsset *aLAssetModel;

@property(nonatomic,strong) UIImageView *BigImgView;

@property(nonatomic,copy)MBoolBlock selcetBlock;

-(void)setSelectImg:(BOOL)isSelect;

- (void)setBigImgViewWithImage:(UIImage *)img;
@end
