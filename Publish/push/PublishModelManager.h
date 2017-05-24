//
//  PublishModelManager.h
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PublishContentModel,PublishHeaderModel,PublishBaseModel;
@interface PublishModelManager : NSObject

@property (nonatomic, strong) NSMutableArray<PublishContentModel *> *publishDataArray;
@property (nonatomic, strong) NSMutableArray<PublishBaseModel *> *showDataArray;

+ (id)shareManager;

//获取展示的数组
+ (NSMutableArray *)getShowDataArray;

//删除一个数据
- (void)delateDataWithIndex:(NSInteger)index;

//添加一个数据
- (void)addDataWithIndex:(NSInteger)index data:(PublishBaseModel *)dataModel;
//修改一个数据
- (void)changeDataWithIndex:(NSInteger)index;

@end



@interface PublishBaseModel : NSObject

@property (nonatomic , assign) float  cellHeight;

@end

/**
 发布，每一条内容的Model
 */
@interface PublishContentModel : PublishBaseModel

/**
 描述的文本
 */
@property (nonatomic, copy) NSString *desText;

/**
 图片的链接
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 视频的链接
 */
@property (nonatomic, copy) NSString *videoUrl;

@end

//头部model
@interface PublishHeaderModel : PublishBaseModel

@property (nonatomic, assign) BOOL isOpen;
/**
 头部的标题
 */
@property (nonatomic, copy) NSString *headerTitle;

/**
 背景音乐
 */
@property (nonatomic, copy) NSString *backMusic;

/**
 封面
 */
@property (nonatomic, copy) NSString *faceImage;

@end
