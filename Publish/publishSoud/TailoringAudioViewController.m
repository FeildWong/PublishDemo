//
//  TailoringAudioViewController.m
//  BZW
//
//  Created by 加联加信息技术有限公司 on 17/5/8.
//  Copyright © 2017年 Kaka. All rights reserved.
//

#import "TailoringAudioViewController.h"
#import "YHorizontalTableView.h"
#import "XHSoundRecorder.h"
#import "NMRangeSlider.h"
#import <AudioToolbox/AudioToolbox.h>


@interface TailoringAudioViewController ()<YHorizontalTableViewDelegate,YHorizontalTableViewDataSource>

@property(nonatomic,strong)YHorizontalTableView * tableView;

@property (nonatomic,strong) XHSoundRecorder *player;

@property (nonatomic,strong) NMRangeSlider *labelSlider;

@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UISlider *footerslider;

@property (nonatomic,strong) UILabel *cuttentTimeLabel;
@property (nonatomic,strong) UILabel *allTimeLabel;
@property(nonatomic, assign) float AllTime;
@property(nonatomic, assign) float starttime;
@property(nonatomic, assign) float endtime;

@end


@implementation TailoringAudioViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.tableView = [[YHorizontalTableView alloc] initWithFrame:CGRectMake(10 , 10, self.view.frame.size.width, 400)];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorColor = [UIColor redColor];
    
    self.tableView.delegate_Y = self;
    self.tableView.dataSource_Y = self;
    [self.tableView registerClass:[YHorizontalCell class] forCellReuseIdentifier:@"cell"];
    [self scrollToTableBottom];
    
    //self.slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 450, kScreenWidth-20, 10)];
    //[self.view addSubview:self.slider];
    self.labelSlider = [[NMRangeSlider alloc]initWithFrame:CGRectMake(10, 450, self.view.frame.size.width-20, 10)];
    [self.view addSubview:self.labelSlider];
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    
    self.labelSlider.minimumRange = 10;
    [self.labelSlider addTarget:self action:@selector(updateSliderLabels) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.player = [XHSoundRecorder alloc];
    
    [self.player playsound:_audioUrl withFinishPlaying:^{
        
    }];
    
    _AllTime = [self.player.player duration];
    
    //[self.player stopPlaysound];
    _cuttentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 460, 100, 30)];
    
    [self.view addSubview:_cuttentTimeLabel];
    _allTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 460, 100, 30)];
    
    [self.view addSubview:_allTimeLabel];
    
    //[self.slider addTarget:self action:@selector(processChanged:) forControlEvents:UIControlEventValueChanged];
    //[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 460, 200, 200)];
    [startButton setTitle:@"裁剪" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(tailoring) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    _allTimeLabel.text = [NSString stringWithFormat:@"%f",self.player.player.duration];
}
- (void) updateSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    //self.lowerLabel.center = lowerCenter;
    //self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    self.starttime = self.labelSlider.lowerValue*_AllTime/100;
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    //self.upperLabel.center = upperCenter;
    //self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
    self.endtime = self.labelSlider.upperValue*_AllTime/100;
  
}


-(void)tailoring{
  
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
    
    self.fileName = currentTimeString;
    
    NSString *exportPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    exportPath = [exportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",currentTimeString]];
    
    self.wavPath = exportPath;

    int64_t start = atoll([[NSString stringWithFormat:@"%f",_starttime] UTF8String]);
    int64_t end = atoll([[NSString stringWithFormat:@"%f",_endtime] UTF8String]);

    [self exportPath:exportPath withFilePath:_audioUrl withStartTime:start withEndTime:end withBlock:^(BOOL ret) {
        if (ret == YES) {
            self.player = nil;
            XHSoundRecorder *tailoringplayer = [XHSoundRecorder alloc];
            
            [tailoringplayer playsound:exportPath withFinishPlaying:^{
                
            }];
        }
        
    }];
    


}

-(void)processChanged:(UISlider *)sender{
    [self.player.player setCurrentTime:self.slider.value*self.player.player.duration];
}
-(void)updateSliderValue
{
    self.slider.value = self.player.player.currentTime/self.player.player.duration;
    _cuttentTimeLabel.text = [NSString stringWithFormat:@"%f",self.player.player.currentTime];
}

- (NSInteger)h_tableView:(YHorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numerArray.count;
}

- (YHorizontalCell *)h_tableView:(YHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHorizontalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YHorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell changeHeight:_numerArray[indexPath.row]];
    
    return cell;
}
- (void)scrollToTableBottom
{
    NSInteger lastRow = self.numerArray.count - 1;
    
    if (lastRow < 0) return;
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
- (void)exportPath:(NSString *)exportPath

      withFilePath:(NSString *)filePath

     withStartTime:(int64_t)startTime

       withEndTime:(int64_t)endTime

         withBlock:(success)handle

{
    
    _block = handle;
    
    NSString *presetName;
    
    NSString *outputFileType;
    
    if ([filePath.lastPathComponent containsString:@"mp4"]) {
        
        presetName = AVAssetExportPreset1280x720;
        
        outputFileType = AVFileTypeMPEG4;
        
    }else if ([filePath.lastPathComponent containsString:@"m4a"]){
        
        presetName = AVAssetExportPresetAppleM4A;
        
        outputFileType = AVFileTypeAppleM4A;
        
    }else{
        _block(NO);   return;
        
    }
    // 1.拿到预处理音频文件
    NSURL *songURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    
    // 2.创建新的音频文件
   /* if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        
    }*/
    NSError *assetError;
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
//    AVAssetWriter *assetWriter =
    [AVAssetWriter assetWriterWithURL:exportURL
                                  
                                                          fileType:AVFileTypeCoreAudioFormat
                                  
                                                             error:&assetError];
    
    if (assetError) {
        
        NSLog (@"创建文件失败 error: %@", assetError);
        
        _block(NO);
        
    }
 
    // 3.创建音频输出会话
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:songAsset
                                           
                                                                            presetName:presetName];
    
    CMTime _startTime = CMTimeMake(startTime, 1);
    
    CMTime _stopTime = CMTimeMake(endTime, 1);
    
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(_startTime, _stopTime);
    
    // 4.设置音频输出会话并执行
    
    exportSession.outputURL = [NSURL fileURLWithPath:exportPath]; // output path
    
    exportSession.outputFileType = outputFileType;            // output file type AVFileTypeAppleM4A
    
    exportSession.timeRange = exportTimeRange;                    // trim time range
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            
            NSLog(@"AVAssetExportSessionStatusCompleted");
            
            //[[NSFileManager defaultManager] replaceItemAtURL:[NSURL fileURLWithPath:filePath] withItemAtURL:[NSURL fileURLWithPath:exportPath] backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:nil];
            
            _block(YES);
            
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            
            NSLog(@"AVAssetExportSessionStatusFailed");
            _block(NO);
            
        } else {
            
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
            
            _block(NO);
            
        }
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
