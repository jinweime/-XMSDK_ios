//
//  TTHTTPAgent.h
//  TTKanKan
//
//  Created by 夏和奇 on 2017/6/8.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>

///  HTTP Request method.
typedef NS_ENUM(NSInteger, TTHTTPRequestMethod) {
    TTHTTPRequestMethodGET = 0,
    TTHTTPRequestMethodPOST,
    TTHTTPRequestMethodHEAD,
    TTHTTPRequestMethodPUT,
    TTHTTPRequestMethodDELETE,
    TTHTTPRequestMethodPATCH,
    TTHTTPRequestMethodUpload,
};

// Block
typedef void(^TTRequestSuccessBlock) (NSURLSessionDataTask *task, id responseObject);
typedef void(^TTRequestFailureBlock) (NSURLSessionDataTask *task, NSError *error);
typedef void(^TTRequestProgressBlock) (NSProgress *progress);

// 用做请求参数
@interface TTHTTPRequest : NSObject

@property (nonatomic, assign) TTHTTPRequestMethod method; // default: GET

@property (nonatomic, copy, readonly) NSString *url;

@property (nonatomic, copy, readonly) NSDictionary *parameters; // default:公共参数

@property (nonatomic, assign) NSTimeInterval timeout; // default:15.f

@property (nonatomic, copy) NSString *cookie; // default:如果登录传登录信息，未登录传nil

@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy; // `NSURLRequestUseProtocolCachePolicy` by default.

@property (nonatomic, copy, readonly) NSMutableDictionary *headers; // 放字典

+ (instancetype)defaultRequestWithURL:(NSString *)url;
+ (instancetype)defaultRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters;
@end


@class TTHTTPUploadFormData;
@interface TTHTTPUploadRequest : TTHTTPRequest

@property (nonatomic, strong) NSArray<TTHTTPUploadFormData *> *uploadFormDatas;


@end


@interface TTHTTPAgent : NSObject

+ (instancetype)sharedClient;

- (NSURLSessionTask *)requestByDefaultRequestWithURL:(NSString *)url
                                          parameters:(NSDictionary *)parameters
                                             success:(TTRequestSuccessBlock)success
                                             failure:(TTRequestFailureBlock)failure;

- (NSURLSessionTask *)requestByCustomRequest:(TTHTTPRequest *)request
                                     success:(TTRequestSuccessBlock)success
                                     failure:(TTRequestFailureBlock)failure;

- (NSURLSessionTask *)requestByCustomRequest:(TTHTTPRequest *)request
                                    progress:(TTRequestProgressBlock)progress
                                     success:(TTRequestSuccessBlock)success
                                     failure:(TTRequestFailureBlock)failure;
@end



@interface TTHTTPUploadFormData : NSObject
/** 需要上传的数据流*/
@property (nonatomic, strong) NSData *data;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *mimeType;

@end
