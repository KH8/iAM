//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMPlayer : NSObject

- (id)initWithFile:(NSString *)aFileName
            andKey:(NSString *)aFileKey
            ofType:(NSString *)aFileType;

- (void)playSound;

- (void)stopSound;

- (void)setSoundName:(NSString *)newName
             withKey:(NSString *)newKey;

- (NSString *)getSoundName;

- (NSString *)getSoundKey;

- (void)setGeneralVolumeFactor:(NSNumber *)volume;

- (NSNumber *)getGeneralVolumeFactor;

- (void)setVolumeFactor:(NSNumber *)volume;

- (NSNumber *)getVolumeFactor;

- (void)setPanFactor:(NSNumber *)pan;

- (NSNumber *)getPanFactor;

@end