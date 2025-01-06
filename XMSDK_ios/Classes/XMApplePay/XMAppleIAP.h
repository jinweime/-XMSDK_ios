//
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "XMAppleIAPModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    IAPPurchSuccess = 0,       // 购买成功
    IAPPurchFailed = 1,        // 购买失败
    IAPPurchCancel = 2,        // 取消购买
    IAPPurchVerFailed = 3,     // 订单校验失败
    IAPPurchVerSuccess = 4,    // 订单校验成功
    IAPPurchNotArrow = 5,      // 不允许内购
}IAPPurchType;

@interface XMAppleIAP :NSObject
+ (instancetype)sharedInstance;
- (void)startPurchaseWithID:(NSString *)purchID
                       type:(XMAppleIAPType)type
                    success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                    failure:(nonnull void (^)(NSInteger code, NSString *message))failure;
@end
NS_ASSUME_NONNULL_END

