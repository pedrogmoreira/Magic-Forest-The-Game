//
//  DMTSoundEffect.m
//  Polonyte Stories
//
//  Created by Marcus Fonseca on 11/6/15.
//  Copyright © 2015 André Rodrigues. All rights reserved.
//

#import "DMTSoundEffect.h"

@implementation DMTSoundEffect

+ (instancetype)soundEffectWithFileName:(NSString *)fileName andFileType:(NSString *)fileType {
	return [[self alloc] initWithFileName:fileName andFileType:fileType];
}

+ (instancetype)soundEffectWithFileName:(NSString *)fileName andFileType:(NSString *)fileType loops:(bool)loops {
	DMTSoundEffect *sound = [DMTSoundEffect soundEffectWithFileName:fileName andFileType:fileType];
	sound.loops = loops;
	return sound;
}

- (instancetype)initWithFileName:(NSString *)fileName andFileType:(NSString *)fileType {
	if (self = [super init]) {
		_fileName = fileName;
		ALsizei dataSize = 0;
		ALenum dataFormat = 0;
		ALsizei sampleRate = 0;
		ALuint bufferID = 0;
		void *pcmData = NULL;
		NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:fileType];
		
		pcmData = alLoadAudioData(path, &dataSize, &dataFormat, &sampleRate);
		
		alGenBuffers(1, &bufferID);
		alBufferData(bufferID, dataFormat, pcmData, dataSize, sampleRate);
		
		_bufferID = bufferID;
		
		_loops = false;
		
		if (pcmData) {
			free(pcmData);
			pcmData = NULL;
		}
		
		_pitch = 1.0f;
		_frequency = sampleRate;
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if ([object class] == [self class]) {
		DMTSoundEffect *obj = (DMTSoundEffect *)object;
		return [self.fileName isEqualToString:obj.fileName];
	} else {
		return [super isEqual:object];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"fileName: %@, bufferID: %d", self.fileName, self.bufferID];
}

- (void)dealloc {
	ALuint bufferID = self.bufferID;
	
	alDeleteBuffers(1, &bufferID);
	
	if (alGetError() == AL_INVALID_OPERATION) {
		NSLog(@"Invalid operation when deallocing buffer for sound: %@", self);
	}
}




/*
 THIS FUNCTION LOADS ALL THE DATA FOR USING OPEN AL, DONT MESS AROUND WITH IT!!!!!!
*/


void* alLoadAudioData(NSString *filePath, ALsizei *outputDataSize, ALenum *outputDataFormat, ALsizei *outputSampleRate) {
	
	CFStringRef cfPath = (__bridge CFStringRef)filePath;
	CFURLRef cfFileUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, cfPath, kCFURLPOSIXPathStyle, false);
	
	OSStatus err = noErr;
	SInt64 theFileLengthInFrames = 0;
	AudioStreamBasicDescription theFileFormat;
	UInt32 thePropertySize = sizeof(theFileFormat);
	ExtAudioFileRef extRef = NULL;
	void *theData = NULL;
	AudioStreamBasicDescription theOutputFormat;
	
	
	//Open file
	err = ExtAudioFileOpenURL(cfFileUrl, &extRef);
	if(err) {
		NSLog(@"Error 00");
	}
	
	//Get audio format
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
	if(err) {
		NSLog(@"Error 01");
		goto Exit;
	}
	if(theFileFormat.mChannelsPerFrame > 2) {
		NSLog(@"Error 02");
		goto Exit;
	}
	
	//Set the client format
	theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
	theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
	
	theOutputFormat.mFormatID = kAudioFormatLinearPCM;
	theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mFramesPerPacket = 1;
	theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mBitsPerChannel = 16;
	theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	//Set the desired client data format
	err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
	if(err) {
		NSLog(@"Error 03");
		goto Exit;
	}
	
	//Get the total frame count
	thePropertySize = sizeof(theFileLengthInFrames);
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
	if(err) {
		NSLog(@"Erorr 05");
		goto Exit;
	}
	
	//Read all the data into memory
	UInt32 dataSize = (UInt32)theFileLengthInFrames * theOutputFormat.mBytesPerFrame;
	theData = malloc(dataSize);
	if(theData) {
		AudioBufferList theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		//Read the data into an AudioBufferList
		err = ExtAudioFileRead(extRef, (UInt32 *)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr) {
			//Success
			*outputDataSize = (ALsizei)dataSize;
			*outputDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outputSampleRate = (ALsizei)theOutputFormat.mSampleRate;
		}
		else {
			NSLog(@"Error 04");
			//failure
			free(theData);
			theData = NULL;
		}
	}
	
Exit:
	if(extRef) ExtAudioFileDispose(extRef);
	//    if(cfPath) CFRelease(cfPath);
	if(cfFileUrl) CFRelease(cfFileUrl);
	
	return theData;
}

@end
