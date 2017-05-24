//
//  PF_AddContentTableViewCell.h
//  PushArtical
//
//  Created by Feild Wong on 2017/5/15.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModelManager.h"

@protocol PF_AddContentCellDelegate <NSObject>

- (void)refreshCellWithData:(PublishBaseModel *)dataModel;

- (void)addCellWithData:(PublishBaseModel *)dataModel afterData:(PublishBaseModel *)data;

@end

@interface PF_AddContentTableViewCell : UITableViewCell

@property (nonatomic, strong) PublishHeaderModel *headModelData;
@property (nonatomic, assign) id<PF_AddContentCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *addbutton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
