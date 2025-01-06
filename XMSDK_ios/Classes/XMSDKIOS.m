//
//  XMSDKIOS.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
//

#import "XMSDKIOS.h"
#import "MFSIdentifier.h"
#import "UserManager.h"
#import "SJRotationManager.h"
#import "PCMDataPlayer.h"
#import <AppLovinSDK/AppLovinSDK.h>

static NSString * _Nonnull const XMDEVICEKEY            = @"XMDEVICEKEY";

@interface XMSDKIOS()<UIApplicationDelegate>
@property(nonatomic, strong)XMSDKIOSConfig *config;
@end

@implementation XMSDKIOS

+ (instancetype)sharedInstance
{
    static XMSDKIOS* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)startWithConfig:(XMSDKIOSConfig *)config{
    _config = config;
    [self beginMonitorgNotification];
}

- (XMSDKIOSConfig *)getConfig{
    return _config;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [XMSDKIOS xm_getDeviceID];
    [FIRApp configure];
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    // Create the initialization configuration
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey: @"«SDK-key»" builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {

      builder.mediationProvider = ALMediationProviderMAX;

      // Perform any additional configuration/setting changes
    }];
    // Initialize the SDK with the configuration
   [[ALSdk shared] initializeWithConfiguration: initConfig completionHandler:^(ALSdkConfiguration *sdkConfig) {
    // Start loading ads
   }];
    return YES;
}

#pragma mark - Device id

+ (NSString *)xm_deviceId {
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:XMDEVICEKEY];
    if (deviceID.length != 0) {
        return deviceID;
    }
    deviceID = [MFSIdentifier deviceID];
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:XMDEVICEKEY];
    return deviceID;
}

+ (NSString *)xm_getDeviceID {
    return [self xm_deviceId];
}

#pragma mark - in-app Purchase

- (void)startPurchaseWithID:(NSString *)purchID
                       type:(XMAppleIAPType)type
                    success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                    failure:(nonnull void (^)(NSInteger code, NSString *message))failure{
    [[XMAppleIAP sharedInstance]startPurchaseWithID:purchID type:type success:sucess failure:failure];
}

#pragma mark - FIRAuth

- (void)createUserWithEmail:(NSString *)email
                   password:(NSString *)password
                 completion:(nullable FIRAuthDataResultCallback)completion {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:completion];
}

- (FIRAuthStateDidChangeListenerHandle)addAuthStateDidChangeListener:(FIRAuthStateDidChangeListenerBlock)listener {
    return [[FIRAuth auth]addAuthStateDidChangeListener:listener];
}

- (void)removeAuthStateDidChangeListener:(FIRAuthStateDidChangeListenerHandle)handle{
    [[FIRAuth auth] removeAuthStateDidChangeListener:handle];
}

#pragma mark - pcm player

-(void)playWithData:(NSData *)data {
    [[PCMDataPlayer sharePlayer]playWithData:data];
}

#pragma mark - video player

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [SJRotationManager supportedInterfaceOrientationsForWindow:window];
}

#pragma mark - Notification

- (void)beginMonitorgNotification {
    [self endMonitorgNotification];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(xm_didFinishLaunchingNotification:)
                          name:UIApplicationDidFinishLaunchingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(xm_applicationDidEnterBackground:)
                          name:UIApplicationDidEnterBackgroundNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(xm_applicationDidBecomeActive:)
                          name:UIApplicationDidBecomeActiveNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(xm_applicationWillResignActive:)
                          name:UIApplicationWillResignActiveNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(xm_applicationWillTerminate:)
                          name:UIApplicationWillTerminateNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(xm_applicationWillEnterForeground:)
                          name:UIApplicationWillEnterForegroundNotification
                        object:nil];
}

- (void)endMonitorgNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self
                             name:UIApplicationDidEnterBackgroundNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationDidBecomeActiveNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillResignActiveNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillTerminateNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:UIApplicationWillEnterForegroundNotification
                           object:nil];
}

- (void)xm_didFinishLaunchingNotification:(NSNotification *)notification {
    [self application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:notification.userInfo];
}

- (void)xm_applicationDidBecomeActive:(NSNotification *)notification {
    [self applicationDidBecomeActive:[UIApplication sharedApplication]];
}

- (void)xm_applicationDidEnterBackground:(NSNotification *)notification {
    [self applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)xm_applicationWillResignActive:(NSNotification *)notification {
    [self applicationWillResignActive:[UIApplication sharedApplication]];
}

- (void)xm_applicationWillTerminate:(NSNotification *)notification {
    [self applicationWillTerminate:[UIApplication sharedApplication]];
}

- (void)xm_applicationWillEnterForeground:(NSNotification *)notification {
    [self applicationWillEnterForeground:[UIApplication sharedApplication]];
}

@end
