//
//

#import "XMAppleIAP_Lost_Transaction_Helper.h"

static NSString *const XMIAPKey                = @"iap_product";

@implementation XMAppleIAP_Lost_Transaction_Helper
#pragma mark - 漏单处理

+ (void)saveUid:(NSString *)uid productId:(NSString *)pid type:(XMAppleIAPType)type tid:(NSString *)tid purchaseToken:(NSString *)token{
    XMAppleIAPModel *model = [[XMAppleIAPModel alloc]initWithUid:uid productId:pid type:type tid:tid token:token];
    NSArray *jsonArray = [[NSUserDefaults standardUserDefaults] arrayForKey:XMIAPKey] ?: [NSArray array];
    jsonArray = [jsonArray arrayByAddingObject:[model modelToJSONString]];
    [[NSUserDefaults standardUserDefaults] setObject:jsonArray forKey:XMIAPKey];
}

// 交易成功更新本地交易数据
+ (void)updateSavedProductInfo:(NSString *)transactionIdentifier
{
    NSMutableArray<XMAppleIAPModel *> *payOrderInfos = self.savedProductInfos;
    NSUInteger index = [payOrderInfos indexOfObjectPassingTest:^BOOL(XMAppleIAPModel * _Nonnull payOrderInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        return [payOrderInfo.tid isEqualToString:transactionIdentifier];
    }];
    
    if (index != NSNotFound) {
        [payOrderInfos removeObjectAtIndex:index];
        NSMutableArray *jsonArray = [NSMutableArray array];
        [payOrderInfos enumerateObjectsUsingBlock:^(XMAppleIAPModel * _Nonnull payOrderInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            [jsonArray addObject:[payOrderInfo modelToJSONString]];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:jsonArray forKey:XMIAPKey];
    }
}

+ (void)processLostTransaction:(nonnull void (^)(XMAppleIAPModel *model))enumerate {
    [self.savedProductInfos enumerateObjectsUsingBlock:^(XMAppleIAPModel * _Nonnull payOrderInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        enumerate(payOrderInfo);
    }];
}

#pragma mark - getter && setter
+ (NSMutableArray<XMAppleIAPModel *> *)savedProductInfos {
    NSMutableArray *productInfos = [NSMutableArray array];
    NSArray<NSString *> *array = [[NSUserDefaults standardUserDefaults] arrayForKey:XMIAPKey];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull jsonString, NSUInteger idx, BOOL * _Nonnull stop) {
        if (jsonString.length > 0) {
            [productInfos addObject:[XMAppleIAPModel modelWithJSON:jsonString]];
        }
    }];
    return productInfos;
}
@end
