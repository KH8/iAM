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

- (void) sequenceHasStarted;
- (void) sequenceHasStopped;
- (void) stepHasBeenChanged;

@end

@protocol AMSequencerSyncDelegate <NSObject>

@required

- (void) stepParametersHaveBeenChanged;

@end

@interface AMSequencer : NSObject <AMStaveMechanicalDelegate, AMSequenceDelegate>

@property (nonatomic, weak) id <AMSequencerDelegate> sequencerDelegate;
@property (nonatomic, weak) id <AMSequencerSyncDelegate> sequencerSyncDelegate;

- (id)init;
- (void)killBackgroundThread;

- (void)startStop;
- (BOOL)isRunning;
- (void)clear;

- (AMStave *)getStave;
- (void)setSequence:(AMSequence *)newSequence;
- (AMSequence *)getSequence;

- (void)syncronizeParameters;

@end