//
//  YHorizontalCell.h
//  HorizontalTableView
//
//  Created by ysk on 16/3/11.
//  Copyright © 2016年 ysk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHorizontalCell : UITableViewCell

@property (nonatomic, strong)  UIView *showHeightView;

-(void)changeHeight:(NSString *)height;

@end
