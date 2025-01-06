#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XMAdmob.h"
#import "XMAdmobBannerAd.h"
#import "XMAdmobInterstitialAd.h"
#import "XMAdmobRewardedAd.h"
#import "XMALBannerAd.h"
#import "XMALInterstitialAd.h"
#import "XMALRewardedAd.h"
#import "XMAppLoving.h"
#import "TTDataListModel.h"
#import "TTHTTPAgent.h"
#import "TTNetworkRequest+Real.h"
#import "TTNetworkRequest.h"
#import "TTResponseSerializer.h"
#import "PCMDataPlayer.h"
#import "PCMFilePlayer.h"
#import "PCMRecorder.h"
#import "XMSTTManager.h"
#import "UserManager.h"
#import "UserModel.h"
#import "XMVideoPlayer.h"
#import "XMAppleIAP.h"
#import "XMAppleIAPModel.h"
#import "XMAppleIAP_Lost_Transaction_Helper.h"
#import "XMApplePay.h"
#import "XMSDKIOS.h"
#import "XMSDKIOSConfig.h"

FOUNDATION_EXPORT double XMSDK_iosVersionNumber;
FOUNDATION_EXPORT const unsigned char XMSDK_iosVersionString[];

