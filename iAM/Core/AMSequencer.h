//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@protocol SequencerDelegate <NSObject>

@required

- (void) sequencerHasStarted;
- (void) sequencerHasStopped;

@end

@interface AMSequencer : NSObject
{
    // Delegate to respond back
    id <SequencerDelegate> _delegate;

}
@property (nonatomic,strong) id delegate;

-(void)initializeWithStave: (AMStave*)amStave;
-(void)startStop;

@end