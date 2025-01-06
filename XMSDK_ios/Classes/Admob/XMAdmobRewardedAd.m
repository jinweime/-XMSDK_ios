//
//  XMRewardedAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMAdmobRewardedAd.h"

@interface XMAdmobRewardedAd ()<GADFullScreenContentDelegate>
//激励广告
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@end

@implementation XMAdmobRewardedAd
//@"ca-app-pub-3940256099942544/1712485313"
+ (instancetype)loadRewardedAdWithAdUnitID:(NSString *)unitID {
  XMAdmobRewardedAd *rew = [XMAdmobRewardedAd new];
  GADRequest *request = [GADRequest request];
  [GADRewardedAd
   loadWithAdUnitID:unitID
                request:request
      completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
          return;
        }
      rew.rewardedAd = ad;
        NSLog(@"Rewarded ad loaded.");
      rew.rewardedAd.fullScreenContentDelegate = rew;
      }];
    return rew;
}

- (BOOL)canPresent {
    if (self.rewardedAd) {
      // The UIViewController parameter is nullable.
        NSError *error = nil;
        BOOL res = [self.rewardedAd canPresentFromRootViewController:nil error:&error];
        if (error) {
          NSLog(@"Failed to can present interstitial ad with error: %@", [error localizedDescription]);
        }
        return res;
    } else {
        NSLog(@"Ad is nil");
        return NO;
    }
}

- (void)present{
    if (self.rewardedAd) {
        // The UIViewController parameter is nullable.
        [self.rewardedAd presentFromRootViewController:nil
                                      userDidEarnRewardHandler:^{
                                      GADAdReward *reward =
                                          self.rewardedAd.adReward;
                                      // TODO: Reward the user!
                                    }];
    } else {
      NSLog(@"Ad wasn't ready");
    }
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad will present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"Ad did dismiss full screen content.");
}
@end
