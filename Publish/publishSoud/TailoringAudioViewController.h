//
//  TailoringAudioViewController.h
//  BZW
//
//  Created by 加联加信息技术有限公司 on 17/5/8.
//  Copyright © 2017年 Kaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>
typedef void(^success)(BOOL ret);
@interface TailoringAudioViewController : UIViewController

@property (nonatomic, copy)success block;
@property (nonatomic,retain) NSString *audioUrl;

@property (nonatomic,retain) NSArray *numerArray;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) SystemSoundID soundID;



//@property (nonatomic, copy)success ^block;



// 支持音频:m4a  视频:mp4

- (void)exportPath:(NSString *)exportPath

      withFilePath:(NSString *)filePath

     withStartTime:(CMTimeValue)startTime

       withEndTime:(CMTimeValue)endTime

         withBlock:(success)handle;

@property (nonatomic, copy) NSString *wavPath;

@property (nonatomic, copy) NSString *mp3Path;

@end
