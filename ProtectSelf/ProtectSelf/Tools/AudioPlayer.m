//
//  AudioPlayer.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer()

@property (nonatomic, strong)AVAudioPlayer *audioPLayer;

@end

@implementation AudioPlayer

- (AVAudioPlayer *)audioPlayerWithAudioPath:(NSString *)audioPath{
    
    [self stopCurrentAudio];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:audioPath withExtension:@"mp3"];
    if (!url) {
        url = [[NSBundle mainBundle] URLForResource:audioPath withExtension:@"wav"];
    }
    
    self.audioPLayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self.audioPLayer prepareToPlay];
    
    [self.audioPLayer play];
    
    return self.audioPLayer;
}

- (void)resumeCurrentAudio{
    
    [self.audioPLayer play];
}

- (void)pauseCurrentAudio{
    
    [self.audioPLayer pause];
}

- (void)stopCurrentAudio{
    
    [self.audioPLayer stop];
}

- (float)progress{
    
    return self.audioPLayer.currentTime / self.audioPLayer.duration;
}

@end
