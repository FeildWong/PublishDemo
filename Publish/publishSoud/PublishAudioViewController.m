//
//  PublishAudioViewController.m
//  BZW
//
//  Created by 加联加信息技术有限公司 on 17/4/24.
//  Copyright © 2017年 Kaka. All rights reserved.
//

#import "PublishAudioViewController.h"
#import "TailoringAudioViewController.h"
#import "AuditionViewController.h"
#import "XHSoundRecorder.h"
#import "YHorizontalTableView.h"
#import "AddMusicViewController.h"


#define GetImage(imageName)  [UIImage imageNamed:imageName]

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height


@interface PublishAudioViewController ()<YHorizontalTableViewDelegate,YHorizontalTableViewDataSource>

@property(nonatomic,strong)YHorizontalTableView * tableView;

@property (nonatomic,retain) NSMutableArray *numberArray;

//@property(strong, nonatomic)JYZRecorder * recorderJIa;
@property (strong,nonatomic) NSString *filepath;
@property (nonatomic,strong) UIImageView *yinliang;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) XHSoundRecorder *recorderJIa;
@property (nonatomic,strong) UIView *backMusic;


@end

@implementation PublishAudioViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"录音";
    [self CreatSubView];
    _recorderJIa = [XHSoundRecorder alloc];
      __weak typeof(self)weakSelf = self;
    _recorderJIa.timeRusult = ^(NSString *time){
      
        weakSelf.timeLabel.text = time;
        NSLog(@"%@",time);
    };
    _recorderJIa.imageRusult = ^(NSString *image,NSString *fenbei){
        [weakSelf.numberArray addObject:fenbei];
        NSLog(@"%@",fenbei);
        [weakSelf.tableView reloadData];
        [weakSelf scrollToTableBottom];
       [weakSelf.yinliang setImage:GetImage(image)];
       
    };
}
-(void)CreatSubView{
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [moreButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreButton];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight/3)];
    headerView.backgroundColor = [UIColor blackColor];
    UIImageView *RECView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 20)];
    [headerView addSubview:RECView];
    UILabel *FMLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, 5, 100,20)];
    FMLabel.text = @"滨州网FM";
    FMLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:116/255.0 alpha:1];
    [headerView addSubview:FMLabel];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(headerView.frame)/2-50, 25, 100, 50)];
    self.timeLabel = timeLabel;
    [headerView addSubview:timeLabel];
//    [[JLJTools shareInstance]setView:headerView BoaderWithWidth:0 radius:5 coloc:[UIColor clearColor] andToBounds:YES];
    
    headerView.layer.borderWidth = 0;
    headerView.layer.cornerRadius = 5;
    headerView.clipsToBounds = YES;
    
    
    timeLabel.text = @"00:00";
    timeLabel.font = [UIFont systemFontOfSize:35];
    timeLabel.textColor =[UIColor colorWithRed:114/255.0 green:114/255.0 blue:116/255.0 alpha:1];
    [headerView addSubview:timeLabel];
    UIImageView *yinliang = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame), kScreenWidth/3, 64)];
    [yinliang setImage:GetImage(@"toast_vol_1")];
    self.yinliang = yinliang;
    [headerView addSubview:yinliang];
        UIImageView *yinyue = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/3-10 , CGRectGetMaxY(timeLabel.frame), kScreenWidth/3, 20)];
    [headerView addSubview:yinyue];
    
    self.numberArray = [[NSMutableArray alloc]init];
    self.tableView = [[YHorizontalTableView alloc]init];

    self.tableView.frame = CGRectMake(10 , CGRectGetMaxY(yinliang.frame)+5, kScreenWidth-40, 100);
//    [self.tableView setContentOffset:CGPointMake(300,300) animated:NO];
    self.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    [headerView addSubview:self.tableView];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.delegate_Y = self;
    self.tableView.dataSource_Y = self;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[YHorizontalCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIButton *addMusic = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame)+20, kScreenWidth-20, 50)];
//    [[JLJTools shareInstance]setView:addMusic BoaderWithWidth:0 radius:5 coloc:[UIColor clearColor] andToBounds:YES];
    addMusic.layer.borderWidth = 0;
    addMusic.layer.cornerRadius = 5;
    addMusic.clipsToBounds = YES;
    
    addMusic.backgroundColor = [UIColor colorWithRed:52/255.0 green:53/255.0 blue:55/255.0 alpha:1];
    [addMusic setTitle:@"添加配乐" forState:UIControlStateNormal];
    [addMusic setTitleColor:[UIColor colorWithRed:114/255.0 green:114/255.0 blue:116/255.0 alpha:1] forState:UIControlStateNormal];
    [addMusic addTarget:self action:@selector(addMusic:) forControlEvents:UIControlEventTouchUpInside];
    
    _backMusic = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame)+20, kScreenWidth-20, 80)];
    _backMusic.hidden = YES;
    _backMusic.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:57/255.0 alpha:1];
    UIButton *kaiguanButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 20)];
    [kaiguanButton setImage:[UIImage imageNamed:@"audio_bgMusicClose"] forState:UIControlStateNormal];
    [kaiguanButton setImage:[UIImage imageNamed:@"audio_bgMusicOpen"] forState:UIControlStateSelected];
    
    [kaiguanButton addTarget:self action:@selector(playbackMusic:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, 10,80, 20)];
    changeButton.backgroundColor = [UIColor colorWithRed:62/255.0 green:62/255.0 blue:63/255.0 alpha:1];
    [changeButton setTitle:@"更换配乐" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1] forState:UIControlStateNormal];
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(40, 55, kScreenWidth-100, 10)];
    [_backMusic addSubview:kaiguanButton];
    [_backMusic addSubview:changeButton];
    [_backMusic addSubview:slider];
//    [[JLJTools shareInstance]setView:_backMusic BoaderWithWidth:1 radius:5 coloc:[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1] andToBounds:YES];
    _backMusic.layer.borderWidth = 1.0;
    _backMusic.layer.cornerRadius =5;
    _backMusic.layer.borderColor =[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1].CGColor;
    
    _backMusic.clipsToBounds = YES;
    
    
    UIImageView *tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-100, CGRectGetMaxY(addMusic.frame)+20, 200, 30)];
    
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, CGRectGetMaxY(tipImage.frame)+20, 80, 80)];
    [startButton setImage:[UIImage imageNamed:@"audio_luzhi1"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"audio_luzhi2"] forState:UIControlStateSelected];
    
    [startButton addTarget:self action:@selector(startRecorder:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75, CGRectGetMaxY(startButton.frame)+10, 150, 50)];
    tipLabel.text=@"最长90分钟录制哦";
    tipLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:116/255.0 alpha:1];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight-150, kScreenWidth, 100)];
    
    NSArray *imageArray = @[@"audio_audiition",@"audio_chonglu",@"audio_tailoring",@"audio_save"];
    NSArray *nameArray = @[@"试听",@"重录",@"裁剪",@"保存"];
    for (int i= 0; i<4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/5, 80)];
        [button setImage:[UIImage imageNamed: imageArray[i]] forState:UIControlStateNormal];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:93/255.0 green:94/255.0 blue:95/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        button.imageEdgeInsets = UIEdgeInsetsMake(-55,0,0,-63);
    }
    
    [self.view addSubview:bottomView];
    [self.view addSubview:headerView];
    [self.view addSubview:addMusic];
    [self.view addSubview:tipImage];
    [self.view addSubview:startButton];
    [self.view addSubview:tipLabel];
    [self.view addSubview:_backMusic];
    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1];
    
}
-(void)moreButtonclick{
    //AddMusicViewController *vc = [[AddMusicViewController alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];


}

- (NSInteger)h_tableView:(YHorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberArray.count;
}

- (YHorizontalCell *)h_tableView:(YHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHorizontalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YHorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
//    cell.backgroundColor = [UIColor clearColor];
    [cell changeHeight:_numberArray[indexPath.row]];

    
    return cell;
}
- (void)scrollToTableBottom
{

    NSInteger lastRow = self.numberArray.count - 1;

    if (lastRow < (kScreenWidth-20)/5){
        
        
        [self.tableView setContentOffset:CGPointMake(0, -(kScreenWidth - lastRow * 5-20)) animated:NO];
        
        return;

    }
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)addMusic:(UIButton *)sender{
    sender.hidden = YES;
    _backMusic.hidden  = NO;
    
}
-(void)playbackMusic:(UIButton *)sender{
   
    if (sender.selected == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
        [_recorderJIa playsound:path withFinishPlaying:^{
            
        }];
    }else{
    
        [_recorderJIa stopPlaysound];
    }
    
    sender.selected = !sender.selected;

}
-(void)buttonclick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            [_recorderJIa stopRecorder];
            
            AuditionViewController *vc = [[AuditionViewController alloc]init];
            vc.audioUrl = _filepath;
            vc.numerArray = _numberArray;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 102:{
            [_recorderJIa stopRecorder];
            TailoringAudioViewController *vc = [[TailoringAudioViewController alloc]init];
            vc.audioUrl = _filepath;
            vc.numerArray = _numberArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
        default:
            break;
    }
}

-(void)startRecorder:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
            
            NSLog(@"录音文件路径:%@",filePath);
            
            NSLog(@"录音结束");
            _filepath = filePath;
            //[wSelf.filePaths addObject:filePath];
            
            //wSelf.file = filePath;
        }];
    }else{
        [[XHSoundRecorder sharedSoundRecorder]stopRecorder];
        [_recorderJIa stopPlaysound];

    }

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
