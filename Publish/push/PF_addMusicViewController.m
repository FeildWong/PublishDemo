//
//  PF_addMusicViewController.m
//  Publish
//
//  Created by JLJ-zyq on 2017/5/19.
//  Copyright © 2017年 FeildWong. All rights reserved.
//

#import "PF_addMusicViewController.h"

@interface PF_addMusicViewController ()

@end

@implementation PF_addMusicViewController

- (id)initWithFinishBlock:(PF_AddMusicBlock)block
{
    self = [super init];
    self.addMusicBlock = block;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //上传成功之后  返回数据
    self.addMusicBlock(@"hello");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
