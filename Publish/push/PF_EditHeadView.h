//
//  PF_EditHeadView.h
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModelManager.h"

@protocol PF_EditHeadDelegate <NSObject>

//修改标题
- (void)headChangeTitle;
//添加背景音乐
- (void)headAddMusic;
//更换封面
- (void)headChangeBgImage;

@end

@interface PF_EditHeadView : UIView

/**
 headView  数据
 */
@property (nonatomic, strong) PublishHeaderModel *dataModel;

@property (nonatomic, weak) id <PF_EditHeadDelegate> delegate;

//背景图片
@property (nonatomic, strong) UIImageView *bgImageView;

//标题
@property (nonatomic, strong) UIButton  *titleButton;

//添加音乐
@property (nonatomic, strong) UIButton *addMusicButton;

//更换封面
@property (nonatomic, strong) UIButton *changeBGButton;



/**
 根据数据刷新页面
 
 @param headModel 更新后的数据
 */
- (void)refreshViewWithData:(PublishHeaderModel *)headModel;


@end
