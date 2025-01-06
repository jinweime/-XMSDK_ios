//
//  XMSDKIOSConfig.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMSDKIOSConfig : NSObject
@property(nonatomic, strong)NSString *baseApiUrl;
@property(nonatomic, strong)NSString *loginPath;
@property(nonatomic, strong)NSString *buyGoodsPath;
@property(nonatomic, strong)NSString *buyVipPath;

+ (instancetype)configWithBaseUrl:(NSString *)baseUrl
                        loginPath:(NSString *)loginPath
                     buyGoodsPath:(NSString *)buyGoodsPath
                       buyVipPath:(NSString *)buyVipPath;

- (NSString *)getLoginUrl;
- (NSString *)getBuyGoodsUrl;
- (NSString *)getBuyVipUrl;
@end

NS_ASSUME_NONNULL_END
