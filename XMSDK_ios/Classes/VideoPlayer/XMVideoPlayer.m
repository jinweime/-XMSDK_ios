//
//  XMVideoPlayer.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/3.
//

#import "XMVideoPlayer.h"

@implementation XMVideoPlayer

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (SJVideoPlayer *)playerWithUrl:(NSURL *)URL{
    SJVideoPlayer *player = [SJVideoPlayer player];
    player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];
    return player;
}
@end
