//
//  XMAdmob.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMAdmob.h"
#import "XMAdmobInterstitialAd.h"
#import "XMAdmobBannerAd.h"
#import "XMAdmobRewardedAd.h"
#import "XMAdmobInterstitialAd.h"

@interface XMAdmob ()
//插页广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMAdmobInterstitialAd *>* interstitials;
//激励广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMAdmobRewardedAd *>* rewardedAds;
//横幅广告
@property(nonatomic, strong) NSMutableDictionary<NSString*, XMAdmobBannerAd *>* bannerViews;
@end

@implementation XMAdmob

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.interstitials = [@{} mutableCopy];
        self.rewardedAds = [@{} mutableCopy];
        self.bannerViews = [@{} mutableCopy];
    }
    return self;
}

//@"ca-app-pub-3940256099942544/4411468910"
- (void)loadInsterstitialWithAdUnitID:(NSString *)unitID {
    [self.interstitials setObject:[XMAdmobInterstitialAd loadInsterstitialWithAdUnitID:unitID] forKey:unitID];
}

//@"ca-app-pub-3940256099942544/1712485313"
- (void)loadRewardedAdWithAdUnitID:(NSString *)unitID {
    [self.rewardedAds setObject:[XMAdmobRewardedAd loadRewardedAdWithAdUnitID:unitID] forKey:unitID];
}

//@"ca-app-pub-3940256099942544/2435281174"
- (void)addBannerAdWithAdUnitID:(NSString *)unitID viewWidth:(CGFloat)viewWidth rootView:(UIView *)rootView rootViewController:(UIViewController *)viewController {
    [self.bannerViews setObject:[XMAdmobBannerAd loadBannerAdWithAdUnitID:unitID viewWidth:viewWidth rootView:rootView rootViewController:viewController] forKey:unitID];
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
