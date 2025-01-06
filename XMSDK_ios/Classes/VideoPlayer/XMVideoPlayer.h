//
//  XMVideoPlayer.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/3.
//

#import <Foundation/Foundation.h>
#import <SJVideoPlayer/SJVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMVideoPlayer : NSObject
+ (instancetype)shareInstance;
- (SJVideoPlayer *)playerWithUrl:(NSURL *)URL;
@end

NS_ASSUME_NONNULL_END
