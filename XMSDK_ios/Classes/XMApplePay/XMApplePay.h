//
//

#import <Foundation/Foundation.h>
#import "XMAppleIAP.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMApplePay : NSObject
+ (void)startPurchaseWithID:(NSString *)purchID
                       type:(XMAppleIAPType)type
                    success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                    failure:(nonnull void (^)(NSInteger code, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
