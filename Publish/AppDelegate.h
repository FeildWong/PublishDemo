//
//  AppDelegate.h
//  Publish
//
//  Created by JLJ-zyq on 2017/5/17.
//  Copyright © 2017年 FeildWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

