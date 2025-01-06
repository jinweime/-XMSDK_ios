//
//  XMALBannerAd.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import "XMALBannerAd.h"

@interface XMALBannerAd ()<MAAdViewAdDelegate>
//横幅广告
@property(nonatomic, strong) MAAdView *bannerView;
@end

@implementation XMALBannerAd

+ (instancetype)loadBannerAdWithAdUnitID:(NSString *)unitID rootView:(UIView *)rootView{
    // Here the current interface orientation is used. If the ad is being preloaded
    // for a future orientation change or different orientation, the function for the
    // relevant orientation should be used.
    XMALBannerAd *bannerAd = [XMALBannerAd new];
    bannerAd.bannerView = [[MAAdView alloc] initWithAdUnitIdentifier: unitID];
    bannerAd.bannerView.delegate = bannerAd;
    // Set background or background color for banners to be fully functional
    bannerAd.bannerView.backgroundColor = [UIColor blackColor];
    //
    [bannerAd addBannerViewToView:rootView];
    // Load the ad
    [bannerAd.bannerView loadAd];
    
    return bannerAd;
}

- (void)addBannerViewToView:(UIView *)rootView {
  self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [rootView addSubview:self.bannerView];
  // Banner height on iPhone and iPad is 50 and 90, respectively
  CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;
  // Stretch to the width of the screen for banners to be fully functional
  [self.bannerView addConstraints:@[
    [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:height]
                              ]];
  [rootView addConstraints:@[
    [NSLayoutConstraint constraintWithItem:self.bannerView
                                 attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                                  toItem:rootView.safeAreaLayoutGuide
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:self.bannerView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                                  toItem:rootView.safeAreaLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                                constant:0]
                                ]];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - Deprecated Callbacks

- (void)didDisplayAd:(nonnull MAAd *)ad { 
    
}

- (void)didHideAd:(nonnull MAAd *)ad { 
    
}


#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}
@end
