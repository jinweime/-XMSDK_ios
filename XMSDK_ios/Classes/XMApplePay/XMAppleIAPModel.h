//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XMAppleIAPType) {
    CMAppleIAPTypeOneTime,
    CMAppleIAPTypeSubscribe
};

@interface XMAppleIAPModel : NSObject
@property(nonatomic, strong)NSString * uid;
@property(nonatomic, strong)NSString * pid;
@property(nonatomic, assign)XMAppleIAPType type;
@property(nonatomic, strong)NSString * tid;
@property(nonatomic, strong)NSString * token;
- (instancetype)initWithUid:(NSString *)uid productId:(NSString *)pid type:(XMAppleIAPType)type tid:(NSString *)tid token:(NSString *)token;
- (NSString *)modelToJSONString;
+ (instancetype)modelWithJSON:(id)json;
@end

NS_ASSUME_NONNULL_END
