//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"
#import "AMStave.h"

@protocol AMSequencerDelegate <NSObject>

@required

- (void) sequenceHasStarted;
- (void) sequenceHasStopped;

@end

@interface AMSequencer : NSObject <AMStaveDelegate>

@property (nonatomic, weak) id <AMSequencerDelegate> sequencerDelegate;

- (id)init;
- (void)killBackgroundThread;

- (void)startStop;
- (bool)isRunning;
- (void)clear;

- (AMStave *)getStave;
- (AMBar *)getActualBar;

@end