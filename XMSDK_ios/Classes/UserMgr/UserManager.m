//
//  UserManager.m
//  TTKanKan
//
//  Created by 夏和奇 on 2017/7/13.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "UserManager.h"
#import "TTNetworkRequest+Real.h"
#import "MFSIdentifier.h"
#import "NSString+YYAdd.h"
#import "XMSDKIOS.h"

NSString * const UserRequestDidCompleteCodeKey = @"xm.sdk.user.request.complete.code";
NSString * const UserRequestDidCompleteMessageKey = @"xm.sdk.user.request.complete.message";
NSString * const UserLoginDidCompleteNotification = @"xm.sdk.user.login.complete";

@interface UserManager ()
@property (nonatomic, strong) UserModel *userModel;
@end

@implementation UserManager

+ (instancetype)shareManager
{
    static UserManager *userMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userMgr = [[UserManager alloc] init];
    });
    
    return userMgr;
}

#pragma mark -
- (void)requestUserModelWithHandler:(void (^)(UserModel *userModel, NSInteger code, NSString *message))handler
{
    if (self.userModel) {
        if (handler) {
            handler(self.userModel, 0, @"");
        }
        return;
    }
    [TTNetworkRequest userLoginWithUniqueId:[XMSDKIOS xm_getDeviceID] handler:^(UserModel *userModel, NSInteger code, NSString *message) {
        if (code == 0) {
            self.userModel = userModel;
        }
        if (handler) {
            handler(userModel, code, message);
        }
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[UserRequestDidCompleteCodeKey] = @(code);
        userInfo[UserRequestDidCompleteMessageKey] = message;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginDidCompleteNotification
                                                            object:self.userModel userInfo:userInfo];
    }];
}

@end
