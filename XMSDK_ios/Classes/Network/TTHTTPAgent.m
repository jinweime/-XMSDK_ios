//
//  TTHTTPAgent.m
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/8.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTHTTPAgent.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "TTResponseSerializer.h"
@implementation TTHTTPRequest

- (instancetype)init
{
    if (self = [super init]) {
        
        _method = TTHTTPRequestMethodGET;
        _parameters = [self publicParameters];
        _timeout = 15.f;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _headers = [@{} mutableCopy];
        [_headers setObject:@"1.5" forKey:@"version"];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url parameters:(NSDictionary *)parameters
{
    if (self = [self init]) {
        _url = [url copy];
        
        if (parameters) {
            NSMutableDictionary *mutableDic = [_parameters mutableCopy];
            [mutableDic addEntriesFromDictionary:parameters];
            _parameters = [mutableDic copy];
        }
    }
    return self;
}
- (NSDictionary *)publicParameters // 可增加
{
    // 平台参数 1-android; 2-iphone; 3-android_pad; 4-ipad
    return @{@"platform" : @2};
}


+ (instancetype)defaultRequestWithURL:(NSString *)url
{
    return [self defaultRequestWithURL:url parameters:nil];
}
+ (instancetype)defaultRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSParameterAssert(url);
    
    TTHTTPRequest *request = [[self alloc] initWithURL:url parameters:parameters];
    
    return request;
}
@end


@implementation TTHTTPUploadRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.method = TTHTTPRequestMethodUpload;
    }
    return self;
}

@end

@interface TTHTTPAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionMgr;
@end
@implementation TTHTTPAgent

- (instancetype)init
{
    if (self = [super init]) {
        
        
        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:0 diskPath:nil]];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        _sessionMgr = [[AFHTTPSessionManager alloc] init];
        _sessionMgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; // 如果自建证书要改这里
        
        // requestSerializer
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionMgr.requestSerializer = requestSerializer;
        
        // responseSerializer
        AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
        NSSet *addContentTypes = [NSSet setWithObjects:@"text/html",@"text/css",@"text/plain", nil];
        jsonSerializer.acceptableContentTypes = [jsonSerializer.acceptableContentTypes setByAddingObjectsFromSet:addContentTypes];
        jsonSerializer.removesKeysWithNullValues = YES; // 去掉NSNull
        
        // 对gif不转换成image，返回自己处理
        TTGifResponseSerializer *gifSerializer = [TTGifResponseSerializer serializer];
        AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
        
        // 最后一道防线，进入的话说明解析都没有成功。这个类会返回错误
        TTLastResponseSerializer *lastSerializer = [TTLastResponseSerializer serializer];
        
        NSArray *serializers = @[jsonSerializer, gifSerializer, imageSerializer, lastSerializer];
        _sessionMgr.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:serializers];
        
    }
    return self;
}
+ (instancetype)sharedClient {
    static TTHTTPAgent *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}


- (NSURLSessionTask *)requestByDefaultRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                                             success:(TTRequestSuccessBlock)success failure:(TTRequestFailureBlock)failure
{
    TTHTTPRequest *request = [TTHTTPRequest defaultRequestWithURL:url parameters:parameters];
    
    return [self requestByCustomRequest:request success:success failure:failure];
}
- (NSURLSessionTask *)requestByCustomRequest:(TTHTTPRequest *)request
                                     success:(TTRequestSuccessBlock)success failure:(TTRequestFailureBlock)failure
{
    return [self requestByCustomRequest:request progress:nil success:success failure:failure];
}
- (NSURLSessionTask *)requestByCustomRequest:(TTHTTPRequest *)request
                                     progress:(TTRequestProgressBlock)progress success:(TTRequestSuccessBlock)success failure:(TTRequestFailureBlock)failure
{
    AFHTTPRequestSerializer *requestSerializer = self.sessionMgr.requestSerializer;
    [requestSerializer setCachePolicy:request.cachePolicy];
    [requestSerializer setTimeoutInterval:request.timeout];
    [requestSerializer setValue:request.cookie forHTTPHeaderField:@"Cookie"];
    
    NSURLSessionTask *sessionTask = nil;
    switch (request.method) {
        case TTHTTPRequestMethodGET:
        {
            sessionTask =  [self.sessionMgr GET:request.url
                                     parameters:request.parameters
                                        headers:request.headers
                                       progress:progress
                                        success:success
                                        failure:failure];
        }
            break;
        case TTHTTPRequestMethodPOST:
        {
            sessionTask =  [self.sessionMgr POST:request.url
                                     parameters:request.parameters
                                         headers:request.headers
                                        progress:progress
                                        success:success
                                        failure:failure];
        }
            break;
        case TTHTTPRequestMethodPUT:
        {
            sessionTask =  [self.sessionMgr PUT:request.url
                                      parameters:request.parameters
                                        headers:request.headers
                                         success:success
                                         failure:failure];
        }
            break;
        case TTHTTPRequestMethodHEAD:
        {
            sessionTask =  [self.sessionMgr HEAD:request.url
                                      parameters:request.parameters
                                         headers:request.headers
                                         success:^(NSURLSessionDataTask * _Nonnull task) {
                                             if (success) {
                                                 success(task, nil);
                                             }
                                         }
                                         failure:failure];
        }
            break;
        case TTHTTPRequestMethodPATCH:
        {
            sessionTask =  [self.sessionMgr PATCH:request.url
                                      parameters:request.parameters
                                          headers:request.headers
                                         success:success
                                         failure:failure];
        }
            break;
        case TTHTTPRequestMethodDELETE:
        {
            sessionTask =  [self.sessionMgr DELETE:request.url
                                      parameters:request.parameters
                                           headers:request.headers
                                         success:success
                                         failure:failure];
        }
            break;
        case TTHTTPRequestMethodUpload:
        {
            if ([request isKindOfClass:[TTHTTPUploadRequest class]]) {
                TTHTTPUploadRequest *uploadRequest = (TTHTTPUploadRequest *)request;
                sessionTask =  [self.sessionMgr POST:uploadRequest.url
                                          parameters:uploadRequest.parameters
                                             headers:request.headers
                           constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                               
                               for (TTHTTPUploadFormData *uploadData in uploadRequest.uploadFormDatas) {
                                   
                                   [formData appendPartWithFileData:uploadData.data
                                                               name:uploadData.name
                                                           fileName:uploadData.fileName
                                                           mimeType:uploadData.mimeType];
                               }
                           }
                                            progress:progress
                                            success:success
                                            failure:failure];
            }
            
        }
            break;
        default:
            break;
    }
    
    return sessionTask;
}

@end



@implementation TTHTTPUploadFormData

@end
