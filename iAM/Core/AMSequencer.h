//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"

@protocol AMSequencerDelegate <NSObject>

@required

- (void) sequenceHasStarted;
- (void) sequenceHasStopped;

@end

@interface AMSequencer : NSObject

@property (nonatomic, weak) id <AMSequencerDelegate> sequencerDelegate;

@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

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