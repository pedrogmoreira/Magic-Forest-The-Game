//
//  DMTSoundPlayer.h
//  Polonyte Stories
//
//  Created by Marcus Fonseca on 9/29/15.
//  Copyright © 2015 André Rodrigues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/OpenAL.h>
#import "DMTSoundEffect.h"

#define DMTSoundPlayerSourcesCount 50

@interface DMTSoundPlayer : NSObject

// both of these values have a range between 0 and 1, if anything other than that is set, it is ignored
@property (nonatomic) ALfloat musicVolume;
@property (nonatomic) ALfloat fxVolume;

@property (nonatomic) NSArray<DMTSoundEffect *> *sounds;
@property (nonatomic) NSArray<NSString *> *songNames;

/*
// If you would like to pause a sound, you should get its current position
*/

+ (DMTSoundPlayer*)sharedPlayer;

/// Plays a given sound, returns an id (sourceID) that has to be used to stop it, returns 0 if could not play
- (ALuint)playSoundEffect:(DMTSoundEffect *)fx;

/// Starts playing song given the index in the array of songPaths
- (void)playSongIndexed:(NSUInteger)index loops:(bool)loops;

/// Starts playing a song given a path
- (void)playSongWithName:(NSString *)path loops:(bool)loops;

/// Toggles current song (if there is any), returns current playing state
- (bool)toggleCurrentSong;

- (void)stopCurrentSong;

/// Gives reference to a sound with a given name
- (DMTSoundEffect *)soundForFileName:(NSString *)fileName;

/// Stops sound in a given sourceID
- (void)stopSourceID:(ALuint)sourceID;

@end
