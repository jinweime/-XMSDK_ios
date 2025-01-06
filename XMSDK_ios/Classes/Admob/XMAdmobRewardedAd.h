//
//  XMRewardedAd.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/5.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface XMAdmobRewardedAd : NSObject
+ (instancetype)loadRewardedAdWithAdUnitID:(NSString *)unitID;
- (BOOL)canPresent;
- (void)present;
@end

NS_ASSUME_NONNULL_END
