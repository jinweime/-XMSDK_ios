//
//  PCMRecorder.m
//  XMSDK
//
//  Created by zhangmingsheng on 2025/1/3.
// https://www.jianshu.com/p/62cac1ddb2a5
// https://www.jianshu.com/p/fea0cbe42cb2

#import "PCMRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface PCMRecorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    /** 录音计时器 */
    NSTimer *recordTimer;
    /** 播放计时器 */
    NSTimer *playTimer;
    /** 录音时间 */
    NSInteger recordSecond;
    /** 录音分钟时间 */
    NSInteger minuteRecord;
    /** 播放时间 */
    NSInteger playSecond;
    /** 播放分钟时间 */
    NSInteger minutePlay;
    /** caf文件路径 */
    NSURL *tmpUrl;
}

@end

@implementation PCMRecorder

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

/**
 开始
 */
- (void)startRecord{

    // 开始录音
    [self recordingAction];
}


/**
 结束
 */
- (void)endRecord{
    
    // 停止录音
    [self stopAction];
}


/**
 播放
 */
- (void)playRecord{

   // 播放录音
   [self playAction];
}


/**
 开始录音
 */
- (void)recordingAction {
    
    NSLog(@"开始录音");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];

    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    [recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

    NSError *error = nil;
    // 沙盒目录Documents地址
    NSString *recordUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // caf文件路径
    tmpUrl = [NSURL URLWithString:[recordUrl stringByAppendingPathComponent:@"selfRecord.caf"]];
    recorder = [[AVAudioRecorder alloc]initWithURL:tmpUrl settings:recordSettings error:&error];
    
    if (recorder) {
        //启动或者恢复记录的录音文件
        if ([recorder prepareToRecord] == YES) {
            [recorder record];

            recordSecond = 0;
            minuteRecord = 0;
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordSecondChange) userInfo:nil repeats:YES];
            [recordTimer fire];
        }
        
    }else {
        NSLog(@"录音创建失败");
    }
}


/**
 录音计时
 */
- (void)recordSecondChange {
    
    recordSecond ++;
    if (recordSecond > 59) {
        
        minuteRecord ++;
        recordSecond = 0;
    }
//    self.timeLbl.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minuteRecord,(long)recordSecond];
}


/**
 停止录音
 */
- (void)stopAction {
    
    NSLog(@"停止录音");
    //停止录音
    [recorder stop];
    recorder = nil;
    [recordTimer invalidate];
    recordTimer = nil;
    
//    self.timeLbl.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minuteRecord,(long)recordSecond];
}


/**
 播放录音
 */
- (void)playAction {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError *playError;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:tmpUrl error:&playError];
    //当播放录音为空, 打印错误信息
    if (player == nil) {
        NSLog(@"Error crenting player: %@", [playError description]);
    }else {
        player.delegate = self;
        NSLog(@"开始播放");
        //开始播放
        playSecond = recordSecond;
        minutePlay = minuteRecord;
        if ([player prepareToPlay] == YES) {
           
            [player play];
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playSecondChange) userInfo:nil repeats:YES];
            [playTimer fire];
        }
    }
}


/**
 播放计时
 */
- (void)playSecondChange {
    playSecond --;

    if (playSecond < 0) {
        
        if (minutePlay <= 0) {
            
            playSecond = 0;
            minutePlay = 0;
            [playTimer invalidate];
        }else{
            minutePlay --;
            playSecond = 59;
        }
        
    }
//    self.timeLbl.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minutePlay,(long)playSecond];
}


//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放结束");
    [playTimer invalidate];
    playTimer = nil;
    
//    self.timeLbl.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minuteRecord,(long)recordSecond];
}

@end
