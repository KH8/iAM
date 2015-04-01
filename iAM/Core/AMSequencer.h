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
- (void) sequenceHasChanged;

@end

@interface AMSequencer : NSObject <AMStaveDelegate, AMMutableArrayDelegate>

@property (nonatomic, weak) id <AMSequencerDelegate> sequencerDelegate;

- (id)init;
- (void)killBackgroundThread;

- (void)startStop;
- (BOOL)isRunning;
- (void)clear;

- (AMStave *)getStave;

- (void)setSequence:(AMSequence *)newSequence;
- (AMSequence *)getSequence;

@end