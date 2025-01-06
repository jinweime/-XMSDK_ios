//
//  XMSDKIOSConfig.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
//

#import "XMSDKIOSConfig.h"

@implementation XMSDKIOSConfig
+ (instancetype)configWithBaseUrl:(NSString *)baseUrl
                        loginPath:(NSString *)loginPath
                     buyGoodsPath:(NSString *)buyGoodsPath
                       buyVipPath:(NSString *)buyVipPath{
    XMSDKIOSConfig *c = [self new];
    c.baseApiUrl = baseUrl;
    c.loginPath = loginPath;
    c.buyGoodsPath = buyGoodsPath;
    c.buyVipPath = buyVipPath;
    return c;
}

- (NSString *)getLoginUrl{
    return [_baseApiUrl stringByAppendingPathComponent:_loginPath];
}

- (NSString *)getBuyGoodsUrl{
    return [_baseApiUrl stringByAppendingPathComponent:_buyGoodsPath];
}

- (NSString *)getBuyVipUrl{
    return [_baseApiUrl stringByAppendingPathComponent:_buyVipPath];
}
@end
