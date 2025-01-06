//
//  XMSDKIOS.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMSDKIOSConfig.h"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import "XMAppleIAP.h"
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface XMSDKIOS : NSObject

+ (instancetype)sharedInstance;

- (void)startWithConfig:(XMSDKIOSConfig *)config;
- (XMSDKIOSConfig *)getConfig;

+ (NSString *)xm_getDeviceID;

- (void)startPurchaseWithID:(NSString *)purchID
                       type:(XMAppleIAPType)type
                    success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                    failure:(nonnull void (^)(NSInteger code, NSString *message))failure;

- (void)createUserWithEmail:(NSString *)email
                   password:(NSString *)password
                 completion:(nullable FIRAuthDataResultCallback)completion;
- (FIRAuthStateDidChangeListenerHandle)addAuthStateDidChangeListener:(FIRAuthStateDidChangeListenerBlock)listener;
- (void)removeAuthStateDidChangeListener:(FIRAuthStateDidChangeListenerHandle)handle;

- (void)playWithData:(NSData *)data;

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
