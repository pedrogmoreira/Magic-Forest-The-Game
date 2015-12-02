//
//  DMTSoundEffect.h
//  Polonyte Stories
//
//  Created by Marcus Fonseca on 11/6/15.
//  Copyright © 2015 André Rodrigues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/OpenAL.h>
#import <AVFoundation/AVFoundation.h>

@interface DMTSoundEffect : NSObject

@property (nonatomic) ALuint bufferID;

@property (nonatomic) ALfloat pitch;
@property (nonatomic) ALsizei frequency;
@property (nonatomic) bool loops;

@property (nonatomic, readonly) NSString *fileName;

- (instancetype)initWithFileName:(NSString *)fileName andFileType:(NSString *)fileType;
+ (instancetype)soundEffectWithFileName:(NSString *)fileName andFileType:(NSString *)fileType;
+ (instancetype)soundEffectWithFileName:(NSString *)fileName andFileType:(NSString *)fileType loops:(bool)loops;

@end

/// Loads all audio data in a buffer given a file, data size, output data format and sample rate
void* alLoadAudioData(NSString *filePath, ALsizei *outputDataSize, ALenum *outputDataFormat, ALsizei *outputSampleRate);
