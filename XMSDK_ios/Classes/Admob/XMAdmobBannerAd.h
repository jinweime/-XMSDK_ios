//
//  XMBannerAd.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface XMAdmobBannerAd : NSObject
+ (instancetype)loadBannerAdWithAdUnitID:(NSString *)unitID viewWidth:(CGFloat)viewWidth rootView:(UIView *)rootView rootViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
