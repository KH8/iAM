//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@protocol AMSequencerDelegate <NSObject>

@required

- (void) sequencerHasStarted;
- (void) sequencerHasStopped;

@end

@interface AMSequencer : NSObject
{
    // Delegate to respond back
    id <AMSequencerDelegate> _delegate;

}
@property (nonatomic,strong) id delegate;

@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;

- (void)initializeWithStave: (AMStave*)amStave;
- (void)killBackgroundThread;

- (void)startStop;
- (void)setLengthToBePlayed: (int)aLength;
- (NSUInteger)getLengthToBePlayed;

@end