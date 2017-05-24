//
//  ViewController.m
//  Publish
//
//  Created by JLJ-zyq on 2017/5/17.
//  Copyright © 2017年 FeildWong. All rights reserved.
//

#import "ViewController.h"
#import "PF_PublishViewController.h"
#import "PublishAudioViewController.h"
#import "ArticalViewController.h"
#import "PF_PublishVideoViewController.h"
#import "ImagePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *pushButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(0, 64, 200, 40);
    [pushButton setTitle:@"美篇发布" forState:UIControlStateNormal];
    pushButton.backgroundColor = [UIColor orangeColor];
    
    [pushButton addTarget:self action:@selector(jumpToPush) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushButton];
    UIButton *pushButton2  = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton2.frame = CGRectMake(0, 64 + 40, 200, 40);
    [pushButton2 setTitle:@"发布声音" forState:UIControlStateNormal];
    pushButton2.backgroundColor = [UIColor orangeColor];
    
    [pushButton2 addTarget:self action:@selector(jumpToPush2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushButton2];
    
    UIButton *pushButton3  = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton3.frame = CGRectMake(0, 64 + 40 + 40, 200, 40);
    [pushButton3 setTitle:@"简书发布" forState:UIControlStateNormal];
    pushButton3.backgroundColor = [UIColor orangeColor];
    
    [pushButton3 addTarget:self action:@selector(jumpToPush3) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushButton3];
    
    UIButton *pushButton4  = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton4.frame = CGRectMake(0, 64 + 40 + 40 + 40, 200, 40);
    [pushButton4 setTitle:@"视频发布" forState:UIControlStateNormal];
    pushButton4.backgroundColor = [UIColor orangeColor];
    
    [pushButton4 addTarget:self action:@selector(jumpToPush4) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushButton4];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)jumpToPush
{
    //先做选择图片处理，选择完图片  再做跳转
    ImagePickerViewController *imagePick =[[ImagePickerViewController alloc] initWithMaxCount:1 selectedPhotosBlock:^(NSMutableArray *photos) {
        
        [[[ALAssetsLibrary alloc] init] assetForURL:photos[0] resultBlock:^(ALAsset *asset) {
            
            
            
            PF_PublishViewController *pushVC = [[PF_PublishViewController alloc] init];
            
            [self.navigationController pushViewController:pushVC animated:YES];
            
        } failureBlock:^(NSError *error) {
            
        }];
        

        
    }];
    
    [self presentViewController:imagePick animated:YES completion:^{
        
    }];
    

}
- (void)jumpToPush2
{
    PublishAudioViewController *pushVC = [[PublishAudioViewController alloc] init];
    
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)jumpToPush3
{
    ArticalViewController *pushVC = [[ArticalViewController alloc] init];
    
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)jumpToPush4
{
    PF_PublishVideoViewController *publishVideo = [[PF_PublishVideoViewController alloc] init];
    
    [self.navigationController pushViewController:publishVideo animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
