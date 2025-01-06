//
//  XMAppLoving.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMAppLoving.h"
#import "XMALBannerAd.h"
#import "XMALRewardedAd.h"
#import "XMALInterstitialAd.h"

@interface XMAppLoving ()
//插页广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMALInterstitialAd *>* interstitials;
//激励广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMALRewardedAd *>* rewardedAds;
//横幅广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMALBannerAd *>* bannerViews;
@end

@implementation XMAppLoving
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (void)loadInsterstitialWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry{
    [self.interstitials setObject:[XMALInterstitialAd loadInsterstitialWithAdUnitID:unitID retryAttemp:retry] forKey:unitID];
}

- (void)loadRewardedAdWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry{
    [self.rewardedAds setObject:[XMALRewardedAd loadRewardedAdWithAdUnitID:unitID retryAttemp:retry] forKey:unitID];
}

- (void)addBannerAdWithAdUnitID:(NSString *)unitID rootView:(UIView *)rootView{
    [self.bannerViews setObject:[XMALBannerAd loadBannerAdWithAdUnitID:unitID rootView:rootView] forKey:unitID];
}

- (BOOL)canPresentInsterstitialWithAdUnitID:(NSString *)unitID{
    return [[self.interstitials objectForKey:unitID] canPresent];
}

- (BOOL)canPresentRewardedAdsWithAdUnitID:(NSString *)unitID{
    return [[self.rewardedAds objectForKey:unitID] canPresent];
}

- (void)presentInsterstitialWithAdUnitID:(NSString *)unitID{
    return [[self.interstitials objectForKey:unitID] present];
}

- (void)presentRewardedAdWithAdUnitID:(NSString *)unitID{
    return [[self.rewardedAds objectForKey:unitID] present];
}
@end
