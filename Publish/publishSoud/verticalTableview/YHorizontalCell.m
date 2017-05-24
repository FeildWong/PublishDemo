//
//  YHorizontalCell.m
//  HorizontalTableView
//
//  Created by ysk on 16/3/11.
//  Copyright © 2016年 ysk. All rights reserved.
//

#import "YHorizontalCell.h"

@implementation YHorizontalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        _showHeightView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_showHeightView];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        _showHeightView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_showHeightView];

    }
    return self;
}

-(void)creatSubView{
}
-(void)changeHeight:(NSString *)height{
    CGFloat heights = [height floatValue];
    NSLog(@"%@",height);
    _showHeightView.frame =  CGRectMake(1,100-heights, 3, heights);
    _showHeightView.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];

}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
