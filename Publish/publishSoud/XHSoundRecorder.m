//
//  XHSoundRecorder.m
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import "XHSoundRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface XHSoundRecorder () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) SystemSoundID soundID;



@property (nonatomic, copy) NSString *wavPath;

@property (nonatomic, copy) NSString *mp3Path;

@property (nonatomic, copy) void (^FinishPlaying)();

@property (nonatomic, copy) void (^FinishRecording)(NSString *);


/***  计时器  */
@property (nonatomic, strong) NSTimer *levelTimer;
/***  计时器  */
@property (nonatomic, strong) NSTimer *imageTimer;
/***  计时器对象++1  */
@property (assign, nonatomic)CGFloat timer;

@end

static id _instance;

@implementation XHSoundRecorder

+ (instancetype)sharedSoundRecorder {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (instancetype)alloc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super alloc] init];
    });
    
    return _instance;
}

- (AVAudioRecorder *)recorder {
    
    if (!_recorder) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        NSString * currentTimeString = [formatter stringFromDate:date];
        
        self.fileName = currentTimeString;
        
        NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",currentTimeString]];
        
        self.wavPath = wavPath;
        
        NSURL *url = [NSURL URLWithString:wavPath];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error = nil;
        
        //[session setCategory:AVAudioSessionCategoryRecord error:&error];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        
        [session setActive:YES error:nil];
        
        if(error){
            
            NSLog(@"录音错误说明%@", [error description]);
        }
        
        
        
        NSDictionary *setting = [self recordingSettings];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
        
        _recorder.meteringEnabled = YES;
        
        _recorder.delegate = self;
    }
    
    return _recorder;
}
/**
 *  设置录音一些属性
 */
- (NSDictionary *)recordingSettings
{
    NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
    // 音频格式kAudioFormatMPEG4AAC
    recordSetting[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    recordSetting[AVSampleRateKey] = @(44100);
    // 音频通道数 1 或 2
    recordSetting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度  8、16、24、32
    recordSetting[AVLinearPCMBitDepthKey] = @(16);
    //录音的质量
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
    
    return recordSetting;
}

//开始、继续 录音
- (void)startRecorder:(void (^)(NSString *filePath))FinishRecording {
    
    if (![self.recorder isRecording]) {
        
        [self.recorder prepareToRecord];
        
        [self.recorder record];
        //开始计时
        if (self.levelTimer) {
            [self.levelTimer invalidate];
            self.levelTimer = nil;
        }
        if (self.imageTimer) {
            [self.imageTimer invalidate];
            self.imageTimer = nil;
        }
        
        _timer = 0;
        self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(startTime) userInfo: nil repeats: YES];
        self.imageTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self selector: @selector(changgeImage) userInfo: nil repeats: YES];
    }
    
    self.FinishRecording = FinishRecording;
}
/**
 *  开始录音计时
 */
- (void)startTime {
    _timer++;
    //NSLog(@"当前时间 == %f",_timer);
    int countDown = 0;
    //在这里要判断是否设置最大录音时间
    if (_recordMaxTime > 0) {
        countDown = _recordMaxTime - _timer;
    }else{
        countDown = 120 - _timer;
    }
    NSInteger num = _timer;
    NSString *fen = [NSString stringWithFormat:@"%02ld",num/60];
    NSString *miao;
    
    if (_timer<60) {
        miao =[NSString stringWithFormat:@"%02ld",(long)num];
    }else{
        
        NSInteger number = num%60;
        miao = [NSString stringWithFormat:@"%02ld",number];
    }
    
    //NSLog(@"还可以录制%d",countDown);
    
    if (countDown < 1) {
        NSLog(@"语音最长只能120秒哦");
        [self stopRecorder];
    }
    self.timeRusult([NSString stringWithFormat:@"%@:%@",fen,miao]);
}

//暂停录音
- (void)pauseRecorder {
    
    if ([self.recorder isRecording]) {
        
        [self.recorder pause];
    }
    
}

//停止录音
- (void)stopRecorder {
    
    [self.recorder stop];
    
    self.recorder = nil;
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    if (self.imageTimer) {
        [self.imageTimer invalidate];
        self.imageTimer = nil;
    }
}

//播放
- (void)playsound:(NSString *)filePath withFinishPlaying:(void (^)())FinishPlaying {
    
    if (!self.player) {
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error = nil;
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        [session setActive:YES error:&error];
        if(error){
            
            NSLog(@"播放错误说明%@", [error description]);
        }
        
        NSURL *url;
        
        if (filePath == nil) {
            
            if (self.wavPath) {
                
                url = [NSURL fileURLWithPath:self.wavPath];
            } else if (self.mp3Path) {
                
                url = [NSURL fileURLWithPath:self.mp3Path];
            } else {
                
                return;
            }
            
        } else {
            
            url = [NSURL fileURLWithPath:filePath];;
        }
        
        if (url == nil) {
            
            return;
        }
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        self.player.delegate = self;
        
    }
    
    [self.player prepareToPlay];
    
    [self.player play];
    
    self.FinishPlaying = FinishPlaying;
    
}

//暂停播放
- (void)pausePlaysound {
    
    [self.player pause];
}

//停止播放
- (void)stopPlaysound {
    
    [self.player stop];
    
    self.player = nil;
}

//删除录音
- (void)removeSoundRecorder {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (self.wavPath) {
        
        [manager removeItemAtPath:self.wavPath error:nil];
        
        self.wavPath = nil;
        
    } else {
        
        [manager removeItemAtPath:self.mp3Path error:nil];
        
        self.mp3Path = nil;
    }
    
    self.recorder = nil;
    
    self.player = nil;
    
}

//分贝数
- (void)changgeImage {
    
    NSString *image;
    NSString *fenbei;
    if (_recorder) {
        [_recorder updateMeters];
        double ff = [_recorder averagePowerForChannel:0];
        ff = ff+60;
        fenbei = [NSString stringWithFormat:@"%f",ff];
        if (ff>0&&ff<=10) {
            image= @"toast_vol_0";
        } else if (ff>10 && ff<20) {
            image= @"toast_vol_1";
        } else if (ff >=20 &&ff<30) {
            image= @"toast_vol_2";
        } else if (ff >=30 &&ff<40) {
            image= @"toast_vol_3";
        } else if (ff >=40 &&ff<50) {
            image= @"toast_vol_4";
        } else if (ff >= 50 && ff < 60) {
            image= @"toast_vol_5";
        } else if (ff >= 60 && ff < 70) {
            image= @"toast_vol_6";
        } else {
            image= @"toast_vol_7";
        }
    }
    
    self.imageRusult(image,fenbei);
}


//播放结束的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.FinishPlaying) {
        
        self.FinishPlaying();
    }
    
    self.player = nil;
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    [self stopPlaysound];
}


//播放被打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    [self playsound:nil withFinishPlaying:nil];
}


//录音结束的代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (self.FinishRecording) {
        
        self.FinishRecording(self.wavPath);
    }
}

//录音被打断时
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    
    [self stopRecorder];
    
}

//录音被打断结束时
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    
}


//转成mp3格式
- (void)recorderFileToMp3WithType:(Type)type filePath:(NSString *)filePath FilePath:(void (^)(NSString *newfilePath))newFilePath {
    
    NSString *wavFilePath;
    
    if (filePath == nil) {
        
        if (self.wavPath == nil) {
            
            NSLog(@"没有要转的文件");
            
            return;
        }
        
        wavFilePath = self.wavPath;
        
    } else {
        
        wavFilePath = filePath;
    }
    
   
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.fileName]];
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, type == TrueMachine ? 22050 : 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"转换完毕");
        self.mp3Path = mp3FilePath;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:self.wavPath error:nil];
        
        self.wavPath = nil;
        
        newFilePath(mp3FilePath);
    }
    
}


@end





