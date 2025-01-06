//
//  XMVoiceToTextHelper.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/2.
//

#import "XMSTTManager.h"

//=====================
//=====================
//=====================
@interface XMSTTActionFrameModel ()
@end

@interface XMSTTAction ()
@property (nonatomic,strong) NSMutableArray<XMSTTActionFrameModel *>* sequenceFrameModels;
@property (nonatomic)BOOL isPlaying;
@end

@implementation XMSTTAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPlaying = false;
    }
    return self;
}

- (void)addFrameModel_state:(XMSTTState)state
                       text:(NSString *)text
                      error:(NSError *)error{
    
    XMSTTActionFrameModel *model = [[XMSTTActionFrameModel alloc] init];
    model.text = text;
    model.state = state;
    model.error = error;
    [self.sequenceFrameModels addObject:model];
    if (!self.isPlaying) {
        [self startNext];
    }
}

- (void)startNext{
    
    NSLog(@"--==-=-=-=-=0=-0-=0=-0=-=");
    
    if (self.sequenceFrameModels.count) {
        self.isPlaying = true;
        [NSRunLoop.currentRunLoop cancelPerformSelector:@selector(startPlay) target:self argument:nil];
        [NSRunLoop.currentRunLoop performSelector:@selector(startPlay) target:self argument:nil order:10 modes:@[NSDefaultRunLoopMode]];
    }else{
        self.isPlaying = false;
    }
}

- (void)startPlay{
    XMSTTActionFrameModel *frameModel = self.sequenceFrameModels.firstObject;
    [self.sequenceFrameModels removeObjectAtIndex:0];
    self.state = frameModel.state;
    self.text = frameModel.text;
}

@end


//=====================
//=====================
//=====================
@interface XMSTTManager ()

@property (nonatomic,strong)NSMutableArray *actionQueue;
@property(nonatomic,strong)XMSTTAction *currentAction;
@property(nonatomic,strong)JJVoiceConvertTextActuator *actuator;

//正在做
@property (nonatomic)BOOL isDoing;

@end

@implementation XMSTTManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actionQueue = [[NSMutableArray alloc] init];
        self.isDoing = false;
    }
    return self;
}

- (void)addAction:(XMSTTAction *)action{
    [self.actionQueue addObject:action];
    [action addFrameModel_state:XMSTTStateDoing text:@"转换中..." error:nil];
    [self startAll];
}

- (void)startAll{
    if (self.isDoing) {
        return;
    }
    [self startNext];
}

- (void)startNext{
    if (self.actionQueue.count) {
        self.isDoing = true;
        self.currentAction = self.actionQueue.firstObject;
        [self.actionQueue removeObjectAtIndex:0];
        [self startOne];
    }else{
        self.isDoing = false;
        self.currentAction = nil;
    }
}

//处理文件路径 文件转换格式.
//- (void)fetchWavFilePathFromFilePath:(NSString *)filePath
//                   completionHandler:(void(^)(NSString *wavFilePath,NSError *error))completionHandler{
//
//    if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
//        NSString *fileName = filePath.lastPathComponent;
//        
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//        path = [path stringByAppendingPathComponent:@"EMDemoRecord"];
//        if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
//            [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        filePath = [path stringByAppendingPathComponent:fileName];
//        if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
//            completionHandler(@"",[NSError errorWithDomain:@"fileNotExist" code:-2 userInfo:nil]);
//            return;
//        }
//    }
//
//    //mp3 - file.pathExtension
//    if ([[filePath pathExtension] isEqualToString:@"mp3"]) {
//        completionHandler(filePath,nil);
//        return;
//    }
//    
//    //mp3 - file.data
//    if (isMP3File([filePath cStringUsingEncoding:NSASCIIStringEncoding])) {
//        completionHandler(filePath,nil);
//        return;
//    }
//
//    //wav - pathExtension - exists
//    NSString *wavFilePath
//    = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
//    if ([NSFileManager.defaultManager fileExistsAtPath:wavFilePath]) {
//        completionHandler(wavFilePath,nil);
//        return;
//    }
//    
//    //amr
//    if (isAMRFile([filePath cStringUsingEncoding:NSASCIIStringEncoding])) {
//        if (EM_DecodeAMRFileToWAVEFile([filePath cStringUsingEncoding:NSASCIIStringEncoding],
//                                       [wavFilePath cStringUsingEncoding:NSASCIIStringEncoding])){
//            completionHandler(wavFilePath,nil);
//            return;
//        }
//    }
//    
//    completionHandler(@"",[NSError errorWithDomain:@"fileConvertFailure" code:-3 userInfo:nil]);
//    return;
//}

- (void)startOne{
    __weak typeof(self) weakSelf = self;
    self.actuator = [JJVoiceConvertTextActuator recognizeLocalAudio_wavFilePath:self.currentAction.filePath doingHandler:^(XMSTTState state, SFTranscription * _Nullable transcription) {
        [weakSelf.currentAction addFrameModel_state:state text:transcription.formattedString error:nil];
    } completionHandler:^(XMSTTState state, SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        [weakSelf.currentAction addFrameModel_state:state text:result.bestTranscription.formattedString error:error];
        [weakSelf startNext];
    }];
//    __weak typeof(self) weakSelf = self;
//    [self fetchWavFilePathFromFilePath:self.currentAction.filePath completionHandler:^(NSString *wavFilePath, NSError *error) {
//        if (error) {
//            [weakSelf.currentAction addFrameModel_state:XMSTTStateFailure text:MSG_VOICE_CONVERTFAILURETEXT error:error];
//            return;
//        }
//        weakSelf.actuator = [JJVoiceConvertTextActuator recognizeLocalAudio_wavFilePath:wavFilePath doingHandler:^(XMSTTState state, SFTranscription * _Nullable transcription) {
//            [weakSelf.currentAction addFrameModel_state:state text:transcription.formattedString error:nil];
//        } completionHandler:^(XMSTTState state, SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
//            [weakSelf.currentAction addFrameModel_state:state text:result.bestTranscription.formattedString error:error];
//            [weakSelf startNext];
//        }];
//    }];
}

- (void)stopOne{
    
}

- (void)stopAll{
    [self.actionQueue removeAllObjects];
    self.isDoing = false;
    [self.actuator cancelTask];
}


@end

//=====================
//=====================
//=====================
@interface JJVoiceConvertTextActuator ()

@property (nonatomic,strong)SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic,strong)SFSpeechRecognitionResult *result;
@end
@implementation JJVoiceConvertTextActuator

+ (instancetype)recognizeLocalAudio_wavFilePath:(NSString *)wavFilePath
                                   doingHandler:(EMVoiceConvertDoingHandler)doingHandler
                              completionHandler:(EMVoiceConvertCompletionHandler)completionHandler{
    
    JJVoiceConvertTextActuator *actuator = [[JJVoiceConvertTextActuator alloc] init];
    SFSpeechURLRecognitionRequest *recognitionRequest
    = [[SFSpeechURLRecognitionRequest alloc] initWithURL:[NSURL fileURLWithPath:wavFilePath]];
    SFSpeechRecognizer *recongnizer
    = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    actuator.recognitionTask
    = [recongnizer recognitionTaskWithRequest:recognitionRequest delegate:actuator];
    actuator.doingHandler = doingHandler;
    actuator.completionHandler = completionHandler;
    return actuator;
}

- (void)cancelTask{
    [self.recognitionTask cancel];
}


// Called when the task first detects speech in the source audio
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task{
    
}

// Called for all recognitions, including non-final hypothesis
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription{
    NSLog(@"转换中...");
    if (task.isCancelled) {
        return;
    }
    NSLog(@"%@",transcription.formattedString);
    self.doingHandler(XMSTTStateDoing, transcription);
}

// Called only for final recognitions of utterances. No more about the utterance will be reported
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult{
    self.result = recognitionResult;
    NSLog(@"%@",self.result.bestTranscription.formattedString);
}

// Called when the task is no longer accepting new audio but may be finishing final processing
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task{
    
}

// Called when the task has been cancelled, either by client app, the user, or the system
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task{
    
}

// Called when recognition of all requested utterances is finished.
// If successfully is false, the error property of the task will contain error information
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully{
    if (successfully) {
        self.completionHandler(XMSTTStateSuccess, self.result, nil);
    }else{
        self.completionHandler(XMSTTStateFailure, nil, task.error);
    }
}


@end

