//
//  XMBannerAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMAdmobBannerAd.h"

@interface XMAdmobBannerAd ()<GADBannerViewDelegate>
//横幅广告
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation XMAdmobBannerAd
//@"ca-app-pub-3940256099942544/2435281174"
+ (instancetype)loadBannerAdWithAdUnitID:(NSString *)unitID viewWidth:(CGFloat)viewWidth rootView:(UIView *)rootView rootViewController:(UIViewController *)viewController{
    // Here the current interface orientation is used. If the ad is being preloaded
    // for a future orientation change or different orientation, the function for the
    // relevant orientation should be used.
    XMAdmobBannerAd *bannerAd = [XMAdmobBannerAd new];
    GADAdSize adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    // In this case, we instantiate the banner with desired ad size.
    bannerAd.bannerView = [[GADBannerView alloc] initWithAdSize:adaptiveSize];
    bannerAd.bannerView.delegate = bannerAd;
    [bannerAd addBannerViewToView:rootView];
    
    bannerAd.bannerView.adUnitID = unitID;
    bannerAd.bannerView.rootViewController = viewController;
    [bannerAd.bannerView loadRequest:[GADRequest request]];
    
    return bannerAd;
}

- (void)addBannerViewToView:(UIView *)rootView {
  self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [rootView addSubview:self.bannerView];
  // This example doesn't give width or height constraints, as the provided
  // ad size gives the banner an intrinsic content size to size the view.
  [rootView addConstraints:@[
    [NSLayoutConstraint constraintWithItem:self.bannerView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                                  toItem:rootView.safeAreaLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:self.bannerView
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                                    toItem:rootView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                                constant:0]
                                ]];
}

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
}
@end
