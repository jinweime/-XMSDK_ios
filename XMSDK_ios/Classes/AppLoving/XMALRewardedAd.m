//
//  XMALRewardedAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMALRewardedAd.h"

@interface XMALRewardedAd ()<MARewardedAdDelegate>
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@property (nonatomic, assign) NSInteger retryAttempt;
@end

@implementation XMALRewardedAd

+ (instancetype)loadRewardedAdWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry {
    XMALRewardedAd *rew = [XMALRewardedAd new];
    rew.retryAttempt = retry;
    rew.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:unitID];
    rew.rewardedAd.delegate = rew;
    // Load the first ad
    [rew.rewardedAd loadAd];
    return rew;
}

- (BOOL)canPresent {
    if (self.rewardedAd) {
      // The UIViewController parameter is nullable.
        return [self.rewardedAd isReady];
    } else {
        NSLog(@"Ad is nil");
        return NO;
    }
}

- (void)present{
    if (self.rewardedAd) {
        // The UIViewController parameter is nullable.
        if ([self.rewardedAd isReady]){
          [self.rewardedAd showAd];
        }else{
          NSLog(@"Ad wasn't ready");
        }
    } else {
        NSLog(@"Ad is nil");
    }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
  // Rewarded ad is ready to show. '[self.rewardedAd isReady]' now returns 'YES'

  // Reset retry attempt
  self.retryAttempt = 0;
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
  // Rewarded ad failed to load
  // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)

  self.retryAttempt++;
  NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self.rewardedAd loadAd];
  });
}

- (void)didDisplayAd:(MAAd *)ad {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad
{
  // Rewarded ad is hidden. Pre-load the next ad
  [self.rewardedAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
  // Rewarded ad failed to display. AppLovin recommends that you load the next ad.
  [self.rewardedAd loadAd];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
  // Rewarded ad was displayed and user should receive the reward
    NSLog(@"Rewarded user: %ld %@", reward.amount, reward.label);

}
@end
