//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@protocol AMSequenceDelegate <NSObject>

@required

- (void) rowHasBeenTriggered: (NSInteger)row;

@end

@interface AMSequence : NSObject
{
    // Delegate to respond back
    id <AMSequenceDelegate> _delegate;

}
@property (nonatomic,strong) id delegate;

@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

- (void)initializeWithStave: (AMStave*)amStave;
- (void)killBackgroundThread;

- (void)startStop;
- (bool)isRunning;

- (void)setLengthToBePlayed: (NSInteger)aLength;
- (NSInteger)getLengthToBePlayed;
- (void)setTempo: (NSInteger)aTempo;
- (NSInteger)getTempo;

@end