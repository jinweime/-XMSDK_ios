//
//  XMALBannerAd.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMALBannerAd : NSObject
+ (instancetype)loadBannerAdWithAdUnitID:(NSString *)unitID rootView:(UIView *)rootView;
@end

NS_ASSUME_NONNULL_END
