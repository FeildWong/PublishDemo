//
//  PF_EditHeadView.m
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import "PF_EditHeadView.h"

@implementation PF_EditHeadView

- (id)init
{
    self = [super init];
    [self initSubViews];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initSubViews];
    return self;
}

- (void)initSubViews
{
    self.clipsToBounds = YES;
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bgImageView];
    
    //添加title展示的feild
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(10, 10, self.frame.size.width -20, 30);
    [_titleButton setTitle:@"编辑标题" forState:UIControlStateNormal];
    _titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_titleButton addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleButton];
    
    //添加背景音乐的按钮
    _addMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addMusicButton.frame = CGRectMake(10, self.frame.size.height - 40, 80, 30);
    [_addMusicButton setTitle:@"添加背景音乐" forState:UIControlStateNormal];
    _addMusicButton.titleLabel.font = [UIFont systemFontOfSize:12];

    [_addMusicButton addTarget:self action:@selector(musicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addMusicButton];
    
    //添加封面更换的按钮
    _changeBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBGButton.frame = CGRectMake(self.frame.size.width - 90, self.frame.size.height - 40, 80, 30);
    [_changeBGButton setTitle:@"更换封面" forState:UIControlStateNormal];
    _changeBGButton.titleLabel.font = [UIFont systemFontOfSize:12];

    [_changeBGButton addTarget:self action:@selector(bgImageViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeBGButton];
    
}

/**
 点击标题
 */
- (void)titleButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headChangeTitle)]) {
        
        [self.delegate headChangeTitle];
    }
}

/**
 点击更换背景音乐
 */
- (void)musicButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headAddMusic)]) {
        
        [self.delegate headAddMusic];
    }
}

/**
 点击更换背景图片
 */
- (void)bgImageViewButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headChangeBgImage)]) {
        
        [self.delegate headChangeBgImage];
    }
}



/**
 刷新视图，根据dataModel
 */
- (void)layoutSubviews
{
    [_bgImageView setImage:[UIImage imageNamed:@"bgImageForHeader"]];
}

/**
 根据数据刷新页面

 @param headModel 更新后的数据
 */
- (void)refreshViewWithData:(PublishHeaderModel *)headModel
{
    _dataModel = headModel;
    
    
    
}


@end
