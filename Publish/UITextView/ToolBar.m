//
//  ToolBar.m
//  XTextView
//
//  Created by 张迎秋 on 2017/5/13.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "ToolBar.h"

@interface ToolBar ()
{
    NSInteger _buttonCount; //按钮个数
    NSArray * _btImgArray; //图片数组
}

@end

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame btImgArray:(NSArray<NSString *> *) btImgArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _buttonCount = btImgArray.count;
        _btImgArray = btImgArray;
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    CGFloat topMargin = 10;
    CGFloat btHeight = self.frame.size.height-topMargin*2;
    CGFloat btWidth = btHeight;
    CGFloat rowMargin = (self.frame.size.width - _buttonCount*btWidth)/(_buttonCount+1);
    for (int i=0; i<_buttonCount; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(rowMargin + i*(btWidth+rowMargin), topMargin, btWidth, btHeight)];
        button.tag = i+666;
        button.backgroundColor = [UIColor redColor];
        [button setBackgroundImage:[UIImage imageNamed:_btImgArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}

- (void)buttonAction:(UIButton *) button{
    if (self.toolBarButtonClickBlock) {
        self.toolBarButtonClickBlock(button.tag-666);
    }
}


@end
