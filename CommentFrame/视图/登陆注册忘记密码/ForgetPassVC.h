//
//  ForgetPassVC.h
//  ChatDemo-UI3.0
//
//  Created by warron on 2017/8/3.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"

@interface ForgetPassVC : HDBaseTableVC

@property(nonatomic,strong)NSString *phoneNumber;
@property (nonatomic,copy) void(^finishBlock)(NSString *phoneNumber);
@end
