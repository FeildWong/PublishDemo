//
//  PF_ContentTableViewCell.h
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModelManager.h"

@protocol PF_ContentCellDelegate <NSObject>

- (void)deleteCellWithData:(PublishBaseModel *)dataModel;

@end

@interface PF_ContentTableViewCell : UITableViewCell

@property (nonatomic, strong) PublishContentModel *dataModel;
@property (nonatomic, assign) id<PF_ContentCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
