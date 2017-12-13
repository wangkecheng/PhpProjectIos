//
//  HDApplyModel.h
//  DieKnight
//
//  Created by warron on 2017/2/22.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求一般的数据 都用这个类来初始化请求数据
@interface HDModel : NSObject
+(HDModel *)model;
 
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *password;

@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *vertifyCode;
@property (nonatomic,strong)NSString *vertifyPass;
@property (nonatomic,strong)NSString *keyId;
@property (nonatomic,strong)NSString *imageName;
@end
