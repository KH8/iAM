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

@end

@interface AMSequencer : NSObject <AMStaveMechanicalDelegate, AMSequenceDelegate>

@property (nonatomic, weak) id <AMSequencerDelegate> sequencerDelegate;

- (id)init;
- (void)killBackgroundThread;

- (void)startStop;
- (BOOL)isRunning;
- (void)clear;

- (AMStave *)getStave;
- (AMSequence *)getSequence;

@end