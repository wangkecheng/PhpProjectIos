//
//  MShowGroupAllSet.h
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JJPhotoManeger.h"

@interface MShowGroupAllSet : HDBaseVC<JJPhotoDelegate>
- (id)initWithGroup:(ALAssetsGroup *)group selectedArr:(NSMutableArray *)arrSelected maxCount:(NSInteger)maxCount selectBlock:(void(^)(NSMutableArray *))selectBlock;

@property (nonatomic, strong) NSMutableArray *arrSelected;

@property(nonatomic,strong) NSMutableArray *imgViewArray;
@end
