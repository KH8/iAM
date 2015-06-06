//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"
#import "AMStave.h"
#import "AMSequence.h"

@protocol AMSequencerDelegate <NSObject>

@required

- (void)sequenceHasStarted;

- (void)sequenceHasStopped;

- (void)sequenceHasChanged;

@end

@interface AMSequencer : NSObject <AMStaveDelegate, AMBarDelegate>

- (void)addSequencerDelegate:(id <AMSequencerDelegate>)delegate;

- (void)removeSequencerDelegate:(id <AMSequencerDelegate>)delegate;

- (id)init;

- (void)killBackgroundThread;

- (void)startStop;

- (BOOL)isRunning;

- (void)clear;

- (void)setSequence:(AMSequence *)newSequence;

- (AMSequence *)getSequence;

- (NSArray *)getArrayOfPlayers;

@end