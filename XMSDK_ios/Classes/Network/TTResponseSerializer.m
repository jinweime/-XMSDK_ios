//
//  TTGifResponseSerializer.m
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/9.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTResponseSerializer.h"

@implementation TTGifResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"image/gif", nil];
    
    return self;
}

#pragma mark - AFURLResponseSerializer
// 如果是gif直接返回data去本地处理
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        
        return nil;
    }
    
    // 直接返回data
    return data;
}


@end

// 此类是最后一道处理
// 到这里说明之前的解析方法都没有成功，需要返回一个错误
@implementation TTLastResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{

    if (error) {
        *error = [NSError errorWithDomain:@"com.ttkankan.request.last.error" code:-1 userInfo:nil];
    }
    
    // 直接返回data
    return data;
}

@end
