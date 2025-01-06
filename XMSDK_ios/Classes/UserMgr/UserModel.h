//
//  UserModel.h
//  Comics
//
//  Created by zhangmingsheng on 2024/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, strong)NSString *token;
@property(nonatomic, assign)BOOL firstSign;
@end

NS_ASSUME_NONNULL_END
