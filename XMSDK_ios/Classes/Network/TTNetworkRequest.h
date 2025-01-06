//
//  TTNetworkRequest.h
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/9.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkErrorCode -1
#define kNetworkErrorMsg  @"无法连接到网络，请稍后再试"
#define kServerErrorMsg  @"服务器出现问题，请稍后再试"

static NSInteger const  kReturnCodeError = -100; //返回数据code有错误

typedef void(^TTRequestFailure)(NSInteger code, NSString *message);

@class TTHTTPRequest;

@interface TTNetworkRequest : NSObject

@end
