//
//  PF_addMusicViewController.h
//  Publish
//
//  Created by JLJ-zyq on 2017/5/19.
//  Copyright © 2017年 FeildWong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PF_AddMusicBlock)(NSString *musicURLString);
@interface PF_addMusicViewController : UIViewController


@property (nonatomic, copy) PF_AddMusicBlock addMusicBlock;


- (id)initWithFinishBlock:(PF_AddMusicBlock)block;

@end
