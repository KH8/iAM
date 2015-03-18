//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencerSingleton.h"
#import "AMSequencer.h"

@implementation AMSequencerSingleton

@synthesize sequencer;
@synthesize arrayOfSequences;

#pragma mark Singleton Methods

+ (id)sharedSequencer {
    static AMSequencerSingleton *sharedMySequencer = nil;
    @synchronized(self) {
        if (sharedMySequencer == nil)
            sharedMySequencer = [[self alloc] init];
    }
    return sharedMySequencer;
}

- (id)init {
    if (self = [super init]) {
        sequencer = [[AMSequencer alloc] init];
        arrayOfSequences = [[NSMutableArray alloc] init];
        [arrayOfSequences addObject:sequencer.getSequence];
    }
    return self;
}

- (void)dealloc {
}

@end
