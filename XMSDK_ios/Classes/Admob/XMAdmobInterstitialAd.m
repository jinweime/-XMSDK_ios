//
//  XMInterstitialAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMAdmobInterstitialAd.h"

@interface XMAdmobInterstitialAd ()<GADFullScreenContentDelegate>
//插页广告
@property(nonatomic, strong) GADInterstitialAd *interstitial;
@end

@implementation XMAdmobInterstitialAd
//@"ca-app-pub-3940256099942544/4411468910"
+ (instancetype)loadInsterstitialWithAdUnitID:(NSString *)unitID{
    XMAdmobInterstitialAd *a = [XMAdmobInterstitialAd new];
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:unitID
        request:request
        completionHandler:^(GADInterstitialAd *ad, NSError *error) {
      if (error) {
        NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
        return;
      }
      a.interstitial = ad;
      a.interstitial.fullScreenContentDelegate = a;
    }];
    return a;
}

- (BOOL)canPresent{
    if (self.interstitial) {
      // The UIViewController parameter is nullable.
        NSError *error = nil;
        BOOL res = [self.interstitial canPresentFromRootViewController:nil error:&error];
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
    if (self.interstitial) {
      // The UIViewController parameter is nullable.
      [self.interstitial presentFromRootViewController:nil];
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
