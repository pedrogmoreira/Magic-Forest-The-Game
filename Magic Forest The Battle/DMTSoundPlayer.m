//
//  DMTSoundPlayer.m
//  Polonyte Stories
//
//  Created by Marcus Fonseca on 9/29/15.
//  Copyright © 2015 André Rodrigues. All rights reserved.
//

#import "DMTSoundFileNames.h"
#import "DMTSoundPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation DMTSoundPlayer {
	ALuint _sources[DMTSoundPlayerSourcesCount];
	NSDictionary<NSString *, AVAudioPlayer *> *_players;
	AVAudioPlayer *_currentSong;
}

static DMTSoundPlayer *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedPlayer];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedPlayer];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedPlayer];
}

- (id)copy
{
    return [[DMTSoundPlayer alloc] init];
}

- (id)mutableCopy
{
    return [[DMTSoundPlayer alloc] init];
}

- (id)init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
	if (self = [super init]) {
		alcMakeContextCurrent(alcCreateContext(alcOpenDevice(NULL), NULL));
		_musicVolume = 1.0f;
		_fxVolume = 1.0f;
		[self loadAllFXs];
		[self loadAllSongs];
		[self loadBuffers];
	}
    return self;
}

- (void)loadAllFXs {
	NSMutableArray *array;
	array = [NSMutableArray array];
	
	[array addObject:[DMTSoundEffect soundEffectWithFileName:DMTSoundFileNameExample1 andFileType:DMTSoundFileNameExample1Type loops:false]];
	
	[array addObject:[DMTSoundEffect soundEffectWithFileName:DMTSoundFileNameExample2 andFileType:DMTSoundFileNameExample2Type loops:false]];
	
	[array addObject:[DMTSoundEffect soundEffectWithFileName:DMTSoundFileNameExample3 andFileType:DMTSoundFileNameExample3Type loops:true]];
	
	[array addObject:[DMTSoundEffect soundEffectWithFileName:DMTSoundFileNameExample4 andFileType:DMTSoundFileNameExample4Type loops:false]];
	
	_sounds = [NSArray arrayWithArray:array];
	
}

- (void)loadAllSongs {
	NSBundle *bundle;
	bundle = [NSBundle mainBundle];
	
	_songNames = @[DMTSoundFileNameSongExample1,
				   DMTSoundFileNameSongExample2];
	NSArray *extensions = @[DMTSoundFileNameSongExample1Type,
							DMTSoundFileNameSongExample2Type];
	NSMutableArray *array;
	AVAudioPlayer *player;
	NSMutableDictionary *dict;
	dict = [NSMutableDictionary dictionary];
	NSError *error;
	array = [NSMutableArray arrayWithCapacity:_songNames.count];
	for (int i = 0; i < _songNames.count; i++) {
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:[bundle URLForResource:_songNames[i] withExtension:extensions[i]] error:&error];
		[player prepareToPlay];
		[dict setObject:player forKey:_songNames[i]];
		if (error) {
			NSLog(@"Could not load audio file %@", error);
		}
	}
	
	_currentSong = nil;
	_players = [NSDictionary dictionaryWithDictionary:dict];
	
}

- (void)loadBuffers {
	alGenSources(DMTSoundPlayerSourcesCount, _sources);
}

- (ALuint)playSoundEffect:(DMTSoundEffect *)sound {
	if (sound == nil) {
		NSLog(@"Error on DMTSoundPlayer, trying to play nil sound");
		return AL_NONE;
	}
	
	ALuint source = [self nextSource];
	
	alSourcef(source, AL_PITCH, sound.pitch);
	alSourcef(source, AL_GAIN, _fxVolume);
	
	ALuint buffer = sound.bufferID;
	
	alSourcei(source, AL_LOOPING, sound.loops ? AL_TRUE : AL_FALSE);
	
	alSourcei(source, AL_BUFFER, buffer);
	
	alSourcePlay(source);
	return source;
}

- (ALuint)nextSource {
	ALint sourceState;
	ALuint sourceID;
	for (int i = 0; i < DMTSoundPlayerSourcesCount; i++) {
		sourceID = _sources[i];
		alGetSourcei(sourceID, AL_SOURCE_STATE, &sourceState);
		if (sourceID && sourceState != AL_PLAYING) {
			return sourceID;
		}
	}
	sourceID = _sources[0];
	alSourceStop(sourceID);
	return sourceID;
}

- (void)updateFxVolumes:(ALfloat)newVolume {
	ALint sourceState;
	ALuint sourceID;
	for (int i = 0; i < DMTSoundPlayerSourcesCount; i++) {
		sourceID = _sources[i];
		alGetSourcei(sourceID, AL_SOURCE_STATE, &sourceState);
		if (sourceID && sourceState == AL_PLAYING) {
			alSourcef(sourceID, AL_GAIN, _fxVolume);
		}
	}
}

- (void)stopSourceID:(ALuint)sourceID {
	alSourceStop(sourceID);
}

- (void)setMusicVolume:(ALfloat)musicVolume {
	_musicVolume = MIN(MAX(musicVolume, 0), 1);
	if (_currentSong) {
		[_currentSong setVolume:_musicVolume];
	}
}

- (void)setFxVolume:(ALfloat)fxVolume {
	_fxVolume = MIN(MAX(fxVolume, 0), 1);
	[self updateFxVolumes:_fxVolume];
}

- (DMTSoundEffect *)soundForFileName:(NSString *)fileName {
	for (DMTSoundEffect *sound in _sounds) {
		if ([sound.fileName isEqualToString:fileName]) {
			return sound;
		}
	}
	return nil; // found no sound
}

- (void)playSongIndexed:(NSUInteger)index loops:(bool)loops {
	return [self playSongWithName:self.songNames[index] loops:loops];
}

- (void)playSongWithName:(NSString *)name loops:(bool)loops {
	AVAudioPlayer *player;
	player = _players[name];
	if (player) {
		if (player != _currentSong) {
			[_currentSong pause];
			[_currentSong setCurrentTime:0];
			_currentSong = player;
			_currentSong.volume = self.musicVolume;
			[_currentSong play];
		}
	}
}

- (bool)toggleCurrentSong {
	if (_currentSong) {
		bool state;
		state = _currentSong.playing;
		if (state) {
			[_currentSong pause];
		} else {
			[_currentSong play];
		}
		return state;
	}
	return false;
}

- (void)stopCurrentSong {
	[_currentSong pause];
	[_currentSong setCurrentTime:0];
	_currentSong = nil;
}

- (void)dealloc {
	alDeleteSources(DMTSoundPlayerSourcesCount, _sources);
}

@end
