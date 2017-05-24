//
//  PF_ContentTableViewCell.m
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import "PF_ContentTableViewCell.h"

@implementation PF_ContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataModel:(PublishContentModel *)dataModel
{
    _dataModel = dataModel;
    _contentLabel.text = dataModel.desText;
}

- (IBAction)deleteButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCellWithData:)]) {
        [self.delegate deleteCellWithData:_dataModel];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
