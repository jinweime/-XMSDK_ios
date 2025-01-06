//
//

#import "XMApplePay.h"
#import "XMAppleIAP_Lost_Transaction_Helper.h"
#import "TTNetworkRequest+Real.h"
#import "UserManager.h"

@implementation XMApplePay
+ (void)startPurchaseWithID:(NSString *)subjectId
                       type:(XMAppleIAPType)type
                    success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                    failure:(nonnull void (^)(NSInteger code, NSString *message))failure{
    
    //漏单处理
    [XMAppleIAP_Lost_Transaction_Helper processLostTransaction:^(XMAppleIAPModel * _Nonnull model) {
        [TTNetworkRequest applePayWithUid:model.uid productId:model.pid type:model.type purchaseToken:model.token success:^(id res) {
            [XMAppleIAP_Lost_Transaction_Helper updateSavedProductInfo:model.tid];
        } failure:failure];
    }];
    [[UserManager shareManager]requestUserModelWithHandler:^(UserModel *userModel, NSInteger code, NSString *message) {
        [[XMAppleIAP sharedInstance]startPurchaseWithID:subjectId type:type success:^(NSString *transactionId, NSString * _Nonnull purchaseReceipt) {
            [XMAppleIAP_Lost_Transaction_Helper saveUid:userModel.uid productId:subjectId type:type tid:transactionId purchaseToken:purchaseReceipt];
            [TTNetworkRequest applePayWithUid:userModel.uid productId:subjectId type:type purchaseToken:purchaseReceipt success:^(id res) {
                [XMAppleIAP_Lost_Transaction_Helper updateSavedProductInfo:transactionId];
            } failure:failure];
        } failure:^(NSInteger code, NSString * _Nullable message) {
            failure(code,message);
        }];
    }];
}
@end
