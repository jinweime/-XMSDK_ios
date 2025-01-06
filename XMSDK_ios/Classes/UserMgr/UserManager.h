//
//  UserManager.h
//  TTKanKan
//
//  Created by 夏和奇 on 2017/7/13.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserManager : NSObject

+ (instancetype)shareManager;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - login
- (void)requestUserModelWithHandler:(void (^)(UserModel *userModel, NSInteger code, NSString *message))handler;
@end


///--------------------
/// @name Notifications
///--------------------
// 登录完成通知（包括用户名密码登录\session登录；包括成功、失败）
FOUNDATION_EXPORT NSString * const UserRequestDidCompleteCodeKey;
FOUNDATION_EXPORT NSString * const UserRequestDidCompleteMessageKey;
FOUNDATION_EXPORT NSString * const UserLoginDidCompleteNotification;
