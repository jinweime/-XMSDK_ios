//
//  TTNetworkRequest+First.m
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/9.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTNetworkRequest+Real.h"
#import "TTHTTPAgent.h"
#import <YYModel.h>
#import <NSObject+YYModel.h>
#import "UserModel.h"
#import "UserManager.h"
#import "XMSDKIOS.h"

@implementation TTNetworkRequest (Real)
#pragma mark- 用户中心
+ (void)userLoginWithUniqueId:(NSString *)uniqueId handler:(void (^)(UserModel *userModel, NSInteger code, NSString *message))handler{
    NSMutableDictionary *param = [@{} mutableCopy];
    [param setValue:uniqueId forKey:@"gaid"];
    [param setValue:[[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey] forKey:@"pkName"];
    TTHTTPRequest *request = [TTHTTPRequest defaultRequestWithURL:[XMSDKIOS sharedInstance].getConfig.getLoginUrl parameters:param];
    request.method = TTHTTPRequestMethodPOST;
    [[TTHTTPAgent sharedClient] requestByCustomRequest:request success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"success"]) {
            UserModel *user = [UserModel yy_modelWithDictionary:responseObject];
            if (handler) {
                if (handler) handler(user, 0, @"");
            }
        }
        else {
            if (handler) handler(nil, kNetworkErrorCode, kNetworkErrorMsg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler) handler(nil, kNetworkErrorCode, kNetworkErrorMsg);
    }];
}

+ (void)applePayWithUid:(NSString *_Nonnull)uid
              productId:(NSString *_Nonnull)productId
                         type:(XMAppleIAPType)type
                   purchaseToken:(NSString *_Nonnull)purchaseToken
                   success:(nullable void (^)(id responseObject))success
                  failure:(nullable void (^)(NSInteger code, NSString * _Nullable message))failure{
    NSMutableDictionary *param = [@{} mutableCopy];
    [param setValue:uid forKey:@"uid"];
    [param setValue:[[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey] forKey:@"packageName"];
    [param setValue:purchaseToken forKey:@"token"];
    [param setValue:productId forKey:@"productId"];
    [param setValue:productId forKey:@"subscriptionId"];

    TTHTTPRequest *request = [TTHTTPRequest defaultRequestWithURL:type == CMAppleIAPTypeOneTime?[XMSDKIOS sharedInstance].getConfig.getBuyGoodsUrl:[XMSDKIOS sharedInstance].getConfig.getBuyVipUrl parameters:param];
    request.method = TTHTTPRequestMethodPOST;
    [[TTHTTPAgent sharedClient] requestByCustomRequest:request success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) success(responseObject);
        }
        else {
            if (failure) failure(kNetworkErrorCode, kNetworkErrorMsg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure(kNetworkErrorCode, kNetworkErrorMsg);
    }];
}

@end
