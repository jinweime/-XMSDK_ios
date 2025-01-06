//
//  XMALInterstitialAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMALInterstitialAd.h"

@interface XMALInterstitialAd ()<MAAdDelegate>
@property (nonatomic, strong) MAInterstitialAd *interstitialAd;
@property (nonatomic, assign) NSInteger retryAttempt;
@end

@implementation XMALInterstitialAd
+ (instancetype)loadInsterstitialWithAdUnitID:(NSString *)unitID retryAttemp:(NSInteger)retry{
    XMALInterstitialAd *a = [XMALInterstitialAd new];
    a.retryAttempt = retry;
    a.interstitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:unitID];
    a.interstitialAd.delegate = a;
    // Load the first ad
    [a.interstitialAd loadAd];
    return a;
}

- (BOOL)canPresent {
    if (self.interstitialAd) {
      // The UIViewController parameter is nullable.
        return [self.interstitialAd isReady];
    } else {
        NSLog(@"Ad is nil");
        return NO;
    }
}

- (void)present{
    if (self.interstitialAd) {
        // The UIViewController parameter is nullable.
        if ([self.interstitialAd isReady]){
          [self.interstitialAd showAd];
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
  // Interstitial ad is ready to be shown. '[self.interstitialAd isReady]' will now return 'YES'

  // Reset retry attempt
  self.retryAttempt = 0;
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
  // Interstitial ad failed to load
  // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)

  self.retryAttempt++;
  NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self.interstitialAd loadAd];
  });
}

- (void)didDisplayAd:(MAAd *)ad {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad
{
  // Interstitial ad is hidden. Pre-load the next ad
  [self.interstitialAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
  // Interstitial ad failed to display. AppLovin recommends that you load the next ad.
  [self.interstitialAd loadAd];
}
@end
