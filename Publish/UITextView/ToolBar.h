//
//  ToolBar.h
//  XTextView
//
//  Created by 张迎秋 on 2017/5/13.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolBar : UIView

- (instancetype)initWithFrame:(CGRect)frame btImgArray:(NSArray<NSString *> *) btImgArray;

@property (nonatomic,copy) void(^toolBarButtonClickBlock) (long btTag);

@end
