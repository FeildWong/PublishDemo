//
//  PublishModelManager.m
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import "PublishModelManager.h"

@implementation PublishModelManager

+ (id)shareManager
{
    static PublishModelManager *modelManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelManager = [[PublishModelManager alloc] init];
        modelManager.showDataArray = [NSMutableArray array];

    });
    
    return modelManager;
}


/**
 获取展示数组

 @return 需要展示的数组
 */
+ (NSMutableArray *)getShowDataArray
{
    
    PublishModelManager *modelManager = [PublishModelManager shareManager];
    
    if (modelManager.showDataArray.count == 0) {
        PublishHeaderModel *headerModelData = [[PublishHeaderModel alloc] init];
        headerModelData.cellHeight = 30;
        headerModelData.isOpen = NO;
        [modelManager.showDataArray addObject:headerModelData];
    }
    
    return modelManager.showDataArray;
}

- (void)delateDataWithIndex:(NSInteger)index
{
    //删除当前数据
    [self.showDataArray removeObjectAtIndex:index];
    //删除当前数据的后一个数据
    [self.showDataArray removeObjectAtIndex:index];

}

- (void)addDataWithIndex:(NSInteger)index data:(PublishBaseModel *)dataModel
{
//    添加一次数据，自动添加一个add Model
    [self.showDataArray insertObject:dataModel atIndex:index];
    [self.showDataArray insertObject:[[PublishHeaderModel alloc] init] atIndex:index + 1];
}

- (void)changeDataWithIndex:(NSInteger)index
{
    
}

@end

/**
 实现 发布 base类
 */
@implementation PublishBaseModel


@end

/**
 头部数据模型
 */
@implementation PublishHeaderModel

- (id)init
{
    self = [super init];
    self.cellHeight = 30;
    return self;
}

@end

/**
 内容数据模型
 */
@implementation PublishContentModel

- (id)init
{
    self = [super init];
    self.cellHeight = 80;
    return self;
}

@end
