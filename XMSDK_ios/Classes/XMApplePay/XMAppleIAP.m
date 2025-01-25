
//
//
//

#import "XMAppleIAP.h"
#import "XMAppleIAP_Lost_Transaction_Helper.h"
#import "TTNetworkRequest+Real.h"
#import "UserManager.h"

@interface XMAppleIAP ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property(nonatomic, strong) NSString *currentPurchaseID;
@property(nonatomic, copy) void (^products)(NSArray<SKProduct *> * p);
@property(nonatomic, copy) void (^sucess)(NSString *transactionId, NSString *purchaseReceipt);
@property(nonatomic, copy) void (^failure)(NSInteger code, NSString *message);
@end

@implementation XMAppleIAP

+ (instancetype)sharedInstance
{
    static XMAppleIAP* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)queryProductsWithIDs:(NSArray<NSString *>*)ids success:(nonnull void (^)(NSArray<SKProduct *> *))sucess{
    self.products = ^(NSArray<SKProduct *> *ps) {
        if(sucess){
            sucess(ps);
        }
    };
    NSSet *nsset = [NSSet setWithArray:ids];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

- (void)startPurchaseWithID:(NSString *)purchID
                       type:(XMAppleIAPType)type
                            success:(nonnull void (^)(NSString *transactionId, NSString *purchaseReceipt))sucess
                            failure:(nonnull void (^)(NSInteger code, NSString *message))failure{
    self.sucess = ^(NSString *transactionId, NSString *purchaseReceipt) {
        if(sucess){
            sucess(transactionId, purchaseReceipt);
        }
    };
    self.failure = ^(NSInteger code, NSString *message) {
        if(failure){
            failure(code, message);
        }
    };
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            _currentPurchaseID = purchID;
            //从App Store中检索关于指定产品列表的本地化信息
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            if(failure){
                failure(-1, @"");
            }
        }
    }else {
        if(failure){
            failure(-1, @"purchID can not be nil");
        }
    }
}

- (void)parseReceipteWithPaymentTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.originalTransaction) {
        //交易验证
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        NSString *pid = transaction.originalTransaction.payment.productIdentifier;
        NSString *tid = transaction.transactionIdentifier;
        NSString *ptoken = [receipt base64EncodedStringWithOptions:0];
        [[UserManager shareManager]requestUserModelWithHandler:^(UserModel *userModel, NSInteger code, NSString *message) {
            [XMAppleIAP_Lost_Transaction_Helper saveUid:userModel.uid productId:pid type:CMAppleIAPTypeSubscribe tid:tid purchaseToken:ptoken];
            [TTNetworkRequest applePayWithUid:userModel.uid productId:pid type:CMAppleIAPTypeSubscribe purchaseToken:ptoken success:^(id res) {
                [XMAppleIAP_Lost_Transaction_Helper updateSavedProductInfo:tid];
            } failure:nil];
        }];
    }else{
        //交易验证
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
         
        if(!receipt){
            // 交易凭证为空验证失败
            if (self.failure) {
                self.failure(-1, @"receipt is nil");
            }
            return;
        }
        // 购买成功将交易凭证发送给服务端进行再次校验
        if(self.sucess){
            self.sucess(transaction.transactionIdentifier ,[receipt base64EncodedStringWithOptions:0]);
        }
    }
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
        #if DEBUG
            NSLog(@"productID:%@", response.invalidProductIdentifiers);
            NSLog(@"not find product");
        #endif
        if (self.failure) {
            self.failure(-1, @"not find product");
        }
        return;
    }
    
    if(self.products){
        self.products(product);
        self.products = nil;
        return;
    }
    
    if (_currentPurchaseID == nil) {
        if (self.failure) {
            self.failure(-1, @"not find product");
        }
        return;
    }
     
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_currentPurchaseID]){
            p = pro;
            break;
        }
    }
    
    if (p == nil) {
        if (self.failure) {
            self.failure(-1, @"not find product");
        }
        return;
    }
     
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"产品描述:%@",[p description]);
    NSLog(@"产品标题%@",[p localizedTitle]);
    NSLog(@"产品本地化描述%@",[p localizedDescription]);
    NSLog(@"产品价格：%@",[p price]);
    NSLog(@"产品productIdentifier：%@",[p productIdentifier]);
#endif
     
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
#if DEBUG
    NSLog(@"------------------从App Store中检索关于指定产品列表的本地化信息错误-----------------:%@", error);
#endif
    if (self.failure) {
        self.failure(error.code, error.localizedDescription);
    }
}
 
- (void)requestDidFinish:(SKRequest *)request{
#if DEBUG
    NSLog(@"------------requestDidFinish-----------------");
#endif
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self parseReceipteWithPaymentTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                if (self.failure) {
                    self.failure(-3, @"SKPaymentTransactionStateRestored");
                }
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue]addPayment:payment];
        return YES;
    }else{
        return NO;
    }
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        if (self.failure) {
            self.failure(-1, @"payment failed");
        }
    }else{
        if (self.failure) {
            self.failure(-2, @"payment cancel");
        }
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
@end
