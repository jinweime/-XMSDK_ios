//
//

#import "XMAppleIAPModel.h"
#import <YYModel/YYModel.h>

@implementation XMAppleIAPModel
- (instancetype)initWithUid:(NSString *)uid productId:(NSString *)pid type:(XMAppleIAPType)type tid:(NSString *)tid token:(NSString *)token{
    if(self = [super init]) {
        self.uid = uid;
        self.pid = pid;
        self.type = type;
        self.tid = tid;
        self.token = token;
    }
    return self;
}

- (NSString *)modelToJSONString{
    return [self yy_modelToJSONString];
}

+ (instancetype)modelWithJSON:(id)json{
    return [self yy_modelWithJSON:json];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self yy_modelToJSONString]];
}
@end
