//
//  XMAdmob.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface XMAdmob : NSObject
+ (instancetype)shareInstance;
- (void)loadInsterstitialWithAdUnitID:(NSString *)unitID;
- (void)loadRewardedAdWithAdUnitID:(NSString *)unitID;
- (void)addBannerAdWithAdUnitID:(NSString *)unitID viewWidth:(CGFloat)viewWidth rootView:(UIView *)rootView rootViewController:(UIViewController *)viewController;
- (BOOL)canPresentInsterstitialWithAdUnitID:(NSString *)unitID;
- (BOOL)canPresentRewardedAdsWithAdUnitID:(NSString *)unitID;
- (void)presentInsterstitialWithAdUnitID:(NSString *)unitID;
- (void)presentRewardedAdWithAdUnitID:(NSString *)unitID;
@end

NS_ASSUME_NONNULL_END
