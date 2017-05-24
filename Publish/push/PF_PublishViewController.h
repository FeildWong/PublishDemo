//
//  PF_PublishViewController.h
//  PushArtical
//
//  Created by Feild Wong on 2017/5/11.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PF_PublishViewController : UIViewController


//数据模型列表
@property (nonatomic, strong) NSMutableArray *dataModelArray;


- (id)initWithPhoto:(UIImage *)imageUrl;


@end
