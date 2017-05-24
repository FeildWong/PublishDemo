//
//  AddMusicViewController.m
//  BZW
//
//  Created by 加联加信息技术有限公司 on 17/5/15.
//  Copyright © 2017年 Kaka. All rights reserved.
//

#import "AddMusicViewController.h"

@interface AddMusicViewController ()

@end

@implementation AddMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加配乐";
    [self creatSubView];
}
-(void)creatSubView{
    //1.获得音效文件的全路径
    
//    NSURL *url=[[NSBundle mainBundle]URLForResource:@"lovest.wav" withExtension:nil];
//
//    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
//    SystemSoundID soundID=0;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
//    
//    //把需要销毁的音效文件的ID传递给它既可销毁
//    //AudioServicesDisposeSystemSoundID(soundID);
//    
//    //3.播放音效文件
//    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
//    AudioServicesPlayAlertSound(soundID);
//    //AudioServicesPlaySystemSound(<#SystemSoundID inSystemSoundID#>)

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
