//
//  XMALRewardedAd.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMALRewardedAd : NSObject
+ (instancetype)loadRewardedAdWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry;
- (BOOL)canPresent;
- (void)present;
@end

NS_ASSUME_NONNULL_END
