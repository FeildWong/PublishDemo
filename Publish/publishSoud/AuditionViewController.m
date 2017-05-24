//
//  AuditionViewController.m
//  BZW
//
//  Created by 加联加信息技术有限公司 on 17/5/5.
//  Copyright © 2017年 Kaka. All rights reserved.
//

#import "AuditionViewController.h"
#import "YHorizontalTableView.h"
#import "XHSoundRecorder.h"



@interface AuditionViewController ()<YHorizontalTableViewDelegate,YHorizontalTableViewDataSource>

@property(nonatomic,strong)YHorizontalTableView * tableView;

@property (nonatomic,strong) XHSoundRecorder *recorder;



@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UILabel *cuttentTimeLabel;
@property (nonatomic,strong) UILabel *allTimeLabel;
@property(nonatomic, assign) float AllTime;

@end

@implementation AuditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[YHorizontalTableView alloc] initWithFrame:CGRectMake(10 , 10, self.view.frame.size.width, 400)];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorColor = [UIColor redColor];
    
    self.tableView.delegate_Y = self;
    self.tableView.dataSource_Y = self;
    [self.tableView registerClass:[YHorizontalCell class] forCellReuseIdentifier:@"cell"];
    [self scrollToTableBottom];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 450, self.view.frame.size.width, 10)];
    [self.view addSubview:self.slider];

   
    self.recorder = [XHSoundRecorder alloc];

    [self.recorder playsound:_audioUrl withFinishPlaying:^{
        
    }];
    _cuttentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 460, 100, 30)];
    
    [self.view addSubview:_cuttentTimeLabel];
    _allTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 460, 100, 30)];
    
    [self.view addSubview:_allTimeLabel];
    
    [self.slider addTarget:self action:@selector(processChanged:) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 460, 200, 200)];
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startplay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    //_allTimeLabel.text = [NSString stringWithFormat:@"%f",self.player.player.duration];
    _allTimeLabel.text = [self getTimeFormat:self.recorder.player.duration];
}
-(void)startplay{
    [self.recorder.player play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.recorder stopPlaysound];
}

-(void)processChanged:(UISlider *)sender{
   [self.recorder.player setCurrentTime:self.slider.value*self.recorder.player.duration];
}
-(void)updateSliderValue
{
    self.slider.value = self.recorder.player.currentTime/self.recorder.player.duration;
    //_cuttentTimeLabel.text = [NSString stringWithFormat:@"%f",self.player.player.currentTime];
    _cuttentTimeLabel.text = [self getTimeFormat:self.recorder.player.currentTime];
    
}

-(NSString *)getTimeFormat:(NSTimeInterval)currentTime{
    
    NSTimeInterval time = currentTime;
    int hour = (int)(time/3600);
    int minute = (int)(time-hour*3600)/60;
    int second = time - hour*3600-minute*60;
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",minute,second];

    return timeStr;
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
