//
//  PF_AddContentTableViewCell.m
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import "PF_AddContentTableViewCell.h"

@implementation PF_AddContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeStateBeOpen:_headModelData.isOpen];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell)];
    
    [self.contentView addGestureRecognizer:tapGesture];
    
    _addbutton.hidden = NO;
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    _centerButton.hidden = YES;

}
- (IBAction)addButtonAction:(id)sender {

    [self changeStateBeOpen:YES];

}
- (IBAction)leftButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCellWithData:afterData:)]) {
        PublishContentModel *addModel = [[PublishContentModel alloc] init];
        addModel.desText = @"这是一个文本内容";
        [self.delegate addCellWithData:addModel afterData:_headModelData];
    }
}
- (IBAction)centerButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCellWithData:afterData:)]) {
        PublishContentModel *addModel = [[PublishContentModel alloc] init];
        addModel.desText = @"这是一个图片内容";
        [self.delegate addCellWithData:addModel afterData:_headModelData];

    }
}
- (IBAction)rightButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCellWithData:afterData:)]) {
        PublishContentModel *addModel = [[PublishContentModel alloc] init];
        addModel.desText = @"这是一个视频内容";
        [self.delegate addCellWithData:addModel afterData:_headModelData];

    }
}


- (void)clickCell
{

    [self changeStateBeOpen:NO];
    
}

- (void)setHeadModelData:(PublishHeaderModel *)headModelData
{
    _headModelData = headModelData;
    
    _addbutton.hidden = _headModelData.isOpen;
    _leftButton.hidden = !_headModelData.isOpen;
    _rightButton.hidden = !_headModelData.isOpen;
    _centerButton.hidden = !_headModelData.isOpen;
}


- (void)changeStateBeOpen:(BOOL)isOpen
{
    
    if (isOpen) {
        _headModelData.cellHeight = 50.0;
        _headModelData.isOpen = YES;


    }else{
        _headModelData.cellHeight = 30.0;
        _headModelData.isOpen = NO;

    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCellWithData:)]) {
        
        [self.delegate refreshCellWithData:_headModelData];
    }else{
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
