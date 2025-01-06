//
//  TTNetworkRequest+First.h
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/9.
//  Copyright © 2017年 kankan. All rights reserved.
// 

#import "TTNetworkRequest.h"
#import "TTDataListModel.h"
#import "XMAppleIAPModel.h"
#import "UserModel.h"

@interface TTNetworkRequest (Real)
#pragma mark- 用户中心
/** 用户登录*/
+ (void)userLoginWithUniqueId:(NSString *_Nonnull)uniqueId handler:(nullable void (^)(UserModel * _Nullable userModel, NSInteger code, NSString * _Nullable message))handler;
//下单
+ (void)applePayWithUid:(NSString *_Nonnull)uid
              productId:(NSString *_Nonnull)productId
                         type:(XMAppleIAPType)type
                   purchaseToken:(NSString *_Nonnull)purchaseToken
                   success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(NSInteger code, NSString * _Nullable message))failure;
@end
