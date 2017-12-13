//
//  UserInfoModel.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,assign)NSInteger isMember;
@property (nonatomic,assign)NSInteger isRecentLogin;//是否是最近登录用户 

@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *age;
@end

