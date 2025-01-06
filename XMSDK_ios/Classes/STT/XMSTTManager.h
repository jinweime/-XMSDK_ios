//
//  XMVoiceToTextHelper.h
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
// https://gitee.com/huanxin666/EMDemo-oc/blob/master/local_pods/EaseIMKit/EaseIMKit/EaseIMKit/Classes/Chat/new_chatMsgAndOptions/src/util/VoiceToText/EMVoiceConvertTextHelper.mm#

#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    XMSTTStateNone = 1 << 0,
    XMSTTStateDoing = 1 << 1,
    XMSTTStateSuccess = 1 << 2,
    XMSTTStateFailure = 1 << 3,
} XMSTTState;

//=====================
//=====================
//=====================
//这个模型类似于音视频的序列帧，将每次回调的数据存储在 action 的数组中，一帧一帧更新显示
@interface XMSTTActionFrameModel : NSObject
@property (nonatomic)XMSTTState state;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSError *error;
@end


@interface XMSTTAction : NSObject
@property (nonatomic)NSString *filePath;
@property (nonatomic)XMSTTState state;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSError *error;
@end
//=====================
//=====================
//=====================
@interface XMSTTManager : NSObject

+ (instancetype)shared;

- (void)addAction:(XMSTTAction *)action;

- (void)stopAll;

@end

//=====================
//=====================
//=====================
@interface JJVoiceConvertTextActuator : NSObject
<
SFSpeechRecognitionTaskDelegate
>

typedef void(^EMVoiceConvertDoingHandler)(XMSTTState state,SFTranscription*_Nullable transcription);

typedef void(^EMVoiceConvertCompletionHandler)(XMSTTState state,SFSpeechRecognitionResult*_Nullable result,NSError*_Nullable error);

@property (nonatomic,copy)EMVoiceConvertDoingHandler doingHandler;
@property (nonatomic,copy)EMVoiceConvertCompletionHandler completionHandler;

+ (instancetype)recognizeLocalAudio_wavFilePath:(NSString *)wavFilePath
                                   doingHandler:(EMVoiceConvertDoingHandler)doingHandler
                              completionHandler:(EMVoiceConvertCompletionHandler)completionHandler;

- (void)cancelTask;

@end




NS_ASSUME_NONNULL_END

