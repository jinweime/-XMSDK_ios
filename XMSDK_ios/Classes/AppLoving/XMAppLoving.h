//
//  XMAppLoving.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMAppLoving : NSObject
+ (instancetype)shareInstance;
- (void)loadInsterstitialWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry;
- (void)loadRewardedAdWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry;
- (void)addBannerAdWithAdUnitID:(NSString *)unitID rootView:(UIView *)rootView;
- (BOOL)canPresentInsterstitialWithAdUnitID:(NSString *)unitID;
- (BOOL)canPresentRewardedAdsWithAdUnitID:(NSString *)unitID;
- (void)presentInsterstitialWithAdUnitID:(NSString *)unitID;
- (void)presentRewardedAdWithAdUnitID:(NSString *)unitID;
@end

NS_ASSUME_NONNULL_END
