//
//  AudioPlayer.h
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

- (AVAudioPlayer *)audioPlayerWithAudioPath:(NSString *)audioPath;

- (void)resumeCurrentAudio;

- (void)pauseCurrentAudio;

- (void)stopCurrentAudio;

@end
