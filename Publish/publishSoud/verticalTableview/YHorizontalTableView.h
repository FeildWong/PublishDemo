//
//  YHorizontalTableView.h
//  HorizontalTableView
//
//  Created by ysk on 16/3/11.
//  Copyright © 2016年 ysk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHorizontalTableViewDelegate.h"
#import "YHorizontalCell.h"

@interface YHorizontalTableView : UITableView

@property (nonatomic, weak, nullable) id <YHorizontalTableViewDataSource> dataSource_Y;
@property (nonatomic, weak, nullable) id <YHorizontalTableViewDelegate> delegate_Y;

@end
