//
//

#import <Foundation/Foundation.h>
#import "XMAppleIAPModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface XMAppleIAP_Lost_Transaction_Helper : NSObject
+ (void)saveUid:(NSString *)uid productId:(NSString *)pid type:(XMAppleIAPType)type tid:(NSString *)tid purchaseToken:(NSString *)token;
+ (void)updateSavedProductInfo:(NSString *)transactionIdentifier;
+ (NSMutableArray<XMAppleIAPModel *> *)savedProductInfos;
+ (void)processLostTransaction:(nonnull void (^)(XMAppleIAPModel *model))enumerate;
@end

NS_ASSUME_NONNULL_END
