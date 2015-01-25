//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@protocol AMSequenceDelegate <NSObject>

@required

- (void) sequenceHasStarted;
- (void) sequenceHasStopped;
- (void) rowHasBeenTriggered: (NSInteger)row
                   inSection: (NSInteger)section;

@end

@interface AMSequence : NSObject

@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

- (void) addDelegate: (id<AMSequenceDelegate>) delegate;
- (void) removeDelegate: (id<AMSequenceDelegate>) delegate;

- (id)init;
- (void)killBackgroundThread;

- (void)startStop;
- (bool)isRunning;
- (void)clear;

- (NSInteger)getNumberOfLines;
- (NSMutableArray *)getLine: (NSUInteger)index;
- (void)setLengthToBePlayed: (NSInteger)aLength;
- (NSInteger)getLengthToBePlayed;
- (void)setTempo: (NSInteger)aTempo;
- (NSInteger)getTempo;

@end